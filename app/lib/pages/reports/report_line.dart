import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/report/chartdata.dart';
import '../../models/report/report.dart';

class ReportLine extends StatefulWidget {
  List<Report>? list;
  ReportLine({super.key});

  @override
  State<ReportLine> createState() => _ReportLineState();
}

class _ReportLineState extends State<ReportLine> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: SfCartesianChart(
                legend: Legend(position: LegendPosition.top, isVisible: true),
                // Enables the tooltip for all the series in chart
                tooltipBehavior: _tooltipBehavior,
                // Initialize category axis
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  // Initialize line series
                  LineSeries<ChartData, String>(
                      name: "agua",
                      enableTooltip: true,
                      dataSource: [
                        // Bind data source
                        ChartData('Jan', 35),
                        ChartData('Feb', 28),
                        ChartData('Mar', 34),
                        ChartData('Apr', 32),
                        ChartData('May', 40)
                      ],
                      xValueMapper: (ChartData data, _) => data.text,
                      yValueMapper: (ChartData data, _) => data.value),
                  LineSeries<ChartData, String>(
                      name: "Luz",
                      // Enables the tooltip for individual series
                      enableTooltip: true,
                      dataSource: [
                        // Bind data source
                        ChartData('Jan', 40),
                        ChartData('Feb', 20),
                        ChartData('Mar', 39),
                        ChartData('Apr', 35),
                        ChartData('May', 49)
                      ],
                      xValueMapper: (ChartData data, _) => data.text,
                      yValueMapper: (ChartData data, _) => data.value)
                ])));
  }
}
