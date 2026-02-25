import 'package:flutter/material.dart';
import 'package:organiza2/app/modules/usuario/domain/entities/preferencia_usuario.dart';

class PreferenciaTema {
  static PreferenciaUsuario? preferenciaUser;
  static ValueNotifier<Brightness?> tema = ValueNotifier(Brightness.light);

  static ValueNotifier<Color?> corTema = ValueNotifier(Colors.blue);

  static ValueNotifier<List<ValueNotifier>> valueNotifier = ValueNotifier([]);

  static setTema(PreferenciaUsuario preferencia) async {
    preferenciaUser = preferencia;
    tema.value = preferencia.darkMode ? Brightness.dark : Brightness.light;
    corTema.value = Color(preferencia.colorTheme);
    valueNotifier.value = [];
    valueNotifier.value.add(tema);
    valueNotifier.value.add(corTema);
  }
}
