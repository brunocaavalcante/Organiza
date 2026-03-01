import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:organiza2/app/core/controllers/base_controller.dart';
import 'package:organiza2/app/core/models/custom_exception.dart';
import 'package:organiza2/app/core/models/enums.dart';
import 'package:organiza2/app/core/services/rotina.service.dart';
import 'package:organiza2/app/core/utils/string_utils.dart';
import 'package:organiza2/app/modules/categoria/domain/entities/categoria.dart';
import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/salvar_operacao_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/salvar_com_parcelas_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/salvar_ano_todo_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/atualizar_operacao_usecase.dart';

/// Controller para gerenciar operações (usando Clean Architecture)
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

  final formKey = GlobalKey<FormState>();

  Future<void> salvarOperacao() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (categoria.value == null) {
      Get.snackbar('Erro', 'Selecione uma categoria');
      return;
    }

    try {
      final operacao = Operacao(
        titulo: titulo.value,
        descricao: descricao.value,
        valor: StringUtil().CoverterValorToDecimal(valor.value)!,
        totalParcelas: int.tryParse(qtdParcelas.value) ?? 0,
        tipoFrequencia: frequencia.value.index,
        diaVencimento: int.parse(diaVencimento.value),
        repetir: isRepetir.value,
        afetarTotalizadores: afetarTotalizadores.value,
        categoria: categoria.value!,
        status: Status.Pendente.index,
        dataCadastro: DateTime.now(),
        tipoOperacao: tipoOperacao.value,
      );

      await _salvarOperacaoUseCase(operacao);
      Get.back(result: true);
    } on CustomException catch (e) {
      Get.snackbar('Erro ao salvar', e.message);
    }
  }

  /// Salva operação com parcelas
  Future<void> salvarComParcelas(Operacao operacao) async {
    try {
      await _salvarComParcelasUseCase(operacao);
    } on CustomException catch (e) {
      rethrow;
    }
  }

  /// Salva operação para o ano todo
  Future<void> salvarAnoTodo(Operacao operacao) async {
    try {
      await _salvarAnoTodoUseCase(operacao);
    } on CustomException catch (e) {
      rethrow;
    }
  }

  /// Salva operação simples (sem parcelas ou repetição)
  Future<void> salvarOperacaoSimples(Operacao operacao) async {
    try {
      await _salvarOperacaoUseCase(operacao);
    } on CustomException catch (e) {
      rethrow;
    }
  }

  /// Atualiza uma operação existente
  Future<void> atualizarOperacao(Operacao operacao) async {
    try {
      await _atualizarOperacaoUseCase(operacao);
    } on CustomException catch (e) {
      rethrow;
    }
  }
}
