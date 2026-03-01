import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_repository.dart';

/// UseCase para buscar operações por data
class BuscarOperacoesPorDataUseCase {
  final OperacaoRepository _repository;

  BuscarOperacoesPorDataUseCase(this._repository);

  Future<List<Operacao>> call(Operacao operacao) async {
    return await _repository.buscarPorData(operacao);
  }
}
