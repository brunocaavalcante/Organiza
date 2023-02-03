import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/chartmodel.dart';
import '../../models/enums.dart';
import '../../models/operacao.dart';
import '../../services/operacao_service.dart';

class ReportBarra extends StatefulWidget {
  int month;
  ReportBarra({super.key, required this.month});

  @override
  State<ReportBarra> createState() => _ReportBarraState();
}

class _ReportBarraState extends State<ReportBarra> {
  @override
  Widget build(BuildContext context) {
    return reportBarra();
  }

  reportBarra() {
    return FutureBuilder(
        future: Provider.of<OperacaoService>(context, listen: false)
            .buscarOperacoesPorMesAno(widget.month, DateTime.now().year),
        builder:
            (BuildContext context, AsyncSnapshot<List<Operacao>> snapshot) {
          if (snapshot.hasData) {
            List<ChartModel> lista = despesaXreceita(snapshot);
            return SizedBox(
                height: 550,
                child: SfCartesianChart(
                  title: ChartTitle(
                      text:
                          "Despesas X Receitas - ${mes[widget.month]}/${DateTime.now().year}"),
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
