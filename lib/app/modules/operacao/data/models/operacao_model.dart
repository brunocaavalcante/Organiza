import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organiza2/app/modules/categoria/data/models/categoria_model.dart';
import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';

class OperacaoModel {
  /// Converte entity para Firestore
  static Map<String, dynamic> toFirestore(Operacao operacao) {
    return {
      'descricao': operacao.descricao,
      'titulo': operacao.titulo,
      'status': operacao.status,
      'dataCadastro': operacao.dataCadastro != null
          ? Timestamp.fromDate(operacao.dataCadastro!.toLocal())
          : null,
      'dataReferencia': operacao.dataReferencia != null
          ? Timestamp.fromDate(operacao.dataReferencia!.toLocal())
          : null,
      'dataVencimento': operacao.dataVencimento != null
          ? Timestamp.fromDate(operacao.dataVencimento!.toLocal())
          : null,
      'id': operacao.id,
      'urlComprovante': operacao.urlComprovante,
      'refImage': operacao.refImage,
      'valor': operacao.valor,
      'totalParcelas': operacao.totalParcelas,
      'parcelaAtual': operacao.parcelaAtual,
      'repetir': operacao.repetir,
      'tipoOperacao': operacao.tipoOperacao,
      'tipoFrequencia': operacao.tipoFrequencia,
      'categoria': operacao.categoria != null
          ? CategoriaModel.fromEntity(operacao.categoria!).toJson()
          : null,
      'afetarTotalizadores': operacao.afetarTotalizadores,
      'diaVencimento': operacao.diaVencimento,
    };
  }

  /// Converte dados do Firestore para entity
  static Operacao fromFirestore(Map<String, dynamic> map, String documentId) {
    return Operacao(
      id: documentId,
      descricao: map['descricao'] ?? '',
      titulo: map['titulo'] ?? '',
      urlComprovante: map['urlComprovante'] ?? '',
      refImage: map['refImage'] ?? '',
      status: map['status'],
      valor: (map['valor'] ?? 0).toDouble(),
      totalParcelas: map['totalParcelas'] ?? 0,
      parcelaAtual: map['parcelaAtual'] ?? 0,
      parcelasPagas: map['parcelasPagas'] ?? 0,
      tipoFrequencia: map['tipoFrequencia'],
      repetir: map['repetir'] ?? false,
      afetarTotalizadores: map['afetarTotalizadores'] ?? true,
      tipoOperacao: map['tipoOperacao'],
      diaVencimento: map['diaVencimento'] ?? 0,
      dataCadastro: map['dataCadastro'] != null
          ? (map['dataCadastro'] as Timestamp).toDate().toLocal()
          : null,
      dataReferencia: map['dataReferencia'] != null
          ? (map['dataReferencia'] as Timestamp).toDate().toLocal()
          : null,
      dataVencimento: map['dataVencimento'] != null
          ? (map['dataVencimento'] as Timestamp).toDate().toLocal()
          : null,
      categoria: map['categoria'] != null
          ? CategoriaModel.fromJson(map['categoria'] as Map<String, dynamic>)
              .toEntity()
          : null,
    );
  }
}
