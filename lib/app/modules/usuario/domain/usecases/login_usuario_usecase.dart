import '../../../../core/models/custom_exception.dart';
import '../repositories/i_usuario_repository.dart';

class LoginUsuarioUseCase {
  final IUsuarioRepository repository;

  LoginUsuarioUseCase(this.repository);

  Future<void> call(String email, String senha) async {
    if (email.isEmpty) {
      throw CustomException('Email é obrigatório');
    }

    if (senha.isEmpty) {
      throw CustomException('Senha é obrigatória');
    }

    await repository.login(email, senha);
  }
}