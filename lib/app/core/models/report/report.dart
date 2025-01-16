import 'package:organiza2/app/core/models/filter_query.dart';
import 'package:organiza2/app/core/models/report/tipo_report.dart';

import 'chartdata.dart';

class Report {
  int? id;
  String? name;
  TipoReport? tipo;
  List<TipoReport>? tipoReports;
  List<FilterQuery>? filtros;
  bool isExpanded = false;
  List<ChartData>? listData;
  DateTime? data;
  Function()? onRefresh;

  Report(
      [this.id,
      this.name,
      this.tipoReports,
      this.tipo,
      this.listData,
      this.data,
      this.onRefresh]);
}
