import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:organiza2/app/core/controllers/base_controller.dart';
import 'package:organiza2/app/core/models/custom_exception.dart';
import 'package:organiza2/app/core/models/enums.dart';
import 'package:organiza2/app/core/services/alert_service.dart';
import 'package:organiza2/app/core/services/rotina.service.dart';
import 'package:organiza2/app/core/utils/string_utils.dart';
import 'package:organiza2/app/modules/categoria/domain/entities/categoria.dart';
import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/salvar_operacao_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/salvar_com_parcelas_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/salvar_ano_todo_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/atualizar_operacao_usecase.dart';

class OperacaoController extends BaseController {
  final SalvarOperacaoUseCase _salvarOperacaoUseCase;
  final SalvarComParcelasUseCase _salvarComParcelasUseCase;
  final SalvarAnoTodoUseCase _salvarAnoTodoUseCase;
  final AtualizarOperacaoUseCase _atualizarOperacaoUseCase;
  final RotinaService rotinaService = Modular.get<RotinaService>();

  OperacaoController(
    this._salvarOperacaoUseCase,
    this._salvarComParcelasUseCase,
    this._salvarAnoTodoUseCase,
    this._atualizarOperacaoUseCase,
  );

  // Campos do formulário
  var descricao = ''.obs;
  var titulo = ''.obs;
  var valor = ''.obs;
  var qtdParcelas = ''.obs;
  var diaVencimento = ''.obs;
  var categoria = Rx<Categoria?>(null);
  var frequencia = TipoFrequencia.Nunca.obs;
  var tipoOperacao = 1.obs;
  var isRepetir = false.obs;
  var afetarTotalizadores = true.obs;

  /// Salva operação com parcelas
  Future<void> salvarComParcelas(BuildContext context, Operacao operacao) async {
    try {
      await _salvarComParcelasUseCase(operacao);
      await AlertService.alertaSucesso(context, 'Operação com parcelas salva com sucesso');
      await Future.delayed(const Duration(milliseconds: 300));
    } on CustomException catch (e) {
      await AlertService.alertErro(context, e.message, titulo: 'Erro ao salvar');
    }
  }

  /// Salva operação para o ano todo
  Future<void> salvarAnoTodo(BuildContext context, Operacao operacao) async {
    try {
      await _salvarAnoTodoUseCase(operacao);
      await AlertService.alertaSucesso(context, 'Operações do ano salvas com sucesso');
      await Future.delayed(const Duration(milliseconds: 300));
    } on CustomException catch (e) {
      await AlertService.alertErro(context, e.message, titulo: 'Erro ao salvar');
    }
  }

  /// Salva operação simples (sem parcelas ou repetição)
  Future<void> salvarOperacaoSimples(BuildContext context, Operacao operacao) async {
    try {
      await _salvarOperacaoUseCase(operacao);
      await AlertService.alertaSucesso(context, 'Operação salva com sucesso');
    } on CustomException catch (e) {
      await AlertService.alertErro(context, e.message, titulo: 'Erro ao salvar');
    }
  }

  /// Atualiza uma operação existente
  Future<void> atualizarOperacao(BuildContext context, Operacao operacao) async {
    try {
      await _atualizarOperacaoUseCase(operacao);
      await AlertService.alertaSucesso(context, 'Operação atualizada com sucesso');
      await Future.delayed(const Duration(milliseconds: 300));
    } on CustomException catch (e) {
      await AlertService.alertErro(context, e.message, titulo: 'Erro ao atualizar');
    }
  }
}
