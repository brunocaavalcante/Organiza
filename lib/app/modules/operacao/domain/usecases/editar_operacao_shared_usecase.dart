import 'package:organiza2/app/core/models/custom_exception.dart';
import 'package:organiza2/app/modules/operacao/domain/entities/operacao_shared.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_shared_repository.dart';

class EditarOperacaoSharedUseCase {
  final OperacaoSharedRepository _repository;

  EditarOperacaoSharedUseCase(this._repository);

  Future<void> call(OperacaoShared operacaoShared) async {
    if (operacaoShared.id == null) {
      throw CustomException("ID da operação compartilhada não informado");
    }

    return await _repository.editar(operacaoShared);
  }
}
