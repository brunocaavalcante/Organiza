import '../../../../core/models/custom_exception.dart';
import '../entities/usuario.dart';
import '../repositories/i_usuario_repository.dart';

class RegistrarUsuarioUseCase {
  final IUsuarioRepository repository;

  RegistrarUsuarioUseCase(this.repository);

  Future<void> call(Usuario usuario, String senha, String confirmSenha) async {

    if (usuario.name.isEmpty) {
      throw CustomException('Nome é obrigatório');
    }

    if (usuario.name.length < 3) {
      throw CustomException('Nome deve ter pelo menos 3 caracteres');
    }

    if (usuario.email.isEmpty) {
      throw CustomException('Email é obrigatório');
    }

    if (!usuario.isEmailValid()) {
      throw CustomException('Email inválido');
    }

    if (senha.isEmpty) {
      throw CustomException('Senha é obrigatória');
    }

    if (senha.length < 6) {
      throw CustomException('Senha deve ter pelo menos 6 caracteres');
    }

    if (senha != confirmSenha) {
      throw CustomException('As senhas não coincidem');
    }

    if (!usuario.isValid()) {
      throw CustomException('Dados do usuário inválidos');
    }

    await repository.register(usuario, senha);
  }
}