import 'package:app/pages/reports/report_pizza_page.dart';
import 'package:app/services/usuario_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/enums.dart';
import '../../models/operacao.dart';
import '../../services/alert_service.dart';
import '../../services/operacao_service.dart';

class HomeReportPage extends StatefulWidget {
  const HomeReportPage({super.key});

  @override
  State<HomeReportPage> createState() => _HomeReportPageState();
}

class _HomeReportPageState extends State<HomeReportPage> {
  UserService? auth;
  int month = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<UserService>(context);

    return Scaffold(
        body: ListView(children: [
      containeData(),
      relatorioDespesasPorCategoriaPie(),
      reportBarra()
    ]));
  }

  containeData() {
    var tam = MediaQuery.of(context).size;
    return Container(
        width: tam.width * 0.25,
        margin: EdgeInsets.only(
            top: tam.height * 0.05,
            bottom: tam.height * 0.02,
            left: tam.width * 0.03),
        child: OutlinedButton.icon(
            onPressed: () {
              AlertService.alertSelect(context, "Meses", null, mes, () => null)
                  .then((valueFromDialog) {
                month = valueFromDialog ?? month;
                setState(() {});
              });
            },
            icon: const Icon(Icons.calendar_month),
            label: Text("${mes[month]}/${DateTime.now().year}")));
  }

  relatorioDespesasPorCategoriaPie() {
    List<ChartModel> lista = [];

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('operacoes')
            .doc(auth!.usuario!.uid.toString())
            .collection("${month}${DateTime.now().year}")
            .where("tipoOperacao", isEqualTo: 1)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Algo deu errado.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          lista = obtemListaCategoria(snapshot);
          return ReportPizza(
              lista: lista,
              title:
                  "Despesas por categoria - ${mes[month]}/${DateTime.now().year}",
              data: DateTime.now(),
              updateData: null);
        });
  }

  List<ChartModel> obtemListaCategoria(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<ChartModel> lista = [];
    for (var element in snapshot.data!.docs) {
      Map<String, dynamic> data = element.data()! as Map<String, dynamic>;
      data["Id"] = element.id;
      var operacao = Operacao().toEntity(data);

      if (lista.any(
          (element) => element.text.contains(operacao.categoria!.descricao))) {
        int index = lista.indexWhere((element) =>
            element.text.contains((operacao.categoria!.descricao)));
        lista[index].value += operacao.valor;
      } else {
        var item = ChartModel();
        item.cor = Color(operacao.categoria!.color);
        item.text = operacao.categoria!.descricao;
        item.value = operacao.valor;
        lista.add(item);
      }
    }
    return lista;
  }

  reportBarra() {
    return FutureBuilder(
        future: Provider.of<OperacaoService>(context, listen: false)
            .buscarOperacoesPorMesAno(month, DateTime.now().year),
        builder:
            (BuildContext context, AsyncSnapshot<List<Operacao>> snapshot) {
          if (snapshot.hasData) {
            List<ChartModel> lista = despesaXreceita(snapshot);
            return Container(
                height: 550,
                child: SfCartesianChart(
                  title: ChartTitle(
                      text:
                          "Despesas X Receitas - ${mes[month]}/${DateTime.now().year}"),
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(),
                  series: <ChartSeries>[
                    ColumnSeries<ChartModel, String>(
                        dataSource: lista,
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.inside),
                        pointColorMapper: (ChartModel data, _) => data.cor,
                        xValueMapper: (ChartModel data, _) => data.text,
                        yValueMapper: (ChartModel data, _) => data.value)
                  ],
                ));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  List<ChartModel> despesaXreceita(AsyncSnapshot<List<Operacao>> lista) {
    List<ChartModel> retorno = [];
    double totalDespesa = 0;
    double totalReceita = 0;

    for (var item in lista.data!) {
      if (item.tipoOperacao == TipoOperacao.Recibo.index) {
        totalReceita += item.valor;
      } else if (item.tipoOperacao == TipoOperacao.Despesa.index) {
        totalDespesa += item.valor;
      }
    }
    var depesa = ChartModel();
    depesa.text = "Despesas";
    depesa.value = totalDespesa;
    depesa.cor = Theme.of(context).colorScheme.error;
    var receita = ChartModel();
    receita.text = "Receitas";
    receita.value = totalReceita;
    receita.cor = Colors.blue;

    retorno.add(depesa);
    retorno.add(receita);
    return retorno;
  }
}
