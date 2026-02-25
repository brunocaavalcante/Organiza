import '../entities/usuario.dart';
import '../entities/preferencia_usuario.dart';

abstract class IUsuarioRepository {
  // Autenticação
  Future<void> register(Usuario usuario, String senha);
  Future<void> login(String email, String senha);
  Future<void> logout();

  // CRUD
  Future<Usuario?> getById(String id);
  Future<Usuario?> getByEmail(String email);
  Future<Usuario?> getCurrentUser();
  Future<void> update(Usuario usuario);

  // Preferências
  Future<void> updatePreferences(String userId, PreferenciaUsuario preferencias);

  // Stream de autenticação - retorna o userId ou null
  Stream<String?> get authStateChanges;
}