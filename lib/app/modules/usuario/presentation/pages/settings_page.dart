import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../controllers/usuario_controller.dart';
import '../widgets/select_color_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final usuarioController = Modular.get<UsuarioController>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: usuarioController.obterPreferenciaUsuario(),
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(title: const Text("Configurações")), body: body());
        });
  }

  body() {
    var altura = MediaQuery.of(context).size.height;
    var largura = MediaQuery.of(context).size.width;
    var tema = Theme.of(context);

    return Container(
        margin: EdgeInsets.only(top: altura * 0.05, left: largura * 0.04),
        child: Column(children: [
          Row(children: [
            Icon(Icons.settings, color: tema.colorScheme.secondary, size: 26),
            SizedBox(width: largura * 0.02),
            const Text("Preferências",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
          ]),
          Divider(
              height: altura * 0.02,
              thickness: 1,
              endIndent: 15,
              color: tema.hintColor.withOpacity(0.25)),
          returnItem("Alterar cor do tema", tema.hintColor, alterarCorTema()),
          returnAlterarTemaItem("Tema escuro", tema.hintColor),
          SizedBox(height: altura * 0.06),
          Row(children: [
            Icon(Icons.manage_accounts,
                color: tema.colorScheme.secondary, size: 26),
            SizedBox(width: largura * 0.02),
            const Text("Usuario",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
          ]),
          Divider(
              height: altura * 0.02,
              thickness: 1,
              endIndent: 15,
              color: tema.hintColor.withOpacity(0.25)),
          returnItem("Editar meu perfil", tema.hintColor, editarPerfil()),
          returnItem("Alterar minha senha", tema.hintColor, null),
          returnItem("Sair", tema.hintColor, sair()),
        ]));
  }

  returnItem(String txt, Color color, Function()? onPressed) {
    return InkWell(
        onTap: onPressed,
        child: ListTile(
            title: Text(
              txt,
              style: TextStyle(fontFamily: "Arial", color: color, fontSize: 20),
            ),
            trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: onPressed)));
  }

  returnAlterarTemaItem(String txt, Color color) {
    return ListTile(
        title: Text(
          txt,
          style: TextStyle(fontFamily: "Arial", color: color, fontSize: 20),
        ),
        trailing: Switch(
            value: usuarioController.theme.value.darkMode,
            onChanged: (value) async {
              usuarioController.theme.value = 
                  usuarioController.theme.value.copyWith(darkMode: value);
              await usuarioController.atualizarPreferenciaUsuario();
            }));
  }

  Function()? editarPerfil() {
    return (() async {
      var user = await usuarioController.obterUsuario();
      Modular.to.pushNamed('/usuario/cadastro', arguments: {
        'user': user,
        'operacao': 'Editar',
      });
    });
  }

  Function()? sair() {
    return ((() async {
      await usuarioController.logout();
    }));
  }

  Function()? alterarCorTema() {
    return (() async {
      var color = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SelectColorPage())) ??
          Colors.amber;

      if (color != null) {
        usuarioController.theme.value = 
            usuarioController.theme.value.copyWith(colorTheme: color.value);
        await usuarioController.atualizarPreferenciaUsuario();
      }
    });
  }
}
