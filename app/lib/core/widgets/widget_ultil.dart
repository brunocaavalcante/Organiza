import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetUltil {
  static barWithArrowBackIos(BuildContext context, String title) {
    return AppBar(
        title: Text(title),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context, true);
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
}
