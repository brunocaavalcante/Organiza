import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/models/custom_exception.dart';
import '../../../../core/services/file_service.dart';
import '../../../../core/utils/date_ultils.dart';
import '../../../../core/utils/theme/preferencia_tema.dart';
import '../../domain/entities/preferencia_usuario.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/usecases/atualizar_preferencias_usecase.dart';
import '../../domain/usecases/atualizar_usuario_usecase.dart';
import '../../domain/usecases/buscar_usuario_atual_usecase.dart';
import '../../domain/usecases/buscar_usuario_por_email_usecase.dart';
import '../../domain/usecases/get_auth_state_usecase.dart';
import '../../domain/usecases/login_usuario_usecase.dart';
import '../../domain/usecases/logout_usuario_usecase.dart';
import '../../domain/usecases/registrar_usuario_usecase.dart';

class UsuarioController extends BaseController {
  // Use Cases
  final RegistrarUsuarioUseCase _registrarUseCase;
  final LoginUsuarioUseCase _loginUseCase;
  final LogoutUsuarioUseCase _logoutUseCase;
  final AtualizarUsuarioUseCase _atualizarUseCase;
  final BuscarUsuarioAtualUseCase _buscarUsuarioUseCase;
  final BuscarUsuarioPorEmailUseCase _buscarPorEmailUseCase;
  final AtualizarPreferenciasUseCase _atualizarPreferenciasUseCase;
  final GetAuthStateUseCase _getAuthStateUseCase;

  // FileService para upload de fotos (funcionalidade transversal)
  final FileService _fileService = Modular.get<FileService>();

  UsuarioController(
    this._registrarUseCase,
    this._loginUseCase,
    this._logoutUseCase,
    this._atualizarUseCase,
    this._buscarUsuarioUseCase,
    this._buscarPorEmailUseCase,
    this._atualizarPreferenciasUseCase,
    this._getAuthStateUseCase,
  );

  // State observável
  final usuarioAtual = Rxn<Usuario>();
  final isLoading = false.obs;
  final isAuthenticated = false.obs;

  // Controllers de formulário
  final nome = TextEditingController();
  final telefone = TextEditingController();
  final email = TextEditingController();
  final senha = TextEditingController();
  final confirmSenha = TextEditingController();
  final dataNascimento = TextEditingController();
  
  // Preferências
  final theme = Rx<PreferenciaUsuario>(PreferenciaUsuario.empty());

  @override
  void onInit() {
    super.onInit();
    _listenToAuthState();
  }

  void _listenToAuthState() {
    _getAuthStateUseCase().listen((userId) async {
      isAuthenticated.value = userId != null;
      if (userId != null) {
        await _carregarUsuarioAtual();
      } else {
        usuarioAtual.value = null;
      }
    });
  }

  Future<void> _carregarUsuarioAtual() async {
    try {
      final usuario = await _buscarUsuarioUseCase();
      usuarioAtual.value = usuario;
      if (usuario != null) {
        theme.value = usuario.preferencias;
      }
    } on CustomException catch (e) {
      print('Erro ao carregar usuário: ${e.message}');
    } catch (e) {
      print('Erro inesperado ao carregar usuário: $e');
    }
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      await _loginUseCase(email.text, senha.text);
    } on CustomException catch (e) {
      Get.snackbar(
        'Erro',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _logoutUseCase();
      _limparFormularios();
    } on CustomException catch (e) {
      Get.snackbar(
        'Erro',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<void> registrar({required Usuario user, required String operacao}) async {
    isLoading.value = true;
    try {
      final usuario = user.copyWith(
        name: nome.text,
        telefone: telefone.text,
        email: email.text,
        dataNascimento: DateUltils.stringToDate(dataNascimento.text),
        photoUrl: _fileService.destino.isEmpty ? user.photoUrl : _fileService.destino,
        photoRef: _fileService.refImage.isEmpty ? user.photoRef : _fileService.refImage,
      );

      if (operacao.contains('Cadastro')) {
        await _registrarUseCase(usuario, senha.text, confirmSenha.text);
        Get.snackbar(
          'Sucesso',
          'Usuário cadastrado com sucesso!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

      if (operacao.contains('Editar')) {
        await _atualizarUseCase(
          usuario,
          senha.text.isNotEmpty ? senha.text : null,
          confirmSenha.text.isNotEmpty ? confirmSenha.text : null,
        );
        Get.snackbar(
          'Sucesso',
          'Usuário atualizado com sucesso!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

      Modular.to.pop();
      _limparFormularios();
      
    } on CustomException catch (e) {
      Get.snackbar(
        'Erro',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Usuario?> obterUsuario() async {
    isLoading.value = true;
    try {
      return await _buscarUsuarioUseCase();
    } catch (e) {
      print('Erro ao obter usuário: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Usuario?> obterUsuarioPorEmail(String email) async {
    try {
      return await _buscarPorEmailUseCase(email);
    } on CustomException catch (e) {
      Get.snackbar(
        'Erro',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  Future<void> obterPreferenciaUsuario() async {
    final usuario = await obterUsuario();
    if (usuario != null) {
      theme.value = usuario.preferencias;
    }
  }

  Future<void> atualizarPreferenciaUsuario() async {
    try {
      final usuario = usuarioAtual.value;
      if (usuario == null) {
        throw CustomException('Usuário não autenticado');
      }

      // Atualizar preferências no repository
      await _atualizarPreferenciasUseCase(usuario.id, theme.value);
      
      final usuarioAtualizado = await _buscarUsuarioUseCase();
      if (usuarioAtualizado != null) {
        usuarioAtual.value = usuarioAtualizado;
        theme.value = usuarioAtualizado.preferencias;
        
        // Aplicar tema na UI usando diretamente a nova entidade
        PreferenciaTema.setTema(usuarioAtualizado.preferencias);
      }
      
      Get.snackbar(
        'Sucesso',
        'Preferências atualizadas!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
    } on CustomException catch (e) {
      Get.snackbar(
        'Erro',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void popularFormulario(Usuario usuario) {
    nome.text = usuario.name;
    telefone.text = usuario.telefone;
    email.text = usuario.email;
    if (usuario.dataNascimento != null) {
      dataNascimento.text = DateUltils.formatarData(usuario.dataNascimento);
    }
    theme.value = usuario.preferencias;
  }

  void _limparFormularios() {
    nome.clear();
    telefone.clear();
    email.clear();
    senha.clear();
    confirmSenha.clear();
    dataNascimento.clear();
  }

  @override
  void onClose() {
    nome.dispose();
    telefone.dispose();
    email.dispose();
    senha.dispose();
    confirmSenha.dispose();
    dataNascimento.dispose();
    super.onClose();
  }
}