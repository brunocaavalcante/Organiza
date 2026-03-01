import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_repository.dart';

/// UseCase para buscar operações por mês e ano
class BuscarOperacoesMesAnoUseCase {
  final OperacaoRepository _repository;

  BuscarOperacoesMesAnoUseCase(this._repository);

  Future<List<Operacao>> call(int mes, int ano) async {
    return await _repository.buscarPorMesAno(mes, ano);
  }
}
