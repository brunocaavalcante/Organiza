import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:organiza2/app/core/models/custom_exception.dart';
import 'package:organiza2/app/core/models/enums.dart';
import 'package:organiza2/app/modules/operacao/data/models/operacao_model.dart';
import 'package:organiza2/app/modules/operacao/data/models/operacao_shared_model.dart';
import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';
import 'package:organiza2/app/modules/operacao/domain/entities/operacao_shared.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_shared_repository.dart';

class OperacaoSharedRepositoryImpl implements OperacaoSharedRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  OperacaoSharedRepositoryImpl(this._auth, this._firestore);

  CollectionReference get _operacaoSharedCollection =>
      _firestore.collection('operacoes-compartilhadas');

  CollectionReference get _operacaoCollection =>
      _firestore.collection('operacoes');

  String? get _userId => _auth.currentUser?.uid;

  @override
  Future<void> salvar(OperacaoShared operacaoShared) async {
    if (_userId == null) {
      throw CustomException("Usuário não autenticado");
    }

    await _operacaoSharedCollection
        .add(OperacaoSharedModel.toFirestore(operacaoShared))
        .catchError((error) => throw CustomException(
            "Ocorreu um erro ao cadastrar, tente novamente"));
  }

  @override
  Future<void> editar(OperacaoShared operacaoShared) async {
    if (_userId == null) {
      throw CustomException("Usuário não autenticado");
    }    

    await _operacaoSharedCollection
        .doc(operacaoShared.id)
        .update(OperacaoSharedModel.toFirestore(operacaoShared))
        .catchError((error) => throw CustomException(
            "Ocorreu um erro ao editar, tente novamente"));
  }

  @override
  Future<void> excluir(OperacaoShared operacaoShared) async {
    if (_userId == null) {
      throw CustomException("Usuário não autenticado");
    }   

    await _operacaoSharedCollection
        .doc(operacaoShared.id)
        .delete()
        .catchError((error) => throw CustomException(
            "Ocorreu um erro ao excluir, tente novamente"));
  }

  @override
  Stream<List<OperacaoShared>> buscarOperacoesCompartilhadas() {
    if (_userId == null) {
      return Stream.value([]);
    }

    return _operacaoSharedCollection
        .where('status', isEqualTo: Status.PendenteAprovacao.index)
        .where('idProprietario', isEqualTo: _userId)
        .snapshots()
        .asyncMap((proprietarioSnapshot) async {
      List<OperacaoShared> list = [];

      // Operações onde o usuário é proprietário
      for (var doc in proprietarioSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final operacao = OperacaoSharedModel.fromFirestore(data, doc.id);
        list.add(operacao);
      }

      // Operações onde o usuário é destinatário
      final destinatarioSnapshot = await _operacaoSharedCollection
          .where('status', isEqualTo: Status.PendenteAprovacao.index)
          .where('idDestinatario', isEqualTo: _userId)
          .get();

      for (var doc in destinatarioSnapshot.docs) {
        if (!list.any((op) => op.id == doc.id)) {
          final data = doc.data() as Map<String, dynamic>;
          final operacao = OperacaoSharedModel.fromFirestore(data, doc.id);
          list.add(operacao);
        }
      }

      return list;
    });
  }

  @override
  Stream<List<OperacaoShared>> buscarHistoricoOperacoesCompartilhadas() {
    if (_userId == null) {
      return Stream.value([]);
    }

    return _operacaoSharedCollection
        .where('status', isNotEqualTo: Status.PendenteAprovacao.index)
        .where('idProprietario', isEqualTo: _userId)
        .snapshots()
        .asyncMap((proprietarioSnapshot) async {
      List<OperacaoShared> list = [];

      // Operações onde o usuário é proprietário
      for (var doc in proprietarioSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final operacao = OperacaoSharedModel.fromFirestore(data, doc.id);
        list.add(operacao);
      }

      // Operações onde o usuário é destinatário
      final destinatarioSnapshot = await _operacaoSharedCollection
          .where('status', isNotEqualTo: Status.PendenteAprovacao.index)
          .where('idDestinatario', isEqualTo: _userId)
          .get();

      for (var doc in destinatarioSnapshot.docs) {
        if (!list.any((op) => op.id == doc.id)) {
          final data = doc.data() as Map<String, dynamic>;
          final operacao = OperacaoSharedModel.fromFirestore(data, doc.id);
          list.add(operacao);
        }
      }

      return list;
    });
  }

  @override
  Future<Operacao?> buscarOperacaoPorId(OperacaoShared operacaoShared) async {
    final dataRef = operacaoShared.dataReferencia;
    if (dataRef == null) return null;

    final documento = await _operacaoCollection
        .doc(operacaoShared.idProprietario)
        .collection("${dataRef.month}${dataRef.year}")
        .doc(operacaoShared.idOperacao)
        .get();

    if (documento.exists) {
      final data = documento.data()!;
      return OperacaoModel.fromFirestore(data, documento.id);
    }

    return null;
  }
}
