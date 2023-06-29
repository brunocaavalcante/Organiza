// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class DateUltils {
  static formatarData(DateTime? data) {
    if (data != null) {
      var dataFormatada = DateFormat('dd/MM/yyyy').format(data);
      return dataFormatada;
    } else {
      return "";
    }
  }

  static onlyDate(DateTime data) {
    return DateTime(data.year, data.month, data.day);
  }

  static DateTime? stringToDate(String? data) {
    try {
      return data != null && data != ""
          ? DateFormat('dd/MM/yyyy').parse(data)
          : null;
    } catch (Exception) {
      return null;
    }
  }
}
