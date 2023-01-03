import 'package:app/models/usuario.dart';
import 'package:app/pages/usuario/cadastro_user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/custom_exception.dart';
import '../../services/usuario_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  bool isLogin = true;
  bool loading = false;

  login() async {
    setState(() => loading = true);
    try {
      await context.read<UserService>().login(email.text, senha.text);
    } on CustomException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

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
                  child:
                      Image.asset("imagens/main-icon.png", fit: BoxFit.contain),
                ),
                const Text(
                  "Bem vindo",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                returnInput(email, false, 'Email', TextInputType.emailAddress,
                    'Campo Obrigatório!'),
                returnInput(senha, true, 'Senha', TextInputType.number,
                    'Campo Obrigatório!'),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        login();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (loading)
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CadastroUserPage(
                                  user: Usuario(),
                                  operacao: "Cadastro de Usuário",
                                )));
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
