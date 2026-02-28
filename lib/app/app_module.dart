// app_module.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/core/services/file_service.dart';
import 'package:organiza2/app/core/services/rotina.service.dart';
import 'package:organiza2/app/core/widgets/auth_check.dart';
import 'package:organiza2/app/modules/categoria/categoria_module.dart';
import 'package:organiza2/app/modules/navigation/navigation_module.dart';
import 'package:organiza2/app/modules/operacao/operacao_module.dart';
import 'package:organiza2/app/modules/usuario/usuario_module.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        UsuarioModule(),
      ];

  @override
  void binds(i) {
    // Firebase instances (compartilhadas globalmente)
    i.addLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    i.addLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
    
    // Global Services (compartilhados entre módulos)
    i.addLazySingleton(FileService.new);
    i.addLazySingleton(RotinaService.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const AuthCheck());
    r.module('/navigation', module: NavigationModule());
    r.module('/usuario', module: UsuarioModule());
    r.module('/operacao', module: OperacaoModule());
    r.module('/categoria', module: CategoriaModule());
  }
}
