import 'package:app/models/preferencia_user.dart';
import 'package:app/models/usuario.dart';
import 'package:app/theme/preferencia_tema.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/select_color_page.dart';
import '../../main.dart';
import '../../services/usuario_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  PreferenciaUser theme = PreferenciaUser();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: obterPreferenciaUsuario(),
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(title: const Text("Configurações")), body: body());
        });
  }

  Future obterPreferenciaUsuario() async {
    UserService auth = Provider.of<UserService>(context, listen: false);
    var item = await auth.obterPreferenciaUsuario();

    if (item!.exists) {
      Map<String, dynamic> data = item.data()! as Map<String, dynamic>;
      var retorno = Usuario().toEntity(data);
      retorno.id = item.id;
      theme = retorno.preferencias;
    }
  }

  body() {
    var altura = MediaQuery.of(context).size.height;
    var largura = MediaQuery.of(context).size.width;
    var tema = Theme.of(context);

    return Container(
        margin: EdgeInsets.only(top: altura * 0.05, left: largura * 0.04),
        child: Column(children: [
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
          returnItem("Editar meu perfil", tema.hintColor, null),
          returnItem("Alterar minha senha", tema.hintColor, null),
          SizedBox(height: altura * 0.06),
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
          returnAlterarTemaItem("Tema escuro", tema.hintColor)
        ]));
  }

  returnItem(String txt, Color color, Function()? onPressed) {
    return ListTile(
        title: Text(
          txt,
          style: TextStyle(fontFamily: "Arial", color: color, fontSize: 20),
        ),
        trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios), onPressed: onPressed));
  }

  returnAlterarTemaItem(String txt, Color color) {
    return ListTile(
        title: Text(
          txt,
          style: TextStyle(fontFamily: "Arial", color: color, fontSize: 20),
        ),
        trailing: Switch(
            value: theme.darkMode ?? false,
            onChanged: (value) async {
              UserService auth =
                  Provider.of<UserService>(context, listen: false);

              theme.darkMode = value;
              await auth.atualizarPreferencia(theme);
              setState(() {
                PreferenciaTema.setTema(theme);
              });
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
        UserService auth = Provider.of<UserService>(context, listen: false);
        theme.colorTheme = color?.value;
        await auth.atualizarPreferencia(theme);
      }
      setState(() {
        PreferenciaTema.setTema(theme);
      });
    });
  }
}
