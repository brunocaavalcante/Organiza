import '../../../../core/models/custom_exception.dart';
import '../entities/usuario.dart';
import '../repositories/i_usuario_repository.dart';

class BuscarUsuarioPorEmailUseCase {
  final IUsuarioRepository repository;

  BuscarUsuarioPorEmailUseCase(this.repository);

  Future<Usuario?> call(String email) async {
    if (email.isEmpty) {
      throw CustomException('Email é obrigatório');
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(email)) {
      throw CustomException('Email inválido');
    }

    return await repository.getByEmail(email);
  }
}