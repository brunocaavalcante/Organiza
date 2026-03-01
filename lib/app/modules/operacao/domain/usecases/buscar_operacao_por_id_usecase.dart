import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';
import 'package:organiza2/app/modules/operacao/domain/entities/operacao_shared.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_shared_repository.dart';

/// UseCase para buscar operação original por ID
class BuscarOperacaoPorIdUseCase {
  final OperacaoSharedRepository _repository;

  BuscarOperacaoPorIdUseCase(this._repository);

  Future<Operacao?> call(OperacaoShared operacaoShared) async {
    return await _repository.buscarOperacaoPorId(operacaoShared);
  }
}
