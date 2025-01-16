import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:organiza2/app/core/controllers/base_controller.dart';
import 'package:organiza2/app/core/services/alert_service.dart';
import 'package:organiza2/app/core/utils/date_ultils.dart';
import 'package:organiza2/app/core/models/custom_exception.dart';
import 'package:organiza2/app/core/services/file_service.dart';
import 'package:organiza2/app/core/utils/theme/preferencia_tema.dart';
import 'package:organiza2/app/modules/usuario/core/models/preferencia_user.dart';
import 'package:organiza2/app/modules/usuario/core/models/usuario.dart';
import 'package:organiza2/app/modules/usuario/core/services/usuario_service.dart';

class UsuarioController extends BaseController {
  final UserService _usuarioService = Modular.get<UserService>();
  final FileService _fileService = Modular.get<FileService>();

  // Observables para os campos do formulário
  final nome = TextEditingController();
  final telefone = TextEditingController();
  final email = TextEditingController();
  final senha = TextEditingController();
  final confirmSenha = TextEditingController();
  final dataNascimento = TextEditingController();
  Rx<PreferenciaUser> theme = PreferenciaUser().obs;
  var loading = false.obs;

  ///Login do usuario
  Future<void> login() async {
    loading.value = true;
    try {
      await _usuarioService.login(email.text, senha.text);
    } on CustomException catch (e) {
      loading.value = false;
      Get.snackbar(
        'Erro de Login',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _usuarioService.logout();
    } on CustomException catch (e) {
      loading.value = false;
      Get.snackbar('Erro de Logout', e.message,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Método para registrar ou atualizar o usuário
  Future<void> registrar(
      {required Usuario user, required String operacao}) async {
    try {
      var usuario = user;
      usuario.name = nome.text;
      usuario.telefone = telefone.text;
      usuario.email = email.text;
      usuario.senha = senha.text;
      usuario.confirmSenha = confirmSenha.text;
      usuario.dataNascimento = DateUltils.stringToDate(dataNascimento.text);
      usuario.photo =
          _fileService.destino.isEmpty ? user.photo : _fileService.destino;
      usuario.refPhoto =
          _fileService.refImage.isEmpty ? user.refPhoto : _fileService.refImage;

      if (operacao.contains("Cadastro")) {
        await _usuarioService.registrar(usuario);
      }

      if (operacao.contains("Editar")) {
        await _usuarioService.atualizar(usuario);
      }

      Modular.to.pop();
    } on CustomException catch (e) {
      throw e;
    }
  }

  ///Login do usuario
  Future<Usuario?> obterUsuario() async {
    try {
      return await _usuarioService.obterUsuario();
    } on CustomException catch (e) {
      loading.value = false;
      Get.snackbar(
        'Erro de Login',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      loading.value = false;
    }
  }

  Future obterPreferenciaUsuario() async {
    var item = await _usuarioService.obterUsuario();
    if (item != null) {
      theme.value = item.preferencias;
    }
  }

  Future atualizarPreferenciaUsuario() async {
    try {
      await _usuarioService.atualizarPreferencia(theme.value);
      PreferenciaTema.setTema(theme.value);
    } on CustomException catch (e) {
      loading.value = false;
      Get.snackbar(
        'Erro de Login',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
