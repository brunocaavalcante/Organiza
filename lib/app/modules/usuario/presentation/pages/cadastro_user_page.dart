import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/models/custom_exception.dart';
import '../../../../core/utils/validator/email_validator.dart';
import '../controllers/usuario_controller.dart';
import '../../domain/entities/usuario.dart';
import '../../../../core/utils/date_ultils.dart';
import '../../../../core/utils/masks.dart';
import '../../../../core/widgets/widget_ultil.dart';
import '../../../../core/widgets/file_ultil.dart';

class CadastroUserPage extends StatefulWidget {
  const CadastroUserPage({super.key});

  @override
  State<CadastroUserPage> createState() => _CadastroUserPageState();
}

class _CadastroUserPageState extends State<CadastroUserPage> {
  final usuarioController = Modular.get<UsuarioController>();
  final formKey = GlobalKey<FormState>();
  late String operacao = "";
  late Usuario user;

  @override
  void initState() {
    final args = Modular.args.data;
    user = args['user'] ?? Usuario.empty();
    operacao = args['operacao'] ?? 'Cadastro';

    if (operacao.contains("Editar")) {
      usuarioController.popularFormulario(user);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double? espaco = 10;

    return Scaffold(
      appBar: WidgetUltil.barWithArrowBackIos(context, operacao, true),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              FileUtil(context, user.photoUrl, 'usuarios', user.photoRef)
                  .fieldPhoto(),
              SizedBox(height: espaco),
              WidgetUltil.returnField("Nome: ", usuarioController.nome,
                  TextInputType.name, null, "", false, validacaoSimples()),
              SizedBox(height: espaco),
              WidgetUltil.returnField(
                  "Telefone: ",
                  usuarioController.telefone,
                  TextInputType.phone,
                  [Masks.celularFormatter],
                  "(##) ##### - ####"),
              SizedBox(height: espaco),
              WidgetUltil.returnField(
                  "Data Nascimento: ",
                  usuarioController.dataNascimento,
                  TextInputType.datetime,
                  [Masks.dataFormatter],
                  "##/##/####",
                  false,
                  validarDataVencimento()),
              SizedBox(height: espaco),
              WidgetUltil.returnField("E-mail: ", usuarioController.email,
                  TextInputType.emailAddress, null, "", false, validarEmail()),
              SizedBox(height: espaco),
              operacao.contains("Editar") ? Container() : fieldSenha(),
              SizedBox(height: espaco),
              operacao.contains("Editar") ? Container() : fieldConfirmSenha(),
              SizedBox(height: espaco),
              WidgetUltil.returnButtonSalvar(onPressedSalvar())
            ],
          ),
        ),
      )),
    );
  }

  onPressedSalvar() {
    return (() async {
      if (formKey.currentState!.validate()) {
        try {
          await usuarioController.registrar(user: user, operacao: operacao);
        } on CustomException catch (e) {
          e.show(context);
        }
      }
    });
  }

  Widget fieldSenha() {
    return TextFormField(
        obscureText: true,
        controller: usuarioController.senha,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: 'Senha:'),
        validator: (value) {
          if (value!.isEmpty) {
            return "Campo obrigatório";
          }
          if (value.length < 6) {
            return "Senha deve ter no minímo 6 caracteres.";
          }
          return null;
        });
  }

  Widget fieldConfirmSenha() {
    return TextFormField(
        obscureText: true,
        controller: usuarioController.confirmSenha,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: 'Confirmar senha:'),
        validator: (value) {
          if (value!.isEmpty) {
            return "Campo obrigatório";
          }
          if (value.length < 6) {
            return "Senha deve ter no minímo 6 caracteres.";
          }
          if (value != usuarioController.senha.text) {
            return "Senhas diferentes!";
          }
          return null;
        });
  }

//VALIDAÇÕES
  String? Function(String?)? validacaoSimples() {
    return (((value) {
      if (value == "") {
        if (value == null || value.isEmpty) return "Campo obrigatório";
        return null;
      }
      return null;
    }));
  }

  String? Function(String?)? validarDataVencimento() {
    return (((value) {
      if (value != null && value != "") {
        DateTime? data = DateUltils.stringToDate(value);
        if (data == null) return "Data de nascimento inválida";
      }

      if (value == "") return "Campo obrigatório";
      return null;
    }));
  }
}
