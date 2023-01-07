import 'package:app/services/despesa_service.dart';
import 'package:app/services/file_service.dart';
import 'package:app/services/usuario_service.dart';
import 'package:app/theme/preferencia_tema.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/widgets/auth_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserService()),
    ChangeNotifierProvider(create: (context) => FileService()),
    ChangeNotifierProvider(create: (context) => DespesaService())
  ], child: const App()));
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    PreferenciaTema.setTema();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    PreferenciaTema.setTema();
  }

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: PreferenciaTema.tema,
      builder: (BuildContext context, Brightness tema, _) => MaterialApp(
        title: 'Organiza.',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.green,
          brightness: tema,
        ),
        home: const AuthCheck(),
      ),
    );
  }
}
