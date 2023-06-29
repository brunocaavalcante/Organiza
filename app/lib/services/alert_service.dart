import 'package:app/models/operacao.dart';
import 'package:flutter/material.dart';

class AlertService {
  static int opSelecionada = 0;
  static alertAviso(BuildContext context, String title, String subtitle) {
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
                icon: const Icon(Icons.task_alt_sharp, size: 18),
                label: const Text("Ok"),
              )
            ]);
      },
    );
  }

  static alertConfirmAnexar(BuildContext context, String title, String subtitle,
      Function()? onPressedAnexar, Function()? onPressedCancelar) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title),
            content: Text(subtitle),
            actions: [
              ElevatedButton.icon(
                onPressed: onPressedCancelar,
                icon: const Icon(Icons.close, size: 18),
                label: const Text("Cancelar"),
              ),
              ElevatedButton.icon(
                onPressed: onPressedAnexar,
                icon: const Icon(Icons.file_present, size: 18),
                label: const Text("Anexar"),
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
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold)),
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

  static alertSelect(
      BuildContext context, String title, String? desc, List<String> options,
      [Function()? onPressedOk]) {
    int indexItemSelected = 0;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(title,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold)),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Container(
                    height: 300.0, // Change as per your requirement
                    width: 300.0, // Change as per your requirement
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          return options[index] == ""
                              ? Container()
                              : ListTile(
                                  onTap: () {
                                    indexItemSelected = index;
                                    setState(() {});
                                  },
                                  title: Text(options[index],
                                      style: TextStyle(
                                          color: index == indexItemSelected
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : null)));
                        }));
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
                  onPressed: () => Navigator.pop(context, indexItemSelected),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text("OK"),
                )
              ]);
        });
  }
}
