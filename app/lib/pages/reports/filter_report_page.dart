import 'package:app/core/widgets/widget_ultil.dart';
import 'package:app/models/operacao.dart';
import 'package:app/pages/reports/report_line.dart';
import 'package:app/services/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/enums.dart';
import '../../models/report/chartdata.dart';
import '../../services/operacao_service.dart';

class FilterReportPage extends StatefulWidget {
  const FilterReportPage({super.key});

  @override
  State<FilterReportPage> createState() => _FilterReportPageState();
}

class _FilterReportPageState extends State<FilterReportPage> {
  List<Operacao> lista = [];
  List<Operacao> listaAux = [];
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUltil.barWithArrowBackIos(
          context, "Selecione até 5 opções:", ""),
      body: FutureBuilder(
          future:
              Provider.of<OperacaoService>(context).buscarTodasOperacoesAno(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              lista = snapshot.data ?? [];
              carregarOperacoes();
              return Center(child: body());
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return Container();
          }),
    );
  }

  Widget body() {
    return Column(children: [
      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      Container(
          height: MediaQuery.of(context).size.height * 0.74,
          width: MediaQuery.of(context).size.width * 0.98,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(10), // Define o raio das bordas
          ),
          child: ListView(children: [
            Column(
                children: listaAux.map((Operacao operacao) {
              return returnCardItem(operacao);
            }).toList())
          ])),
      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
      SizedBox(
          height: MediaQuery.of(context).size.height * 0.07,
          width: MediaQuery.of(context).size.width * 0.98,
          child: WidgetUltil.returnButton(
              "Gerar Relatório", Icons.get_app, btnGerarRelatorio))
    ]);
  }

  Widget returnCardItem(Operacao operacao) {
    return Card(
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: operacao.isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent),
            child: ListTile(
                onTap: () {
                  setState(() {
                    if (operacao.isSelected) {
                      operacao.isSelected = !operacao.isSelected;
                      count--;
                    } else if (count < 5) {
                      operacao.isSelected = !operacao.isSelected;
                      count++;
                    } else {
                      AlertService.alertAviso(context, "Alerta!",
                          "Apenas 5 itens podem ser selecionados!");
                    }
                  });
                },
                title: Text(
                    operacao.titulo == ""
                        ? operacao.descricao
                        : operacao.titulo,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: operacao.isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                    )))));
  }

  List<Operacao> carregarOperacoes() {
    lista = lista
        .where((x) => x.repetir && x.tipoOperacao == 1 && x.afetarTotalizadores)
        .toList();

    for (var item in lista) {
      if (item.titulo.isNotEmpty) {
        if (listaAux.any((x) =>
                x.titulo.trim().contains(item.titulo.trim()) ||
                x.descricao.trim().contains(item.descricao.trim())) ==
            false) {
          listaAux.add(item);
        }
      }
      if (item.descricao.isNotEmpty) {
        if (listaAux.any((x) =>
                x.descricao.trim().contains(item.descricao.trim()) ||
                x.titulo.trim().contains(item.titulo.trim())) ==
            false) {
          listaAux.add(item);
        }
      }
    }
    return listaAux;
  }

  btnGerarRelatorio() {
    List<Operacao> dados = [];
    var operacoesSelecionadas = listaAux.where((x) => x.isSelected);

    for (var item in operacoesSelecionadas) {
      var listOperacoes = lista.where((x) =>
          x.descricao.trim().contains(item.descricao.trim()) ||
          x.titulo.trim().contains(item.titulo.trim()));

      dados.addAll(listOperacoes);
    }

    List<ChartSeries> list = <ChartSeries>[];
    for (var op in operacoesSelecionadas) {
      var item = LineSeries<ChartData, String>(
          name: op.titulo == "" ? op.descricao : op.titulo,
          enableTooltip: true,
          dataSource: retornaData(op),
          xValueMapper: (ChartData data, _) => data.text,
          yValueMapper: (ChartData data, _) => data.value);

      list.add(item);
    }

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ReportLine(list: list)));
  }

  List<ChartData> retornaData(Operacao op) {
    List<ChartData> retorno = [];

    var itens = lista.where((x) =>
        x.descricao.trim().contains(op.descricao.trim()) ||
        x.titulo.trim().contains(op.titulo.trim()));

    for (var item in itens) {
      retorno.add(
          ChartData(mesesAbreviado[item.dataReferencia!.month], item.valor));
    }

    return retorno;
  }
}
