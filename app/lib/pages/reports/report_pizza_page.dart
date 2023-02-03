import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/enums.dart';

class ReportPizza extends StatefulWidget {
  List<ChartModel> lista;
  String? title;
  DateTime? data;
  Function()? updateData;
  ReportPizza(
      {super.key,
      required this.lista,
      required this.title,
      required this.data,
      required this.updateData});

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
                  title: ChartTitle(text: widget.title ?? ""),
                  legend: Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap),
                  series: <CircularSeries>[
                    PieSeries<ChartModel, String>(
                        dataSource: widget.lista,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        xValueMapper: (ChartModel data, _) => data.text,
                        yValueMapper: (ChartModel data, _) => data.value)
                  ])))
    ]);
  }
}

class ChartModel {
  double value = 0;
  String text = "";
  Color? cor;
}
