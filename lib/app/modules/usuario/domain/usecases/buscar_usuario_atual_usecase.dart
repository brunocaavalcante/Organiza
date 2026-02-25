import '../entities/usuario.dart';
import '../repositories/i_usuario_repository.dart';

class BuscarUsuarioAtualUseCase {
  final IUsuarioRepository repository;

  BuscarUsuarioAtualUseCase(this.repository);

  Future<Usuario?> call() async {
    return await repository.getCurrentUser();
  }
}