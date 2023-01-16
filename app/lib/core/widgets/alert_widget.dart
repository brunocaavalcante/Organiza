import 'package:flutter/material.dart';

class Alertwidget {
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

  static alertRadios(BuildContext context, String title, String subtitle,
      List<String> options) {
    int? valueSelected = 0;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < options.length; i++)
                  ListTile(
                      title: Text(options[i]),
                      leading: Radio(
                        value: i,
                        groupValue: 1,
                        onChanged: (value) {
                          valueSelected = value;
                          print(valueSelected);
                        },
                      ))
              ],
            ),
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
                icon: Icon(Icons.check, size: 18),
                label: Text("OK"),
              )
            ]);
      },
    );
  }
}
