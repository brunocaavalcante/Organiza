import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/modules/navigation/presentation/controllers/navigation_controller.dart';
import 'package:organiza2/app/modules/navigation/presentation/pages/home_page.dart';

class NavigationModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(NavigationController.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const HomePage());
  }
}
