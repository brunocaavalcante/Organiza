// app_module.dart
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/core/services/categoria_service.dart';
import 'package:organiza2/app/core/services/file_service.dart';
import 'package:organiza2/app/modules/operacao/controller/operacao_controller.dart';
import 'package:organiza2/app/modules/operacao/controller/operacao_shared_controller.dart';
import 'package:organiza2/app/modules/operacao/core/services/operacao_service.dart';
import 'package:organiza2/app/modules/operacao/core/services/operacao_shared_service.dart';
import 'package:organiza2/app/core/services/rotina.service.dart';
import 'package:organiza2/app/core/widgets/auth_check.dart';
import 'package:organiza2/app/modules/operacao/operacao_module.dart';
import 'package:organiza2/app/modules/usuario/controllers/usuario_controller.dart';
import 'package:organiza2/app/modules/usuario/core/services/usuario_service.dart';
import 'package:organiza2/app/modules/usuario/usuario_module.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(UserService.new);
    i.addLazySingleton(FileService.new);
    i.addLazySingleton(OperacaoService.new);
    i.addLazySingleton(OperacaoSharedService.new);
    i.addLazySingleton(CategoriaService.new);
    i.addLazySingleton(RotinaService.new);
    i.addLazySingleton(UsuarioController.new);
    i.addLazySingleton(OperacaoController.new);
    i.addLazySingleton(OperacaoSharedController.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const AuthCheck());
    r.module('/usuario', module: UsuarioModule());
    r.module('/operacao', module: OperacaoModule());
  }
}
