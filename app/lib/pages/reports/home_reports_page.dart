import 'package:app/pages/reports/report_barra.dart';
import 'package:app/pages/reports/report_pizza.dart';
import 'package:app/services/usuario_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/chartmodel.dart';
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
      ReportBarra(month: month)
    ]));
  }

  containeData() {
    var tam = MediaQuery.of(context).size;
    return Container(
        width: tam.width * 0.25,
        margin: EdgeInsets.only(
            top: tam.height * 0.05,
            bottom: tam.height * 0.02,
            left: tam.width * 0.03,
            right: tam.width * 0.03),
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
}
