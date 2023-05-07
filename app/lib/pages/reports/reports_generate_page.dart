// ignore_for_file: unrelated_type_equality_checks

import 'package:app/pages/reports/filter_report_page.dart';
import 'package:app/pages/reports/report_barra.dart';
import 'package:app/pages/reports/report_pizza.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/report/chartdata.dart';
import '../../models/enums.dart';
import '../../models/operacao.dart';
import '../../models/report/report.dart';
import '../../services/alert_service.dart';
import '../../services/usuario_service.dart';

class ReportGeneratePage extends StatefulWidget {
  Report report;
  ReportGeneratePage({super.key, required this.report});

  @override
  State<ReportGeneratePage> createState() => _ReportGeneratePageState();
}

class _ReportGeneratePageState extends State<ReportGeneratePage> {
  UserService? auth;
  int month = DateTime.now().month;
  Stream<QuerySnapshot<Object?>>? queryStream;

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<UserService>(context);
    return Scaffold(body: ListView(children: [containeData(), obterReports()]));
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

  obterReports() {
    queryStream = FirebaseFirestore.instance
        .collection('operacoes')
        .doc(auth!.usuario!.uid.toString())
        .collection("$month${DateTime.now().year}")
        .snapshots();
    var teste;
    if (widget.report.tipo!.id == 3) {
      //queryStream.
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: teste,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Algo deu errado.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var t = snapshot.data!.data();
          return Container(); //gerarRelatorio(snapshot);
        });

    return StreamBuilder<QuerySnapshot>(
        stream: teste,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Algo deu errado.');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return gerarRelatorio(snapshot);
        });
  }

  Widget returnReport() {
    if (widget.report.tipo!.id == 1) {
      return ReportPizza(report: widget.report);
    } else if (widget.report.tipo!.id == 2) {
      return ReportBarra(report: widget.report);
    } else if (widget.report.tipo!.id == 3) {
      return Container();
    }
    return Container();
  }

//retorna lista chard de acordo com relatorio selecionado
  Widget gerarRelatorio(AsyncSnapshot<QuerySnapshot> snapshot) {
    switch (widget.report.id) {
      case 1:
        widget.report.listData = obtemListaCategoria(snapshot);
        return returnReport();

      case 2:
        widget.report.listData = despesaXreceita(snapshot);
        return returnReport();

      case 3:
        return const FilterReportPage();
      default:
        return Container();
    }
  }

//REGION REPORTS DESPESA X RECEITAS
  List<ChartData> despesaXreceita(AsyncSnapshot<QuerySnapshot> lista) {
    List<ChartData> retorno = [];
    double totalDespesa = 0;
    double totalReceita = 0;

    for (var element in lista.data!.docs) {
      Map<String, dynamic> data = element.data()! as Map<String, dynamic>;
      data["Id"] = element.id;
      var item = Operacao().toEntity(data);

      if (item.tipoOperacao == TipoOperacao.Recibo.index) {
        totalReceita += item.valor;
      } else if (item.tipoOperacao == TipoOperacao.Despesa.index) {
        totalDespesa += item.valor;
      }
    }
    var depesa = ChartData(
        "Despesas", totalDespesa, Theme.of(context).colorScheme.error);

    var receita = ChartData("Receitas", totalReceita, Colors.blue);

    retorno.add(receita);
    retorno.add(depesa);
    return retorno;
  }

//REGION REPORTS CATEGORIA
  List<ChartData> obtemListaCategoria(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<ChartData> lista = [];
    for (var element in snapshot.data!.docs) {
      Map<String, dynamic> data = element.data()! as Map<String, dynamic>;
      data["Id"] = element.id;
      var operacao = Operacao().toEntity(data);

      if (operacao.tipoOperacao == TipoOperacao.Recibo.index) continue;

      if (lista.any(
          (element) => element.text.contains(operacao.categoria!.descricao))) {
        int index = lista.indexWhere((element) =>
            element.text.contains((operacao.categoria!.descricao)));
        lista[index].value += operacao.valor;
      } else {
        var item = ChartData(operacao.categoria!.descricao, operacao.valor,
            Color(operacao.categoria!.color));
        lista.add(item);
      }
    }
    return lista;
  }

//REGION REPORTS OPERACAO
  List<Report> obtemListaOperacaoMeses(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Operacao> lista = [];
    List<Report> list = [];

    for (var element in snapshot.data!.docs) {
      Map<String, dynamic> data = element.data()! as Map<String, dynamic>;
      data["Id"] = element.id;
      var operacao = Operacao().toEntity(data);

      if (operacao.tipoOperacao == TipoOperacao.Recibo.index ||
          operacao.tipoFrequencia != TipoFrequencia.AnoTodo) continue;

      lista.add(operacao);
    }

    for (var item in lista) {
      var index = list.indexWhere(
          (x) => x.name!.toUpperCase() == item.titulo.toUpperCase());

      if (index > 0) {
        ChartData chart =
            ChartData(meses[item.dataReferencia!.month], item.valor);
        list[index].listData!.add(chart);
      } else {
        Report report = Report();
        report.name = item.titulo;
        report.listData = [];
        ChartData chart =
            ChartData(meses[item.dataReferencia!.month], item.valor);
        report.listData!.add(chart);
        list.add(report);
      }
    }
    return list;
  }
}
