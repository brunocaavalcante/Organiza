import '../../../../core/models/custom_exception.dart';
import '../entities/categoria.dart';
import '../repositories/i_categoria_repository.dart';

// UseCase: Buscar apenas categorias do usuário
class BuscarCategoriasUsuarioUseCase {
  final ICategoriaRepository repository;

  BuscarCategoriasUsuarioUseCase(this.repository);

  Future<List<Categoria>> call(String userId) async {
    if (userId.isEmpty) {
      throw CustomException('ID do usuário inválido');
    }

    // Buscar apenas categorias do usuário
    return await repository.getByUserId(userId);
  }
}
