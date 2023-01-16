import 'package:app/core/widgets/widget_ultil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/date_ultils.dart';
import '../../core/masks.dart';
import '../../core/widgets/file_widget.dart';
import '../../models/custom_exception.dart';
import '../../models/usuario.dart';
import '../../services/file_service.dart';
import '../../services/usuario_service.dart';

class CadastroUserPage extends StatefulWidget {
  String operacao = "";
  Usuario user;
  CadastroUserPage({super.key, required this.user, required this.operacao});

  @override
  State<CadastroUserPage> createState() => _CadastroUserPageState();
}

class _CadastroUserPageState extends State<CadastroUserPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final dataNascimento = TextEditingController();
  final telefone = TextEditingController();
  final nome = TextEditingController();
  final senha = TextEditingController();
  final confirmSenha = TextEditingController();

  @override
  void initState() {
    if (widget.operacao.contains("Editar")) {
      nome.text = widget.user.name ?? "";
      email.text = widget.user.email ?? "";
      dataNascimento.text =
          DateUltils.formatarData(widget.user.dataNascimento) ?? "";
      telefone.text = widget.user.telefone ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double? espaco = 10;

    return Scaffold(
      appBar: WidgetUltil.barWithArrowBackIos(context, widget.operacao, true),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              FileWidget(
                  urlImagem: widget.user.photo,
                  destino: 'usuarios',
                  refImage: widget.user.refPhoto),
              SizedBox(height: espaco),
              WidgetUltil.returnField(
                  "Nome: ", nome, TextInputType.name, null, ""),
              SizedBox(height: espaco),
              WidgetUltil.returnField(
                  "Telefone: ",
                  telefone,
                  TextInputType.phone,
                  [Masks.telefoneFormatter, Masks.celularFormatter],
                  "(##) ##### - ####"),
              SizedBox(height: espaco),
              WidgetUltil.returnField("Data Nascimento: ", dataNascimento,
                  TextInputType.datetime, [Masks.dataFormatter], "##/##/####"),
              SizedBox(height: espaco),
              WidgetUltil.returnField(
                  "E-mail: ", email, TextInputType.emailAddress, null, ""),
              SizedBox(height: espaco),
              fieldSenha(),
              SizedBox(height: espaco),
              fieldConfirmSenha(),
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
        await registrar();
      }
    });
  }

  registrar() async {
    try {
      var usuario = Usuario();
      usuario.name = nome.text;
      usuario.telefone = telefone.text;
      usuario.email = email.text;
      usuario.senha = senha.text;
      usuario.confirmSenha = confirmSenha.text;
      usuario.dataNascimento = DateUltils.stringToDate(dataNascimento.text);
      usuario.photo = context.read<FileService>().destino == ""
          ? widget.user.photo
          : context.read<FileService>().destino;
      usuario.refPhoto = context.read<FileService>().refImage == ""
          ? widget.user.refPhoto
          : context.read<FileService>().refImage;

      if (widget.operacao.contains("Cadastro")) {
        await Provider.of<UserService>(context, listen: false)
            .registrar(usuario);
      }

      if (widget.operacao.contains("Editar")) {
        await Provider.of<UserService>(context, listen: false)
            .atualizar(usuario);
      }

      Navigator.pop(context);
    } on CustomException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Widget fieldSenha() {
    return TextFormField(
        obscureText: true,
        controller: senha,
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
        controller: confirmSenha,
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
          if (value != senha.text) return "Senhas diferentes!";
          return null;
        });
  }
}
