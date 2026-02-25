import 'package:flutter_modular/flutter_modular.dart';
import 'data/repositories/usuario_repository_impl.dart';
import 'domain/repositories/i_usuario_repository.dart';
import 'domain/usecases/atualizar_preferencias_usecase.dart';
import 'domain/usecases/atualizar_usuario_usecase.dart';
import 'domain/usecases/buscar_usuario_atual_usecase.dart';
import 'domain/usecases/buscar_usuario_por_email_usecase.dart';
import 'domain/usecases/get_auth_state_usecase.dart';
import 'domain/usecases/login_usuario_usecase.dart';
import 'domain/usecases/logout_usuario_usecase.dart';
import 'domain/usecases/registrar_usuario_usecase.dart';
import 'presentation/controllers/usuario_controller.dart';
import 'presentation/pages/cadastro_user_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/settings_page.dart';

class UsuarioModule extends Module {
  @override
  void binds(i) {
    // Repository
    i.addLazySingleton<IUsuarioRepository>(
      () => UsuarioRepositoryImpl(Modular.get(), Modular.get()),
    );

    // Use Cases
    i.addLazySingleton(() => RegistrarUsuarioUseCase(i.get()));
    i.addLazySingleton(() => LoginUsuarioUseCase(i.get()));
    i.addLazySingleton(() => LogoutUsuarioUseCase(i.get()));
    i.addLazySingleton(() => AtualizarUsuarioUseCase(i.get()));
    i.addLazySingleton(() => BuscarUsuarioAtualUseCase(i.get()));
    i.addLazySingleton(() => BuscarUsuarioPorEmailUseCase(i.get()));
    i.addLazySingleton(() => AtualizarPreferenciasUseCase(i.get()));
    i.addLazySingleton(() => GetAuthStateUseCase(i.get()));

    // Controller
    i.addSingleton<UsuarioController>(
      () {
        final controller = UsuarioController(
          i.get<RegistrarUsuarioUseCase>(),
          i.get<LoginUsuarioUseCase>(),
          i.get<LogoutUsuarioUseCase>(),
          i.get<AtualizarUsuarioUseCase>(),
          i.get<BuscarUsuarioAtualUseCase>(),
          i.get<BuscarUsuarioPorEmailUseCase>(),
          i.get<AtualizarPreferenciasUseCase>(),
          i.get<GetAuthStateUseCase>(),
        );
        controller.onInit(); // Inicializa o listener de autenticação
        return controller;
      },
    );
  }

  @override
  void routes(r) {
    r.child('/login', child: (context) => const LoginPage());
    r.child('/cadastro', child: (context) => const CadastroUserPage());
    r.child('/settings', child: (context) => const SettingsPage());
  }
}
