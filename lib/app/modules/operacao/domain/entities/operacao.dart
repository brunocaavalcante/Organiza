import 'package:organiza2/app/modules/categoria/domain/entities/categoria.dart';

/// Entidade de domínio para Operação (transação financeira)
class Operacao {
  final String? id;
  final String descricao;
  final String titulo;
  final String urlComprovante;
  final String refImage;
  final double valor;
  final Categoria? categoria;
  final int? status;
  final int? tipoOperacao;
  final int? tipoFrequencia;
  final int diaVencimento;
  final DateTime? dataCadastro;
  final DateTime? dataReferencia;
  final DateTime? dataVencimento;
  final int totalParcelas;
  final int parcelasPagas;
  final int parcelaAtual;
  final bool repetir;
  final bool afetarTotalizadores;

  Operacao({
    this.id,
    this.descricao = "",
    this.titulo = "",
    this.urlComprovante = "",
    this.refImage = "",
    this.valor = 0,
    this.categoria,
    this.status,
    this.tipoOperacao,
    this.tipoFrequencia,
    this.diaVencimento = 0,
    this.dataCadastro,
    this.dataReferencia,
    this.dataVencimento,
    this.totalParcelas = 0,
    this.parcelasPagas = 0,
    this.parcelaAtual = 0,
    this.repetir = false,
    this.afetarTotalizadores = false,
  });

  /// Cria uma cópia da operação com campos alterados
  Operacao copyWith({
    String? id,
    String? descricao,
    String? titulo,
    String? urlComprovante,
    String? refImage,
    double? valor,
    Categoria? categoria,
    int? status,
    int? tipoOperacao,
    int? tipoFrequencia,
    int? diaVencimento,
    DateTime? dataCadastro,
    DateTime? dataReferencia,
    DateTime? dataVencimento,
    int? totalParcelas,
    int? parcelasPagas,
    int? parcelaAtual,
    bool? repetir,
    bool? afetarTotalizadores,
  }) {
    return Operacao(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      titulo: titulo ?? this.titulo,
      urlComprovante: urlComprovante ?? this.urlComprovante,
      refImage: refImage ?? this.refImage,
      valor: valor ?? this.valor,
      categoria: categoria ?? this.categoria,
      status: status ?? this.status,
      tipoOperacao: tipoOperacao ?? this.tipoOperacao,
      tipoFrequencia: tipoFrequencia ?? this.tipoFrequencia,
      diaVencimento: diaVencimento ?? this.diaVencimento,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataReferencia: dataReferencia ?? this.dataReferencia,
      dataVencimento: dataVencimento ?? this.dataVencimento,
      totalParcelas: totalParcelas ?? this.totalParcelas,
      parcelasPagas: parcelasPagas ?? this.parcelasPagas,
      parcelaAtual: parcelaAtual ?? this.parcelaAtual,
      repetir: repetir ?? this.repetir,
      afetarTotalizadores: afetarTotalizadores ?? this.afetarTotalizadores,
    );
  }
}
