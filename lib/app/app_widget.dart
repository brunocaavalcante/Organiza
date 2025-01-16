import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/core/utils/theme/preferencia_tema.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: PreferenciaTema.getTheme(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PreferenciaTema.configureTheme(snapshot);
            return ValueListenableBuilder(
                valueListenable: PreferenciaTema.valueNotifier,
                builder:
                    (BuildContext context, List<ValueNotifier> notifiers, _) {
                  return MaterialApp.router(
                    title: 'Organiza.',
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      useMaterial3: true,
                      colorSchemeSeed:
                          notifiers.isNotEmpty ? notifiers[1].value : null,
                      brightness:
                          notifiers.isNotEmpty ? notifiers[0].value : null,
                    ),
                    routerDelegate: Modular.routerDelegate,
                    routeInformationParser: Modular.routeInformationParser,
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
