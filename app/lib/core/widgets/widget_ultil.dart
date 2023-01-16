import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetUltil {
  static barWithArrowBackIos(BuildContext context, String title, dataRetorno) {
    return AppBar(
        title: Text(title),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context, dataRetorno);
            }));
  }

  static Widget returnField(String? label, TextEditingController ctr,
      TextInputType? type, List<TextInputFormatter>? masks, String hint,
      [bool obscureText = false]) {
    return TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            hintText: hint),
        controller: ctr,
        inputFormatters: masks,
        keyboardType: type,
        validator: (value) {
          if (value == null || value.isEmpty) return "Campo obrigatorio";
          return null;
        });
  }

  static Widget returnTextErro(msg, Color cor) {
    return Container(
      margin: const EdgeInsets.only(left: 12, top: 5),
      child: Text(msg, style: TextStyle(color: cor, fontSize: 12)),
    );
  }

  static Widget returnDimissibleExcluir(
      Widget filho, Function(DismissDirection)? onDismissed) {
    return Container(
        margin: const EdgeInsets.only(top: 3),
        child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: onDismissed,
            background: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: Colors.red),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.centerRight,
                child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: const Text("Excluir",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)))),
            child: filho));
  }

  static Widget returnButtonSalvar(Function()? onPressed) {
    return ElevatedButton(
        onPressed: onPressed,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Icon(Icons.save),
          Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Salvar", style: TextStyle(fontSize: 20)))
        ]));
  }

  static Widget returnButtonEditar(Function()? onPressed) {
    return ElevatedButton(
        onPressed: onPressed,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Icon(Icons.edit),
          Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Editar", style: TextStyle(fontSize: 20)))
        ]));
  }

  static Widget returnButtonExcluir(Function()? onPressed) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll<Color>(Colors.red.withOpacity(0.5))),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Icons.delete_forever,
            color: Colors.white.withOpacity(0.8),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Excluir",
                  style: TextStyle(
                      fontSize: 20, color: Colors.white.withOpacity(0.8))))
        ]));
  }
}
