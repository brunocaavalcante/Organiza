import 'package:app/models/preferencia_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/usuario.dart';

class PreferenciaTema {
  static PreferenciaUser? preferenciaUser;
  static ValueNotifier<Brightness?> tema = ValueNotifier(Brightness.light);

  static ValueNotifier<Color?> corTema = ValueNotifier(Colors.blue);

  static ValueNotifier<List<ValueNotifier>> valueNotifier = ValueNotifier([]);

  static setTema(PreferenciaUser preferencia) async {
    if (preferencia.colorTheme != null) {
      tema.value =
          preferencia.darkMode == true ? Brightness.dark : Brightness.light;
      corTema.value = Color(preferencia.colorTheme ?? Colors.blue.value);
      valueNotifier.value = [];
      valueNotifier.value.add(tema);
      valueNotifier.value.add(corTema);
    }
  }

  static Future getTheme() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid.toString())
          .get();
    } else {
      return "";
    }
  }

  static configureTheme(snapshot) {
    if (snapshot.data == "") {
      PreferenciaTema.setTema(PreferenciaUser());
    } else {
      Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
      var retorno = Usuario().toEntity(data);
      retorno.id = snapshot.data!.id;
      setTema(retorno.preferencias);
    }
  }
}
