import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/custom_exception.dart';
import '../models/operacao.dart';

class OperacaoService extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference operacao =
      FirebaseFirestore.instance.collection('operacoes');

  salvar(Operacao item) async {
    if (auth.currentUser != null) {
      await operacao
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
      await operacao
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
      await operacao
          .doc(auth.currentUser!.uid.toString())
          .collection(
              "${item.dataReferencia!.month}${item.dataReferencia!.year}")
          .doc(item.id)
          .delete()
          .catchError((error) => throw CustomException(
              "ocorreu um erro ao excluir tente novamente"));
    }
  }

  Future<List<Operacao>> buscarTodasOperacoesPorOperacao(Operacao op) async {
    List<Operacao> list = [];
    bool exiteItem = true;

    if (auth.currentUser != null) {
      while (exiteItem) {
        await operacao
            .doc(auth.currentUser!.uid.toString())
            .collection("${op.dataReferencia!.month}${op.dataReferencia!.year}")
            .where('descricao', isEqualTo: op.descricao)
            .where('valor', isEqualTo: op.valor)
            .get()
            .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.size > 0) {
            for (var element in querySnapshot.docs) {
              Map<String, dynamic> data =
                  element.data()! as Map<String, dynamic>;

              var operacao = Operacao().toEntity(data);
              operacao.id = element.id;
              list.add(operacao);

              op.dataReferencia = DateTime(
                  op.dataReferencia!.year, op.dataReferencia!.month + 1, 1);
            }
          } else {
            exiteItem = false;
          }
        });
      }
    }
    return list;
  }
}
