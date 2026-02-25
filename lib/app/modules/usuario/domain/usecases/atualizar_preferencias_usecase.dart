import '../../../../core/models/custom_exception.dart';
import '../entities/preferencia_usuario.dart';
import '../repositories/i_usuario_repository.dart';

class AtualizarPreferenciasUseCase {
  final IUsuarioRepository repository;

  AtualizarPreferenciasUseCase(this.repository);

  Future<void> call(String userId, PreferenciaUsuario preferencias) async {
    if (userId.isEmpty) {
      throw CustomException('Usuário não identificado');
    }

    if (!preferencias.isValidColor()) {
      throw CustomException('Cor do tema inválida');
    }

    await repository.updatePreferences(userId, preferencias);
  }
}