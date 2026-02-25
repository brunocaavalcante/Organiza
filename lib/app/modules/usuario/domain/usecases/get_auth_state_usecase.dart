import '../repositories/i_usuario_repository.dart';

class GetAuthStateUseCase {
  final IUsuarioRepository repository;

  GetAuthStateUseCase(this.repository);

  Stream<String?> call() {
    return repository.authStateChanges;
  }
}