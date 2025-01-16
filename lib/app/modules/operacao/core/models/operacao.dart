import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organiza2/app/core/models/categoria.dart';
import '../../../../core/models/entity.dart';

class Operacao extends Entity {
  String descricao = "";
  String titulo = "";
  String urlComprovante = "";
  String refImage = "";
  double valor = 0;
  Categoria? categoria;
  int? status;
  int? tipoOperacao;
  int? tipoFrequencia;
  int diaVencimento = 0;
  DateTime? dataCadastro;
  DateTime? dataReferencia;
  DateTime? dataVencimento;
  int totalParcelas = 0;
  int parcelasPagas = 0;
  int parcelaAtual = 0;
  bool repetir = false;
  bool afetarTotalizadores = false;

  Map<String, Object?> toJson() {
    return {
      'descricao': descricao,
      'titulo': titulo,
      'status': status,
      'dataCadastro': Timestamp.fromDate(dataCadastro!.toLocal()),
      'dataReferencia': Timestamp.fromDate(dataReferencia!.toLocal()),
      'dataVencimento': dataVencimento != null
          ? Timestamp.fromDate(dataVencimento!.toLocal())
          : null,
      'id': id,
      'urlComprovante': urlComprovante,
      'refImage': refImage,
      'valor': valor,
      'totalParcelas': totalParcelas,
      'parcelaAtual': parcelaAtual,
      'repetir': repetir,
      'tipoOperacao': tipoOperacao,
      'tipoFrequencia': tipoFrequencia,
      'categoria': categoria!.toJson(),
      'afetarTotalizadores': afetarTotalizadores,
      'diaVencimento': diaVencimento
    };
  }

  Operacao toEntity(Map<String, dynamic> map) {
    totalParcelas = map['totalParcelas'] ?? 0;
    parcelaAtual = map['parcelaAtual'] ?? 0;
    tipoFrequencia = map['tipoFrequencia'];
    repetir = map['repetir'];
    afetarTotalizadores = map['afetarTotalizadores'] ?? true;
    tipoOperacao = map['tipoOperacao'];
    urlComprovante = map['urlComprovante'] ?? '';
    refImage = map['refImage'] ?? '';
    status = map['status'];
    descricao = map['descricao'];
    titulo = map['titulo'] ?? '';
    diaVencimento = map['diaVencimento'] ?? 0;
    dataCadastro = map['dataCadastro'].toDate().toLocal();
    dataReferencia = map['dataReferencia'].toDate().toLocal();
    dataVencimento = map['dataVencimento'] != null
        ? map['dataVencimento'].toDate().toLocal()
        : null;
    id = map['id'];
    valor = map['valor'];
    categoria = Categoria().toEntity(map['categoria']);
    return this;
  }
}
