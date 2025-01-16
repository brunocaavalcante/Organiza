import 'package:intl/intl.dart';

class DateUltils {
  static String formatarData(DateTime? data) {
    if (data != null) {
      var dataFormatada = DateFormat('dd/MM/yyyy').format(data);
      return dataFormatada;
    } else {
      return "";
    }
  }

  static DateTime onlyDate(DateTime data) {
    return DateTime(data.year, data.month, data.day);
  }

  static DateTime? stringToDate(String? data) {
    try {
      return data != null && data != ""
          ? DateFormat('dd/MM/yyyy').parse(data)
          : null;
    } catch (e) {
      return null;
    }
  }
}
