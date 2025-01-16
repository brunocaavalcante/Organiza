import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/modules/usuario/views/cadastro_user_page.dart';
import 'package:organiza2/app/modules/usuario/views/login_page.dart';
import 'package:organiza2/app/modules/usuario/views/settings_page.dart';

class UsuarioModule extends Module {
  @override
  void binds(i) {
    
  }

  @override
  void routes(r) {
    r.child('/login', child: (context) => const LoginPage());
    r.child('/cadastro', child:(context) => const CadastroUserPage());
    r.child('/settings', child:(context) => const SettingsPage());
  }
}
