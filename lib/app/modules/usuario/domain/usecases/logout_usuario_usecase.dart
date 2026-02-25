import '../repositories/i_usuario_repository.dart';

class LogoutUsuarioUseCase {
  final IUsuarioRepository repository;

  LogoutUsuarioUseCase(this.repository);

  Future<void> call() async {
    await repository.logout();
  }
}