import 'package:app/models/categoria.dart';

class Despesa {
  String id = "";
  String decricao = "";
  double valor = 0;
  CategoriaDepesa? categoria;
  Status? status;
}

enum Status { Pago, Pendente }
