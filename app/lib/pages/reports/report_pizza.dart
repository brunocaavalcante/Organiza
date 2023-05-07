import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/report/chartdata.dart';
import '../../models/report/report.dart';

class ReportPizza extends StatefulWidget {
  Report report;
  ReportPizza({super.key, required this.report});

  @override
  State<ReportPizza> createState() => _ReportPizzaState();
}

class _ReportPizzaState extends State<ReportPizza> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: SfCircularChart(
                  title: ChartTitle(text: widget.report.name ?? ""),
                  legend: Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap),
                  series: <CircularSeries>[
                    PieSeries<ChartData, String>(
                        dataSource: widget.report.listData,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        xValueMapper: (ChartData data, _) => data.text,
                        yValueMapper: (ChartData data, _) => data.value)
                  ])))
    ]);
  }
}
