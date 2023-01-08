import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/custom_exception.dart';
import '../models/operacao.dart';

class DespesaService extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference despesas =
      FirebaseFirestore.instance.collection('despesas');

  salvar(Operacao item) async {
    if (auth.currentUser != null) {
      await despesas
          .doc(auth.currentUser!.uid.toString())
          .collection(
              "${item.dataReferencia!.month}${item.dataReferencia!.year}")
          .add(item.toJson())
          .catchError((error) => throw CustomException(
              "ocorreu um erro ao cadastrar tente novamente"));
    }
  }

  salvarComParcelas(Operacao operacao) async {
    DateTime data = operacao.dataReferencia ?? DateTime.now();
    for (int i = 1; i <= operacao.totalParcelas; i++) {
      operacao.parcelasPagas = i;
      await salvar(operacao);
      data = DateTime(data.year, data.month + 1, data.day);
      operacao.dataReferencia = data;
    }
  }

  atualizar(Operacao item) async {
    if (auth.currentUser != null) {
      await despesas
          .doc(auth.currentUser!.uid.toString())
          .collection(
              "${item.dataReferencia!.month}${item.dataReferencia!.year}")
          .doc(item.id)
          .set(item.toJson())
          .catchError((error) => throw CustomException(
              "ocorreu um erro ao atualizar tente novamente"));
    }
  }

  excluir(Operacao item) async {
    if (auth.currentUser != null) {
      await despesas
          .doc(auth.currentUser!.uid.toString())
          .collection(
              "${item.dataReferencia!.month}${item.dataReferencia!.year}")
          .doc(item.id)
          .delete()
          .catchError((error) => throw CustomException(
              "ocorreu um erro ao excluir tente novamente"));
    }
  }
}
