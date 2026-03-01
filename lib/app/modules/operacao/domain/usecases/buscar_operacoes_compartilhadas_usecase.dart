import 'package:organiza2/app/modules/operacao/domain/entities/operacao_shared.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_shared_repository.dart';

class BuscarOperacoesCompartilhadasUseCase {
  final OperacaoSharedRepository _repository;

  BuscarOperacoesCompartilhadasUseCase(this._repository);

  Stream<List<OperacaoShared>> call() {
    return _repository.buscarOperacoesCompartilhadas();
  }
}
