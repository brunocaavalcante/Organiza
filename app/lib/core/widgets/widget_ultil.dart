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
    return Text(msg, style: TextStyle(color: cor, fontSize: 10));
  }

  static Widget returnDimissibleExcluir(
      Widget filho, Function(DismissDirection)? onDismissed) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10, top: 10),
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
          child: filho,
        ));
  }
}
