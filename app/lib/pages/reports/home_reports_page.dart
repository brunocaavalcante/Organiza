import 'package:app/services/alert_service.dart';
import 'package:app/services/usuario_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/operacao.dart';

class HomeReportPage extends StatefulWidget {
  const HomeReportPage({super.key});

  @override
  State<HomeReportPage> createState() => _HomeReportPageState();
}

class _HomeReportPageState extends State<HomeReportPage> {
  UserService? auth;
  int month = 12;

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<UserService>(context);

    return Scaffold(
        body: ListView(children: [
      Column(children: [containeTitle(), relatorioDespesasPorCategoriaPie()])
    ]));
  }

  relatorioDespesasPorCategoriaPie() {
    List<ChartCircularModel> lista = [];

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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          lista = obtemListaCategoria(snapshot);
          return Center(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: SfCircularChart(
                      legend: Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap),
                      series: <CircularSeries>[
                        PieSeries<ChartCircularModel, String>(
                            dataSource: lista,
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                            xValueMapper: (ChartCircularModel data, _) =>
                                data.text,
                            yValueMapper: (ChartCircularModel data, _) =>
                                data.value)
                      ])));
        });
  }

  List<ChartCircularModel> obtemListaCategoria(
      AsyncSnapshot<QuerySnapshot> snapshot) {
    List<ChartCircularModel> lista = [];
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
        var item = ChartCircularModel();
        item.cor = Color(operacao.categoria!.color);
        item.text = operacao.categoria!.descricao;
        item.value = operacao.valor;
        lista.add(item);
      }
    }
    return lista;
  }

  containeTitle() {
    var tam = MediaQuery.of(context).size;
    return Container(
        margin:
            EdgeInsets.only(top: tam.height * 0.08, bottom: tam.height * 0.02),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          const Text(
            "Despesas por categoria",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          OutlinedButton.icon(
              onPressed: () {
                AlertService.alertSelect(
                        context, "Meses", null, mes, () => null)
                    .then((valueFromDialog) {
                  month = valueFromDialog ?? month;
                  setState(() {});
                });
              },
              icon: const Icon(Icons.calendar_month),
              label: Text("${mes[month]}/${DateTime.now().year}"))
        ]));
  }
}

class ChartCircularModel {
  double value = 0;
  String text = "";
  Color? cor;
}
