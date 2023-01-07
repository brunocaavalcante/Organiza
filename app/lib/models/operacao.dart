import 'package:app/models/categoria.dart';
import '../core/date_ultils.dart';

class Operacao {
  String id = "";
  String descricao = "";
  double valor = 0;
  CategoriaDepesa? categoria;
  int? status;
  int? tipoOperacao;
  DateTime? dataCadastro;
  DateTime? dataReferencia;
  int? totalParcelas = 0;
  int? parcelasPagas = 0;
  bool? repetir = false;

  Map<String, Object?> toJson() {
    return {
      'descricao': descricao,
      'status': status,
      'dataCadastro': dataCadastro,
      'dataReferencia': dataReferencia,
      'id': id,
      'valor': valor,
      'parcelasPagas': parcelasPagas,
      'totalParcelas': totalParcelas,
      'repetir': repetir,
      'tipoOperacao': tipoOperacao
    };
  }

  Operacao toEntity(Map<String, dynamic> map) {
    parcelasPagas = map['parcelasPagas'];
    totalParcelas = map['totalParcelas'];
    repetir = map['repetir'];
    tipoOperacao = map['tipoOperacao'];
    status = map['status'];
    descricao = map['descricao'];
    dataCadastro =
        DateUltils.onlyDate(map['dataCadastro'].toDate() as DateTime);
    dataReferencia =
        DateUltils.onlyDate(map['dataReferencia'].toDate() as DateTime);
    id = map['id'];
    valor = map['valor'];
    return this;
  }
}

enum Status { Pago, Pendente }

enum TipoOperacao { Despesa, Recibo }
