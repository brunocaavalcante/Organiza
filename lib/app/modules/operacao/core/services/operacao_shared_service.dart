import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organiza2/app/core/models/custom_exception.dart';
import 'package:organiza2/app/core/models/enums.dart';
import 'package:organiza2/app/modules/operacao/core/models/operacao.dart';
import 'package:organiza2/app/modules/operacao/core/models/operacao_shared.dart';

class OperacaoSharedService extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference operacaoShared =
      FirebaseFirestore.instance.collection('operacoes-compartilhadas');

  CollectionReference operacao =
      FirebaseFirestore.instance.collection('operacoes');

  Stream<List<OperacaoShared>> buscarOperacoesCompartilhada() {
    String userId = auth.currentUser?.uid ?? '';

    return operacaoShared
        .where('status', isEqualTo: Status.PendenteAprovacao.index)
        .where('idProprietario', isEqualTo: userId)
        .snapshots()
        .asyncMap((proprietarioSnapshot) async {
      List<OperacaoShared> list = [];

      for (var element in proprietarioSnapshot.docs) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        var operacao = OperacaoShared().toEntity(data);
        operacao.id = element.id;
        list.add(operacao);
      }

      // Busca operações do destinatário e evita duplicados
      QuerySnapshot destinatarioSnapshot = await operacaoShared
          .where('status', isEqualTo: Status.PendenteAprovacao.index)
          .where('idDestinatario', isEqualTo: userId)
          .get();

      for (var element in destinatarioSnapshot.docs) {
        if (!list.any((op) => op.id == element.id)) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          var operacao = OperacaoShared().toEntity(data);
          operacao.id = element.id;
          list.add(operacao);
        }
      }

      return list;
    });
  }

  Stream<List<OperacaoShared>> buscarHistoricoOperacoesCompartilhada() {
    String userId = auth.currentUser?.uid ?? '';

    return operacaoShared
        .where('status', isNotEqualTo: Status.PendenteAprovacao.index)
        .where('idProprietario', isEqualTo: userId)
        .snapshots()
        .asyncMap((proprietarioSnapshot) async {
      List<OperacaoShared> list = [];

      for (var element in proprietarioSnapshot.docs) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        var operacao = OperacaoShared().toEntity(data);
        operacao.id = element.id;
        list.add(operacao);
      }

      // Busca operações do destinatário e evita duplicados
      QuerySnapshot destinatarioSnapshot = await operacaoShared
          .where('status', isNotEqualTo: Status.PendenteAprovacao.index)
          .where('idDestinatario', isEqualTo: userId)
          .get();

      for (var element in destinatarioSnapshot.docs) {
        if (!list.any((op) => op.id == element.id)) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          var operacao = OperacaoShared().toEntity(data);
          operacao.id = element.id;
          list.add(operacao);
        }
      }

      return list;
    });
  }

  salvar(OperacaoShared item) async {
    if (auth.currentUser != null) {
      await operacaoShared.add(item.toJson()).catchError((error) =>
          throw CustomException(
              "ocorreu um erro ao cadastrar tente novamente"));
    }
  }

  editar(OperacaoShared item) async {
    if (auth.currentUser != null) {
      await operacaoShared.doc(item.id).update(item.toJson()).catchError(
          (error) => throw CustomException(
              "ocorreu um erro ao editar tente novamente"));
    }
  }

  excluir(OperacaoShared item) {
    if (auth.currentUser != null) {
      operacaoShared.doc(item.id).delete().catchError((error) =>
          throw CustomException("ocorreu um erro ao excluir tente novamente"));
    }
  }

  Future<Operacao?> buscarOperacaoPorId(OperacaoShared op) async {
    Operacao? retorno;

    var documento = await operacao
        .doc(op.idProprietario)
        .collection("${op.dataReferencia!.month}${op.dataReferencia!.year}")
        .doc(op.idOperacao)
        .get();

    if (documento.exists) {
      Map<String, dynamic> data = documento.data()!;
      retorno = Operacao().toEntity(data);
      retorno.id = documento.id;
    }
    return retorno;
  }
}
