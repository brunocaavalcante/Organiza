import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';
import 'package:organiza2/app/modules/operacao/domain/entities/operacao_shared.dart';

abstract class OperacaoSharedRepository {
  Future<void> salvar(OperacaoShared operacaoShared);
  Future<void> editar(OperacaoShared operacaoShared);
  Future<void> excluir(OperacaoShared operacaoShared);

  /// Stream de operações compartilhadas pendentes
  Stream<List<OperacaoShared>> buscarOperacoesCompartilhadas();

  /// Stream do histórico de operações compartilhadas
  Stream<List<OperacaoShared>> buscarHistoricoOperacoesCompartilhadas();

  /// Busca operação original por ID
  Future<Operacao?> buscarOperacaoPorId(OperacaoShared operacaoShared);
}
