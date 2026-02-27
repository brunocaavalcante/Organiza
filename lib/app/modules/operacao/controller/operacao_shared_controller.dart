import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/core/controllers/base_controller.dart';
import 'package:organiza2/app/core/models/custom_exception.dart';
import 'package:organiza2/app/core/models/enums.dart';
import 'package:organiza2/app/core/services/alert_service.dart';
import 'package:organiza2/app/modules/operacao/core/models/operacao.dart';
import 'package:organiza2/app/modules/operacao/core/models/operacao_shared.dart';
import 'package:organiza2/app/modules/operacao/core/services/operacao_service.dart';
import 'package:organiza2/app/modules/operacao/core/services/operacao_shared_service.dart';
import 'package:organiza2/app/modules/usuario/presentation/controllers/usuario_controller.dart';

class OperacaoSharedController extends BaseController {
  final _service = Modular.get<OperacaoSharedService>();
  final _operacaoService = Modular.get<OperacaoService>();
  final _usuarioController = Modular.get<UsuarioController>();

  Stream<List<OperacaoShared>> obterOperacaoCompartilhadas() {
    try {
      return _service.buscarOperacoesCompartilhada();
    } catch (e) {
      throw CustomException("ocorreu um erro ao cadastrar tente novamente $e");
    }
  }

  Stream<List<OperacaoShared>> buscarHistoricoOperacoesCompartilhada() {
    try {
      return _service.buscarHistoricoOperacoesCompartilhada();
    } catch (e) {
      throw CustomException("ocorreu um erro ao cadastrar tente novamente $e");
    }
  }

  Future excluirOperacaoCompartilhada(
      OperacaoShared op, BuildContext context) async {
    try {
      await _service.excluir(op);
      Navigator.pop(context);
      AlertService.alertaSucess(context);
    } catch (e) {
      AlertService.alertErro(
          context, "Ocorreu um erro ao realizar operação: $e");
    }
  }

  Future editarOperacaoCompartilhada(
      OperacaoShared op, BuildContext context) async {
    try {
      await _service.editar(op);
      AlertService.alertaSucess(context);
      Navigator.pop(context);
    } catch (e) {
      AlertService.alertErro(
          context, "Ocorreu um erro ao realizar operação: $e");
    }
  }

  Future salvarOperacaoCompartilhada(
      Operacao op, String email, BuildContext context) async {
    try {
      var proprietario = await _usuarioController.obterUsuario();
      var destinatario = await _usuarioController.obterUsuarioPorEmail(email);

      if (destinatario != null && proprietario != null) {
        var operacao = OperacaoShared();
        operacao.titulo = op.titulo;
        operacao.descricao = op.descricao;
        operacao.dataCadastro = DateTime.now();
        operacao.dataReferencia = op.dataReferencia;
        operacao.idDestinatario = destinatario.id;
        operacao.imgDestinatario = destinatario.photoUrl;
        operacao.imgProprietario = proprietario.photoUrl;
        operacao.idProprietario = proprietario.id;
        operacao.valor = op.valor;
        operacao.status = Status.PendenteAprovacao.index;
        operacao.idOperacao = op.id;
        operacao.tipoOperacao = op.tipoOperacao;
        operacao.totalParcelas = op.totalParcelas;
        await _service.salvar(operacao);
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

  Future aprovarContaCompartilhada(
      OperacaoShared op, BuildContext context) async {
    try {
      var operacao = await _service.buscarOperacaoPorId(op);
      if (operacao != null) {
        if (operacao.tipoFrequencia == TipoFrequencia.Parcelado.index) {
          await _operacaoService.salvarComParcelas(operacao);
        } else if (operacao.tipoFrequencia == TipoFrequencia.AnoTodo.index) {
          await _operacaoService.salvarAnoTodo(operacao);
        } else {
          await _operacaoService.salvar(operacao);
        }

        op.status = Status.Aprovado.index;
        await _service.editar(op);

        AlertService.alertaSucess(context);
      } else {
        AlertService.alertAviso(context, "Alerta", "Operação não encontrada");
      }
    } catch (e) {
      AlertService.alertErro(
          context, "Ocorreu um erro ao realizar operação: $e");
    }
  }
}
