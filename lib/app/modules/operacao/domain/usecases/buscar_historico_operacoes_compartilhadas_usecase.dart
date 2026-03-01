import 'package:organiza2/app/modules/operacao/domain/entities/operacao_shared.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_shared_repository.dart';

class BuscarHistoricoOperacoesCompartilhadasUseCase {
  final OperacaoSharedRepository _repository;

  BuscarHistoricoOperacoesCompartilhadasUseCase(this._repository);

  Stream<List<OperacaoShared>> call() {
    return _repository.buscarHistoricoOperacoesCompartilhadas();
  }
}
