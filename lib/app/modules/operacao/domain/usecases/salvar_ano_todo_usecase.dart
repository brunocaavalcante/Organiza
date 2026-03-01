import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_repository.dart';

/// UseCase para salvar operação para todos os meses do ano
class SalvarAnoTodoUseCase {
  final OperacaoRepository _repository;

  SalvarAnoTodoUseCase(this._repository);

  Future<void> call(Operacao operacao) async {
    DateTime data = operacao.dataReferencia ??
        DateTime(DateTime.now().year, DateTime.now().month, 1);

    final anoAtual = DateTime.now().year;
    
    while (data.year == anoAtual) {
      final operacaoMes = operacao.copyWith(dataReferencia: data);
      await _repository.salvar(operacaoMes);
      
      // Incrementa o mês
      data = DateTime(data.year, data.month + 1, 1);
    }
  }
}
