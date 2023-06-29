import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../core/widgets/widget_ultil.dart';
import '../../models/report/chartdata.dart';
import '../../models/report/report.dart';

class ReportLine extends StatefulWidget {
  List<ChartSeries> list = <ChartSeries>[];
  ReportLine({super.key, required this.list});

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
    return Scaffold(
        appBar: WidgetUltil.barWithArrowBackIos(
            context, "Relatório Evolucao Opeção:", ""),
        body: Center(
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: SfCartesianChart(
                    legend:
                        Legend(position: LegendPosition.top, isVisible: true),
                    // Enables the tooltip for all the series in chart
                    tooltipBehavior: _tooltipBehavior,
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(),
                    series: widget.list))));
  }
}
