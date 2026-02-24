import '../entities/categoria.dart';

abstract class ICategoriaRepository {
  Future<void> save(Categoria categoria);
  Future<void> delete(String id);

  /// Busca todas categorias (gerais + do usuário)
  Future<List<Categoria>> getAll();

  /// Busca apenas categorias do usuário específico
  Future<List<Categoria>> getByUserId(String userId);

  /// Busca categorias gerais (compartilhadas)
  Future<List<Categoria>> getCategoriasGerais();
}
