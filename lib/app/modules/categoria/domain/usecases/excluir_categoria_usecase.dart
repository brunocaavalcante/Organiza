import '../../../../core/models/custom_exception.dart';
import '../repositories/i_categoria_repository.dart';

// UseCase: Excluir categoria
class ExcluirCategoriaUseCase {
  final ICategoriaRepository repository;

  ExcluirCategoriaUseCase(this.repository);

  Future<void> call(String id) async {
    if (id.isEmpty) {
      throw CustomException('ID da categoria inválido');
    }

    await repository.delete(id);
  }
}