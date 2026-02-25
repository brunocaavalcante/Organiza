import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/modules/categoria/data/repositories/categoria_repository_impl.dart';
import 'package:organiza2/app/modules/categoria/domain/repositories/i_categoria_repository.dart';
import 'package:organiza2/app/modules/categoria/domain/usecases/buscar_categorias_usecase.dart';
import 'package:organiza2/app/modules/categoria/domain/usecases/excluir_categoria_usecase.dart';
import 'package:organiza2/app/modules/categoria/domain/usecases/salvar_categoria_usecase.dart';
import 'package:organiza2/app/modules/categoria/presentation/controllers/categoria_controller.dart';
import 'package:organiza2/app/modules/categoria/presentation/pages/cadastro_categoria_page.dart';
import 'package:organiza2/app/modules/categoria/presentation/pages/select_categoria_page.dart';

class CategoriaModule extends Module {
  @override
  void binds(i) {    
    // Repository
    i.addLazySingleton<ICategoriaRepository>(
      () => CategoriaRepositoryImpl(
        Modular.get(), // FirebaseFirestore do AppModule
        Modular.get(), // FirebaseAuth do AppModule
      ),
    );

    // UseCases
    i.addLazySingleton(() => SalvarCategoriaUseCase(i.get()));
    i.addLazySingleton(() => ExcluirCategoriaUseCase(i.get()));
    i.addLazySingleton(() => BuscarCategoriasUseCase(i.get()));

    // Controller
    i.addLazySingleton<CategoriaController>(
      () => CategoriaController(
        i.get<SalvarCategoriaUseCase>(),
        i.get<ExcluirCategoriaUseCase>(),
        i.get<BuscarCategoriasUseCase>(),
      ),
    );
  }

  @override
  void routes(r) {
    r.child('/select', child: (context) => const SelectCategoriaPage());
    r.child('/cadastro', child: (context) => const CadastroCategoriaPage());
  }
}
