import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organiza2/app/modules/operacao/domain/entities/operacao_shared.dart';

class OperacaoSharedModel {
  /// Converte entity para Firestore
  static Map<String, dynamic> toFirestore(OperacaoShared operacaoShared) {
    return {
      'descricao': operacaoShared.descricao,
      'titulo': operacaoShared.titulo,
      'status': operacaoShared.status,
      'dataCadastro': operacaoShared.dataCadastro != null
          ? Timestamp.fromDate(operacaoShared.dataCadastro!.toLocal())
          : null,
      'dataReferencia': operacaoShared.dataReferencia != null
          ? Timestamp.fromDate(operacaoShared.dataReferencia!.toLocal())
          : null,
      'valor': operacaoShared.valor,
      'tipoOperacao': operacaoShared.tipoOperacao,
      'idProprietario': operacaoShared.idProprietario,
      'idDestinatario': operacaoShared.idDestinatario,
      'id': operacaoShared.id,
      'imgProprietario': operacaoShared.imgProprietario,
      'imgDestinatario': operacaoShared.imgDestinatario,
      'totalParcelas': operacaoShared.totalParcelas,
      'idOperacao': operacaoShared.idOperacao,
      'justificativa': operacaoShared.justificativa,
    };
  }

  /// Converte dados do Firestore para entity
  static OperacaoShared fromFirestore(
      Map<String, dynamic> map, String documentId) {
    return OperacaoShared(
      id: documentId,
      descricao: map['descricao'] ?? '',
      titulo: map['titulo'] ?? '',
      valor: (map['valor'] ?? 0).toDouble(),
      status: map['status'],
      tipoOperacao: map['tipoOperacao'],
      dataCadastro: map['dataCadastro'] != null
          ? (map['dataCadastro'] as Timestamp).toDate().toLocal()
          : null,
      dataReferencia: map['dataReferencia'] != null
          ? (map['dataReferencia'] as Timestamp).toDate().toLocal()
          : null,
      idProprietario: map['idProprietario'] ?? '',
      idDestinatario: map['idDestinatario'] ?? '',
      idOperacao: map['idOperacao'] ?? '',
      imgProprietario: map['imgProprietario'] ?? '',
      imgDestinatario: map['imgDestinatario'] ?? '',
      totalParcelas: map['totalParcelas'] ?? 0,
      justificativa: map['justificativa'] ?? '',
    );
  }
}
