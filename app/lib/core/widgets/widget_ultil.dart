import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetUltil {
  static barWithArrowBackIos(BuildContext context, String title, dataRetorno,
      [List<Widget>? actions]) {
    return AppBar(
        actions: actions,
        title: Text(title),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context, dataRetorno);
            }));
  }

  static Widget returnField(String? label, TextEditingController ctr,
      TextInputType? type, List<TextInputFormatter>? masks, String hint,
      [bool obscureText = false, String? Function(String?)? validacao]) {
    return TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            hintText: hint),
        controller: ctr,
        inputFormatters: masks,
        keyboardType: type,
        validator: validacao);
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

  static Widget returnButton(String txt, IconData icon, Function()? onPressed,
      [Color? color, Color? textColor]) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: onPressed,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: textColor),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child:
                  Text(txt, style: TextStyle(fontSize: 15, color: textColor)))
        ]));
  }

  static Widget returnButtonIcon(
      IconData icon, Color color, Function()? onPressed) {
    return IconButton(
        onPressed: onPressed, icon: Icon(icon, size: 25, color: color));
  }

  static Widget barraConsulta(Function(String)? onchange) {
    return TextField(
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search, size: 35),
            border: OutlineInputBorder(),
            hintText: "Procurar..."),
        onChanged: onchange);
  }

  static customRadioButton(String text, int index, Color color,
      [Function()? onpressed, IconData? icon]) {
    return OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color),
        ),
        onPressed: onpressed,
        icon: icon == null
            ? const SizedBox(width: 0, height: 0)
            : Icon(icon, color: color),
        label: Text(text, style: TextStyle(color: color)));
  }
}
