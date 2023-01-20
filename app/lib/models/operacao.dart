import 'package:app/models/categoria.dart';
import '../core/date_ultils.dart';

class Operacao {
  String id = "";
  String descricao = "";
  double valor = 0;
  Categoria? categoria;
  int? status;
  int? tipoOperacao;
  int? tipoFrequencia;
  DateTime? dataCadastro;
  DateTime? dataReferencia;
  int totalParcelas = 0;
  int parcelasPagas = 0;
  int parcelaAtual = 0;
  bool repetir = false;

  Map<String, Object?> toJson() {
    return {
      'descricao': descricao,
      'status': status,
      'dataCadastro': dataCadastro,
      'dataReferencia': dataReferencia,
      'id': id,
      'valor': valor,
      'totalParcelas': totalParcelas,
      'parcelaAtual': parcelaAtual,
      'repetir': repetir,
      'tipoOperacao': tipoOperacao,
      'tipoFrequencia': tipoFrequencia,
      'categoria': categoria!.toJson()
    };
  }

  Operacao toEntity(Map<String, dynamic> map) {
    totalParcelas = map['totalParcelas'] ?? 0;
    parcelaAtual = map['parcelaAtual'] ?? 0;
    tipoFrequencia = map['tipoFrequencia'];
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
    categoria = Categoria().toEntity(map['categoria']);
    return this;
  }
}

enum Status { Pago, Pendente }

enum TipoOperacao { Nenhum, Despesa, Recibo }

enum TipoFrequencia { Nunca, AnoTodo, Parcelado }
