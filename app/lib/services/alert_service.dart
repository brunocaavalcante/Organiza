import 'package:app/models/operacao.dart';
import 'package:flutter/material.dart';

class AlertService {
  static int opSelecionada = 0;
  static alertConfirm(BuildContext context, String title, String subtitle) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title),
            content: Text(subtitle),
            actions: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close, size: 18),
                label: Text("Cancelar"),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.close, size: 18),
                label: Text("OK"),
              )
            ]);
      },
    );
  }

  static alertRadios(BuildContext context, String title, String desc,
      List<String> options, Operacao op, Function()? onPressedOk) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(title,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(desc),
                  for (var i = 0; i < options.length; i++)
                    Row(children: [
                      Radio(
                          value: i,
                          groupValue: opSelecionada,
                          onChanged: (int? value) {
                            setState(() {
                              opSelecionada = value ?? 0;
                            });
                          }),
                      Text(options[i])
                    ])
                ]);
              }),
              actions: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text("Cancelar"),
                ),
                ElevatedButton.icon(
                  onPressed: onPressedOk,
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text("OK"),
                )
              ]);
        });
  }
}
