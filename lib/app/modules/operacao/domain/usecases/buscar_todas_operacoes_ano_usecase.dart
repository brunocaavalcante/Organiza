import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_repository.dart';

/// UseCase para buscar todas as operações do ano
class BuscarTodasOperacoesAnoUseCase {
  final OperacaoRepository _repository;

  BuscarTodasOperacoesAnoUseCase(this._repository);

  Future<List<Operacao>> call() async {
    return await _repository.buscarTodasDoAno();
  }
}
