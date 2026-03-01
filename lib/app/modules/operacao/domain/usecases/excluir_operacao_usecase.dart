import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_repository.dart';

class ExcluirOperacaoUseCase {
  final OperacaoRepository _repository;

  ExcluirOperacaoUseCase(this._repository);

  Future<void> call(Operacao operacao) async {
    return await _repository.excluir(operacao);
  }
}
