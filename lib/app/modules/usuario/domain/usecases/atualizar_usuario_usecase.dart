import '../../../../core/models/custom_exception.dart';
import '../entities/usuario.dart';
import '../repositories/i_usuario_repository.dart';

class AtualizarUsuarioUseCase {
  final IUsuarioRepository repository;

  AtualizarUsuarioUseCase(this.repository);

  Future<void> call(
    Usuario usuario,
    String? novaSenha,
    String? confirmNovaSenha,
  ) async {
    // Validações básicas
    if (usuario.name.isEmpty) {
      throw CustomException('Nome é obrigatório');
    }

    if (!usuario.isEmailValid()) {
      throw CustomException('Email inválido');
    }

    if (!usuario.isValid()) {
      throw CustomException('Dados do usuário inválidos');
    }

    // Validação de senha se estiver alterando
    if (novaSenha != null && novaSenha.isNotEmpty) {
      if (novaSenha.length < 6) {
        throw CustomException('Senha deve ter pelo menos 6 caracteres');
      }

      if (novaSenha != confirmNovaSenha) {
        throw CustomException('As senhas não coincidem');
      }
    }

    await repository.update(usuario);
  }
}