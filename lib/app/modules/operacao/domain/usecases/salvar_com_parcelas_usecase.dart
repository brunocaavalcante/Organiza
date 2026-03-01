import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_repository.dart';

class SalvarComParcelasUseCase {
  final OperacaoRepository _repository;

  SalvarComParcelasUseCase(this._repository);

  Future<void> call(Operacao operacao) async {
    DateTime data = operacao.dataReferencia ??
        DateTime(DateTime.now().year, DateTime.now().month, 1);

    for (int i = 1; i <= operacao.totalParcelas; i++) {
      final operacaoParcela =
          operacao.copyWith(parcelaAtual: i, dataReferencia: data);

      await _repository.salvar(operacaoParcela);

      // Incrementa o mês para a próxima parcela
      data = DateTime(data.year, data.month + 1, data.day);
    }
  }
}
