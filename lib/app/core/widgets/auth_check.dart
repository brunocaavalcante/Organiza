import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:organiza2/app/modules/usuario/presentation/controllers/usuario_controller.dart';
import '../../modules/home/home_page.dart';
import '../../modules/usuario/presentation/pages/login_page.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  late final UsuarioController usuarioController;
  
  @override
  void initState() {
    super.initState();
    usuarioController = Modular.get<UsuarioController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
       if (usuarioController.isLoading.value) {
        return loading();
      } else if (usuarioController.usuarioAtual.value == null) {
        return const LoginPage();
      } else {
        return const HomePage(
          title: "Home",
        );
      }
    });   
  }

  loading() {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
