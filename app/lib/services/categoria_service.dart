import 'package:app/models/categoria.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/custom_exception.dart';

class CategoriaService extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference categorias =
      FirebaseFirestore.instance.collection('categorias-user');

  salvar(Categoria item) async {
    if (auth.currentUser != null) {
      await categorias
          .doc(auth.currentUser!.uid)
          .collection("categorias")
          .add(item.toJson())
          .catchError((error) => throw CustomException(
              "ocorreu um erro ao cadastrar tente novamente"));
    }
  }

  excluir(String id) async {
    if (auth.currentUser != null) {
      await categorias
          .doc(auth.currentUser!.uid)
          .collection("categorias")
          .doc(id)
          .delete()
          .catchError((error) => throw CustomException(
              "ocorreu um erro ao excluir tente novamente"));
    }
  }
}
