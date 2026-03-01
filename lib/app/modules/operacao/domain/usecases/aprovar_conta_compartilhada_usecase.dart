import 'package:organiza2/app/core/models/enums.dart';
import 'package:organiza2/app/modules/operacao/domain/entities/operacao_shared.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_repository.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_shared_repository.dart';

class AprovarContaCompartilhadaUseCase {
  final OperacaoSharedRepository _sharedRepository;
  final OperacaoRepository _operacaoRepository;

  AprovarContaCompartilhadaUseCase(
    this._sharedRepository,
    this._operacaoRepository,
  );

  Future<void> call(OperacaoShared operacaoShared) async {
    // Busca a operação original
    final operacao = await _sharedRepository.buscarOperacaoPorId(operacaoShared);

    if (operacao == null) {
      throw Exception("Operação não encontrada");
    }

    // Lógica de negócio: salva operação conforme tipo de frequência
    if (operacao.tipoFrequencia == TipoFrequencia.Parcelado.index) {
      // Salvar com parcelas - lógica inline
      DateTime data = operacao.dataReferencia ??
          DateTime(DateTime.now().year, DateTime.now().month, 1);

      for (int i = 1; i <= operacao.totalParcelas; i++) {
        final operacaoParcela = operacao.copyWith(
          parcelaAtual: i,
          dataReferencia: data,
        );
        await _operacaoRepository.salvar(operacaoParcela);
        data = DateTime(data.year, data.month + 1, data.day);
      }
    } else if (operacao.tipoFrequencia == TipoFrequencia.AnoTodo.index) {
      // Salvar ano todo - lógica inline
      DateTime data = operacao.dataReferencia ??
          DateTime(DateTime.now().year, DateTime.now().month, 1);

      final anoAtual = DateTime.now().year;

      while (data.year == anoAtual) {
        final operacaoMes = operacao.copyWith(dataReferencia: data);
        await _operacaoRepository.salvar(operacaoMes);
        data = DateTime(data.year, data.month + 1, 1);
      }
    } else {
      await _operacaoRepository.salvar(operacao);
    }

    // Atualiza status da operação compartilhada para Aprovado
    final operacaoSharedAtualizada = operacaoShared.copyWith(
      status: Status.Aprovado.index,
    );
    await _sharedRepository.editar(operacaoSharedAtualizada);
  }
}
