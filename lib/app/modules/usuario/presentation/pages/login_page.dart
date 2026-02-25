import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/models/custom_exception.dart';
import '../controllers/usuario_controller.dart';
import '../../domain/entities/usuario.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usuarioController = Modular.get<UsuarioController>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150.0,
                  child: Image.asset("lib/assets/main-icon.png",
                      fit: BoxFit.contain),
                ),
                const Text(
                  "Bem vindo",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                returnInput(usuarioController.email, false, 'Email',
                    TextInputType.emailAddress, 'Campo Obrigatório!'),
                returnInput(usuarioController.senha, true, 'Senha',
                    TextInputType.number, 'Campo Obrigatório!'),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          await usuarioController.login();
                        } on CustomException catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.message),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erro ao fazer login: ${e.toString()}'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (usuarioController.isLoading.value)
                          ? [
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ]
                          : [
                              const Icon(Icons.check),
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text("Login",
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Modular.to.pushNamed('/usuario/cadastro', arguments: {
                      'user': Usuario.empty(),
                      'operacao': 'Cadastro de Usuário',
                    });
                  },
                  child: const Text("Ainda não tem conta? Cadastre-se agora."),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  returnInput(TextEditingController controller, bool txtOculto, String label,
      TextInputType type, String msgError) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: TextFormField(
        controller: controller,
        obscureText: txtOculto,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        keyboardType: type,
        validator: (value) {
          if (value!.isEmpty) {
            return msgError;
          }
          return null;
        },
      ),
    );
  }
}
