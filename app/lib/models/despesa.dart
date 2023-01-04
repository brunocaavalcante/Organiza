import 'package:app/models/categoria.dart';
import '../core/date_ultils.dart';

class Despesa {
  String id = "";
  String descricao = "";
  double valor = 0;
  CategoriaDepesa? categoria;
  Status? status;
  DateTime? dataCadastro;

  Map<String, Object?> toJson() {
    return {
      'descricao': descricao,
      'status': status,
      'dataCadastro': dataCadastro,
      'id': id,
      'valor': valor
    };
  }

  Despesa toEntity(Map<String, dynamic> map) {
    status = map['status'];
    descricao = map['descricao'];
    dataCadastro =
        DateUltils.onlyDate(map['dataCadastro'].toDate() as DateTime);
    id = map['id'];
    valor = map['valor'];
    return this;
  }
}

enum Status { Pago, Pendente }
