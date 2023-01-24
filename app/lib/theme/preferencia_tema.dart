import 'package:app/models/preferencia_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/usuario_service.dart';

class PreferenciaTema {
  static PreferenciaUser? preferenciaUser;
  static ValueNotifier<Brightness?> tema = ValueNotifier(Brightness.light);

  static ValueNotifier<Color?> corTema = ValueNotifier(Colors.blue);

  static ValueNotifier<List<ValueNotifier>> valueNotifier = ValueNotifier([]);

  static setTema(PreferenciaUser preferencia) async {
    tema.value =
        preferencia!.darkMode == true ? Brightness.dark : Brightness.light;
    corTema.value = Color(preferencia!.colorTheme ?? Colors.blue.value);
    valueNotifier.value = [];
    valueNotifier.value.add(tema);
    valueNotifier.value.add(corTema);
  }
}
