import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/modules/navigation/presentation/controllers/navigation_controller.dart';
import 'package:organiza2/app/modules/navigation/presentation/pages/home_page.dart';
import 'package:organiza2/app/modules/operacao/operacao_module.dart';

class NavigationModule extends Module {
  @override
  List<Module> get imports => [
        OperacaoModule(),
      ];

  @override
  void binds(i) {
    i.addLazySingleton(NavigationController.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const HomePage());
  }
}
