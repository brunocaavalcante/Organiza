import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_repository.dart';

/// UseCase para salvar uma operação
class SalvarOperacaoUseCase {
  final OperacaoRepository _repository;

  SalvarOperacaoUseCase(this._repository);

  Future<void> call(Operacao operacao) async {
    return await _repository.salvar(operacao);
  }
}
