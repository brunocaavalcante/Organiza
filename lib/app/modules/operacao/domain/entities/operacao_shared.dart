class OperacaoShared {
  final String? id;
  final String descricao;
  final String titulo;
  final double valor;
  final int? status;
  final int? tipoOperacao;
  final int totalParcelas;
  final DateTime? dataCadastro;
  final DateTime? dataReferencia;
  final String idProprietario;
  final String idDestinatario;
  final String idOperacao;
  final String imgProprietario;
  final String imgDestinatario;
  final String justificativa;

  OperacaoShared({
    this.id,
    this.descricao = "",
    this.titulo = "",
    this.valor = 0,
    this.status,
    this.tipoOperacao,
    this.totalParcelas = 0,
    this.dataCadastro,
    this.dataReferencia,
    this.idProprietario = "",
    this.idDestinatario = "",
    this.idOperacao = "",
    this.imgProprietario = "",
    this.imgDestinatario = "",
    this.justificativa = "",
  });

  /// Cria uma cópia da operação compartilhada com campos alterados
  OperacaoShared copyWith({
    String? id,
    String? descricao,
    String? titulo,
    double? valor,
    int? status,
    int? tipoOperacao,
    int? totalParcelas,
    DateTime? dataCadastro,
    DateTime? dataReferencia,
    String? idProprietario,
    String? idDestinatario,
    String? idOperacao,
    String? imgProprietario,
    String? imgDestinatario,
    String? justificativa,
  }) {
    return OperacaoShared(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      titulo: titulo ?? this.titulo,
      valor: valor ?? this.valor,
      status: status ?? this.status,
      tipoOperacao: tipoOperacao ?? this.tipoOperacao,
      totalParcelas: totalParcelas ?? this.totalParcelas,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataReferencia: dataReferencia ?? this.dataReferencia,
      idProprietario: idProprietario ?? this.idProprietario,
      idDestinatario: idDestinatario ?? this.idDestinatario,
      idOperacao: idOperacao ?? this.idOperacao,
      imgProprietario: imgProprietario ?? this.imgProprietario,
      imgDestinatario: imgDestinatario ?? this.imgDestinatario,
      justificativa: justificativa ?? this.justificativa,
    );
  }
}