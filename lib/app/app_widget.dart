import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/core/utils/theme/preferencia_tema.dart';
import 'package:organiza2/app/modules/usuario/presentation/controllers/usuario_controller.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  late final UsuarioController _usuarioController;

  @override
  void initState() {
    super.initState();
    _usuarioController = Modular.get<UsuarioController>();
    _carregarTema();
  }

  Future<void> _carregarTema() async {
    try {
      final usuario = await _usuarioController.obterUsuario();
      if (usuario != null && mounted) {
        PreferenciaTema.setTema(usuario.preferencias);
      }
    } catch (e) {
      print('Erro ao carregar tema: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: PreferenciaTema.valueNotifier,
        builder: (BuildContext context, List<ValueNotifier> notifiers, _) {
          return MaterialApp.router(
            title: 'Organiza.',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed:
                  notifiers.isNotEmpty ? notifiers[1].value : Colors.blue,
              brightness:
                  notifiers.isNotEmpty ? notifiers[0].value : Brightness.light,
            ),
            routerDelegate: Modular.routerDelegate,
            routeInformationParser: Modular.routeInformationParser,
          );
        });
  }
}
