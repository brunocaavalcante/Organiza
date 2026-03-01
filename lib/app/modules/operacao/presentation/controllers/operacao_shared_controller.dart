import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/core/controllers/base_controller.dart';
import 'package:organiza2/app/core/models/custom_exception.dart';
import 'package:organiza2/app/core/models/enums.dart';
import 'package:organiza2/app/core/services/alert_service.dart';
import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';
import 'package:organiza2/app/modules/operacao/domain/entities/operacao_shared.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/aprovar_conta_compartilhada_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/buscar_historico_operacoes_compartilhadas_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/buscar_operacoes_compartilhadas_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/editar_operacao_shared_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/excluir_operacao_shared_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/salvar_operacao_shared_usecase.dart';
import 'package:organiza2/app/modules/usuario/presentation/controllers/usuario_controller.dart';

/// Controller para gerenciar operações compartilhadas (usando Clean Architecture)
class OperacaoSharedController extends BaseController {
  final BuscarOperacoesCompartilhadasUseCase _buscarOperacoesCompartilhadasUseCase;
  final BuscarHistoricoOperacoesCompartilhadasUseCase _buscarHistoricoUseCase;
  final SalvarOperacaoSharedUseCase _salvarOperacaoSharedUseCase;
  final EditarOperacaoSharedUseCase _editarOperacaoSharedUseCase;
  final ExcluirOperacaoSharedUseCase _excluirOperacaoSharedUseCase;
  final AprovarContaCompartilhadaUseCase _aprovarContaCompartilhadaUseCase;
  final UsuarioController _usuarioController = Modular.get<UsuarioController>();

  OperacaoSharedController(
    this._buscarOperacoesCompartilhadasUseCase,
    this._buscarHistoricoUseCase,
    this._salvarOperacaoSharedUseCase,
    this._editarOperacaoSharedUseCase,
    this._excluirOperacaoSharedUseCase,
    this._aprovarContaCompartilhadaUseCase,
  );

  Stream<List<OperacaoShared>> obterOperacaoCompartilhadas() {
    try {
      return _buscarOperacoesCompartilhadasUseCase();
    } catch (e) {
      throw CustomException("Ocorreu um erro ao buscar operações: $e");
    }
  }

  Stream<List<OperacaoShared>> buscarHistoricoOperacoesCompartilhada() {
    try {
      return _buscarHistoricoUseCase();
    } catch (e) {
      throw CustomException("Ocorreu um erro ao buscar histórico: $e");
    }
  }

  Future<void> excluirOperacaoCompartilhada(
      OperacaoShared op, BuildContext context) async {
    try {
      await _excluirOperacaoSharedUseCase(op);
      Navigator.pop(context);
      AlertService.alertaSucess(context);
    } catch (e) {
      AlertService.alertErro(
          context, "Ocorreu um erro ao realizar operação: $e");
    }
  }

  Future<void> editarOperacaoCompartilhada(
      OperacaoShared op, BuildContext context) async {
    try {
      await _editarOperacaoSharedUseCase(op);
      AlertService.alertaSucess(context);
      Navigator.pop(context);
    } catch (e) {
      AlertService.alertErro(
          context, "Ocorreu um erro ao realizar operação: $e");
    }
  }

  Future<void> salvarOperacaoCompartilhada(
      Operacao op, String email, BuildContext context) async {
    try {
      final proprietario = await _usuarioController.obterUsuario();
      final destinatario = await _usuarioController.obterUsuarioPorEmail(email);

      if (destinatario != null && proprietario != null) {
        final operacaoShared = OperacaoShared(
          titulo: op.titulo,
          descricao: op.descricao,
          dataCadastro: DateTime.now(),
          dataReferencia: op.dataReferencia,
          idDestinatario: destinatario.id,
          imgDestinatario: destinatario.photoUrl,
          imgProprietario: proprietario.photoUrl,
          idProprietario: proprietario.id,
          valor: op.valor,
          status: Status.PendenteAprovacao.index,
          idOperacao: op.id ?? '',
          tipoOperacao: op.tipoOperacao,
          totalParcelas: op.totalParcelas,
        );

        await _salvarOperacaoSharedUseCase(operacaoShared);
        Navigator.pop(context);
        AlertService.alertaSucess(context);
      }

      if (destinatario == null) {
        AlertService.alertAviso(
            context, "Alerta", "O destinatário não foi encontrado");
      }
    } catch (e) {
      AlertService.alertErro(
          context, "Ocorreu um erro ao realizar operação: $e");
    }
  }

  Future<void> aprovarContaCompartilhada(
      OperacaoShared op, BuildContext context) async {
    try {
      await _aprovarContaCompartilhadaUseCase(op);
      AlertService.alertaSucess(context);
    } catch (e) {
      AlertService.alertErro(
          context, "Ocorreu um erro ao realizar operação: $e");
    }
  }
}
