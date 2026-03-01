import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';

abstract class OperacaoRepository {

  Future<void> salvar(Operacao operacao);
  Future<void> atualizar(Operacao operacao);
  Future<void> excluir(Operacao operacao);

  /// Busca operações por mês e ano
  Future<List<Operacao>> buscarPorMesAno(int mes, int ano);

  /// Busca todas as operações do ano atual
  Future<List<Operacao>> buscarTodasDoAno();

  /// Busca operações por data específica (mesma descrição, valor e título)
  Future<List<Operacao>> buscarPorData(Operacao operacao);
}
