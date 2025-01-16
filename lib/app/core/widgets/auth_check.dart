import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:organiza2/app/modules/usuario/core/services/usuario_service.dart';
import '../../modules/home/home_page.dart';
import '../../modules/usuario/views/login_page.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  UserService auth = Modular.get<UserService>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
       if (auth.isLoading.value) {
        return loading();
      } else if (auth.usuario.value == null) {
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
