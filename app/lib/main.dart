import 'package:app/models/usuario.dart';
import 'package:app/services/operacao_service.dart';
import 'package:app/services/file_service.dart';
import 'package:app/services/usuario_service.dart';
import 'package:app/theme/preferencia_tema.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/widgets/auth_check.dart';
import 'services/categoria_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserService()),
    ChangeNotifierProvider(create: (context) => FileService()),
    ChangeNotifierProvider(create: (context) => OperacaoService()),
    ChangeNotifierProvider(create: (context) => CategoriaService())
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
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    var users = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid.toString())
        .get();

    return FutureBuilder(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            var retorno = Usuario().toEntity(data);
            retorno.id = snapshot.data!.id;
            PreferenciaTema.setTema(retorno.preferencias);

            return ValueListenableBuilder(
                valueListenable: PreferenciaTema.valueNotifier,
                builder: (BuildContext context, List<ValueNotifier> notifiers,
                        _) =>
                    MaterialApp(
                        title: 'Organiza.',
                        debugShowCheckedModeBanner: false,
                        theme: ThemeData(
                          useMaterial3: true,
                          colorSchemeSeed:
                              notifiers.length > 0 ? notifiers[1].value : null,
                          brightness:
                              notifiers.length > 0 ? notifiers[0].value : null,
                        ),
                        home: const AuthCheck()));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
