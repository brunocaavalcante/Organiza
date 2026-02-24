import '../../../../core/models/custom_exception.dart';
import '../entities/categoria.dart';
import '../repositories/i_categoria_repository.dart';

// UseCase: Salvar categoria com validações
class SalvarCategoriaUseCase {
  final ICategoriaRepository repository;

  SalvarCategoriaUseCase(this.repository);

  Future<void> call(Categoria categoria) async {
    if (categoria.descricao.isEmpty) {
      throw CustomException('Descrição não pode ser vazia');
    }

    if (categoria.descricao.length < 3) {
      throw CustomException('Descrição deve ter pelo menos 3 caracteres');
    }

    if (categoria.color == 0) {
      throw CustomException('Selecione uma cor para a categoria');
    }

    if (!categoria.isValid()) {
      throw CustomException('Categoria inválida');
    }

    await repository.save(categoria);
  }
}