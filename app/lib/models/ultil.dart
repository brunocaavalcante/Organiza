class Ultil {
  double? CoverterValorToDecimal(String valorTxt) {
    return double.tryParse(valorTxt
        .replaceRange(0, 3, "")
        .replaceAll(".", "")
        .replaceAll(",", "."));
  }
}
