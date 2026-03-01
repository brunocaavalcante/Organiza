import '../entities/categoria.dart';
import '../repositories/i_categoria_repository.dart';

// UseCase: Buscar todas categorias (gerais + usuário)
class BuscarCategoriasUseCase {
  final ICategoriaRepository repository;

  BuscarCategoriasUseCase(this.repository);

  Future<List<Categoria>> call() async {
    final categorias = await repository.getAll();
    
    categorias.sort((a, b) => a.descricao.compareTo(b.descricao));
    
    return categorias;
  }
}