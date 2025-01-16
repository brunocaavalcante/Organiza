import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/entity.dart';

class OperacaoShared extends Entity {
  String descricao = "";
  String titulo = "";
  double valor = 0;
  int? status;
  int? tipoOperacao;
  int totalParcelas = 0;
  DateTime? dataCadastro;
  DateTime? dataReferencia;
  String idProprietario = "";
  String idDestinatario = "";
  String idOperacao = "";
  String imgProprietario = "";
  String imgDestinatario = "";

  Map<String, Object?> toJson() {
    return {
      'descricao': descricao,
      'titulo': titulo,
      'status': status,
      'dataCadastro': dataCadastro != null
          ? Timestamp.fromDate(dataCadastro!.toLocal())
          : null,
      'dataReferencia': dataReferencia != null
          ? Timestamp.fromDate(dataReferencia!.toLocal())
          : null,
      'valor': valor,
      'tipoOperacao': tipoOperacao,
      'idProprietario': idProprietario,
      'idDestinatario': idDestinatario,
      'id': id,
      'imgProprietario': imgProprietario,
      'imgDestinatario': imgDestinatario,
      'totalParcelas': totalParcelas,
      'idOperacao': idOperacao
    };
  }

  OperacaoShared toEntity(Map<String, dynamic> map) {
    descricao = map['descricao'] ?? '';
    titulo = map['titulo'] ?? '';
    valor = map['valor'] ?? 0;
    status = map['status'];
    tipoOperacao = map['tipoOperacao'];
    dataCadastro = map['dataCadastro']?.toDate().toLocal();
    dataReferencia = map['dataReferencia']?.toDate().toLocal();
    idProprietario = map['idProprietario'] ?? '';
    idDestinatario = map['idDestinatario'] ?? '';
    id = map['id'] ?? '';
    idOperacao = map["idOperacao"] ?? '';
    imgProprietario = map['imgProprietario'] ?? '';
    imgDestinatario = map['imgDestinatario'] ?? '';
    totalParcelas = map['totalParcelas'] ?? 0;
    return this;
  }
}
