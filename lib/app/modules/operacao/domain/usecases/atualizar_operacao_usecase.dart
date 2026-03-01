import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_repository.dart';

class AtualizarOperacaoUseCase {
  final OperacaoRepository _repository;

  AtualizarOperacaoUseCase(this._repository);

  Future<void> call(Operacao operacao) async {
    return await _repository.atualizar(operacao);
  }
}
