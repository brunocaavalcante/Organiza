import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/report/chartdata.dart';
import '../../models/report/report.dart';

class ReportBarra extends StatefulWidget {
  Report report;
  ReportBarra({super.key, required this.report});

  @override
  State<ReportBarra> createState() => _ReportBarraState();
}

class _ReportBarraState extends State<ReportBarra> {
  @override
  Widget build(BuildContext context) {
    return reportBarra();
  }

  reportBarra() {
    return SizedBox(
        height: 550,
        child: SfCartesianChart(
            title: ChartTitle(text: widget.report.name ?? ""),
            tooltipBehavior: TooltipBehavior(enable: true),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(),
            series: <ChartSeries>[
              ColumnSeries<ChartData, String>(
                  dataSource: widget.report.listData ?? [],
                  dataLabelSettings: const DataLabelSettings(isVisible: false),
                  pointColorMapper: (ChartData data, _) => data.cor,
                  xValueMapper: (ChartData data, _) => data.text,
                  yValueMapper: (ChartData data, _) => data.value)
            ]));
  }
}
