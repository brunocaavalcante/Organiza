import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/custom_exception.dart';
import '../models/filter_query.dart';
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
    DateTime data = operacao.dataReferencia ??
        DateTime(DateTime.now().year, DateTime.now().month, 1);
    for (int i = 1; i <= operacao.totalParcelas; i++) {
      operacao.parcelaAtual = i;
      await salvar(operacao);
      data = DateTime(data.year, data.month + 1, data.day);
      operacao.dataReferencia = data;
    }
  }

  salvarAnoTodo(Operacao operacao) async {
    DateTime data = operacao.dataReferencia ??
        DateTime(DateTime.now().year, DateTime.now().month, 1);

    while (data.year == DateTime.now().year) {
      await salvar(operacao);
      data = DateTime(data.year, data.month + 1, 1);
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
          .update(item.toJson())
          .catchError((error) => {
                throw CustomException(
                    "ocorreu um erro ao atualizar tente novamente", error)
              });
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

  Future<List<Operacao>> buscarOperacoesPorMesAno(int mes, int ano) async {
    List<Operacao> list = [];

    if (auth.currentUser != null) {
      var teste = await operacao
          .doc(auth.currentUser!.uid.toString())
          .collection("${mes}${ano}")
          .get();

      if (teste.size > 0) {
        for (var element in teste.docs) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;

          var operacao = Operacao().toEntity(data);
          operacao.id = element.id;
          list.add(operacao);
        }
      }
    }
    return list;
  }

  Future<List<Operacao>> buscarTodasOperacoesAno() async {
    List<Operacao> list = [];
    int mes = 1;

    if (auth.currentUser != null) {
      while (mes != 12) {
        await operacao
            .doc(auth.currentUser!.uid.toString())
            .collection("${mes}${DateTime.now().year}")
            .get()
            .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.size > 0) {
            for (var element in querySnapshot.docs) {
              Map<String, dynamic> data =
                  element.data()! as Map<String, dynamic>;

              var operacao = Operacao().toEntity(data);
              operacao.id = element.id;
              list.add(operacao);
            }
          }
          mes += 1;
        });
      }
    }
    return list;
  }

  Future<List<Operacao>> buscarTodasOperacoesPorOperacao(Operacao op) async {
    List<Operacao> list = [];
    bool exiteItem = true;

    if (auth.currentUser != null) {
      op = await buscarPrimeiraOperacao(op);
      DateTime? dt = op.dataReferencia;

      while (exiteItem) {
        await operacao
            .doc(auth.currentUser!.uid.toString())
            .collection("${dt!.month}${dt!.year}")
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
              dt = DateTime(dt!.year, dt!.month + 1, 1);
              list.add(operacao);
            }
          } else {
            exiteItem = false;
          }
        });
      }
    }
    return list;
  }

  Future<Operacao> buscarPrimeiraOperacao(Operacao op) async {
    DateTime data = DateTime.now();
    if (auth.currentUser != null) {
      if (op.parcelaAtual > 1) {
        while (op.parcelaAtual > 1) {
          data = DateTime(
              op.dataReferencia!.year, op.dataReferencia!.month - 1, 1);
          await operacao
              .doc(auth.currentUser!.uid.toString())
              .collection("${data.month}${data.year}")
              .where('descricao', isEqualTo: op.descricao)
              .where('valor', isEqualTo: op.valor)
              .get()
              .then((QuerySnapshot querySnapshot) {
            if (querySnapshot.size > 0) {
              for (var element in querySnapshot.docs) {
                Map<String, dynamic> data =
                    element.data()! as Map<String, dynamic>;
                op = Operacao().toEntity(data);
                op.id = element.id;
              }
            }
          });
        }
      }
    }
    return op;
  }

  Future<Operacao?> buscarOperacaoPorDescricao(Operacao op) async {
    Operacao? retorno = op;
    if (auth.currentUser != null) {
      await operacao
          .doc(auth.currentUser!.uid.toString())
          .collection("${op.dataReferencia!.month}${op.dataReferencia!.year}")
          .where('descricao', isEqualTo: op.descricao)
          .where('valor', isEqualTo: op.valor)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          for (var element in querySnapshot.docs) {
            Map<String, dynamic> data = element.data()! as Map<String, dynamic>;
            op = Operacao().toEntity(data);
            op.id = element.id;
          }
        } else {
          retorno = null;
        }
      });
    }
    return retorno;
  }
}
