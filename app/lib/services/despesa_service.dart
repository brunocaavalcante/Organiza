import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/custom_exception.dart';
import '../models/despesa.dart';

class DespesaService {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference despesas =
      FirebaseFirestore.instance.collection('despesas');

  salvar(Despesa item) async {
    if (auth.currentUser != null) {
      await despesas
          .doc(auth.currentUser!.uid.toString())
          .collection("1/2023")
          .add(item.toJson())
          .catchError((error) => throw CustomException(
              "ocorreu um erro ao cadastrar tente novamente"));
    }
  }

  atualizar(Despesa item) async {
    if (auth.currentUser != null) {
      await despesas
          .doc(auth.currentUser!.uid.toString())
          .collection("1/2023")
          .doc(item.id)
          .set(item.toJson())
          .catchError((error) => throw CustomException(
              "ocorreu um erro ao atualizar tente novamente"));
    }
  }

  excluir(Despesa item) async {
    if (auth.currentUser != null) {
      await despesas
          .doc(auth.currentUser!.uid.toString())
          .collection("1/2023")
          .doc(item.id)
          .delete()
          .catchError((error) => throw CustomException(
              "ocorreu um erro ao excluir tente novamente"));
    }
  }
}
