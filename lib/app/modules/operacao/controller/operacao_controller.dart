import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:organiza2/app/core/controllers/base_controller.dart';
import 'package:organiza2/app/core/models/custom_exception.dart';
import 'package:organiza2/app/core/models/enums.dart';
import 'package:organiza2/app/core/services/rotina.service.dart';
import 'package:organiza2/app/core/utils/string_utils.dart';
import 'package:organiza2/app/modules/categoria/domain/entities/categoria.dart';
import 'package:organiza2/app/modules/operacao/core/models/operacao.dart';
import 'package:organiza2/app/modules/operacao/core/services/operacao_service.dart';
import 'package:organiza2/app/modules/operacao/core/services/operacao_shared_service.dart';

class OperacaoController extends BaseController {
  final OperacaoService operacaoService = Modular.get<OperacaoService>();
  final OperacaoSharedService _operacaoShared =
      Modular.get<OperacaoSharedService>();
  final RotinaService rotinaService = Modular.get<RotinaService>();

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
      var operacao = Operacao();
      operacao.titulo = titulo.value;
      operacao.descricao = descricao.value;
      operacao.valor = StringUtil().CoverterValorToDecimal(valor.value)!;
      operacao.totalParcelas = int.tryParse(qtdParcelas.value) ?? 0;
      operacao.tipoFrequencia = frequencia.value.index;
      operacao.diaVencimento = int.parse(diaVencimento.value);
      operacao.repetir = isRepetir.value;
      operacao.afetarTotalizadores = afetarTotalizadores.value;
      operacao.categoria = categoria.value!;
      operacao.status = Status.Pendente.index;
      operacao.dataCadastro = DateTime.now();
      operacao.tipoOperacao = tipoOperacao.value;

      await operacaoService.salvar(operacao);
      Get.back(result: true);
    } on CustomException catch (e) {
      Get.snackbar('Erro ao salvar', e.message);
    }
  }
}
