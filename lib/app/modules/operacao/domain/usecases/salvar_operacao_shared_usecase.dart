import 'package:organiza2/app/modules/operacao/domain/entities/operacao_shared.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_shared_repository.dart';

class SalvarOperacaoSharedUseCase {
  final OperacaoSharedRepository _repository;

  SalvarOperacaoSharedUseCase(this._repository);

  Future<void> call(OperacaoShared operacaoShared) async {
    return await _repository.salvar(operacaoShared);
  }
}
