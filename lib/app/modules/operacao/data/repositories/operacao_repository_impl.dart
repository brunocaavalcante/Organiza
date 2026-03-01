import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:organiza2/app/core/models/custom_exception.dart';
import 'package:organiza2/app/modules/operacao/data/models/operacao_model.dart';
import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_repository.dart';

class OperacaoRepositoryImpl implements OperacaoRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  OperacaoRepositoryImpl(this._auth, this._firestore);

  CollectionReference get _operacaoCollection =>
      _firestore.collection('operacoes');

  String? get _userId => _auth.currentUser?.uid;

  @override
  Future<void> salvar(Operacao operacao) async {
    if (_userId == null) {
      throw CustomException("Usuário não autenticado");
    }

    final data = operacao.dataReferencia ?? DateTime.now();
    final collection = "${data.month}${data.year}";

    await _operacaoCollection
        .doc(_userId)
        .collection(collection)
        .add(OperacaoModel.toFirestore(operacao))
        .catchError((error) => throw CustomException(
            "Ocorreu um erro ao cadastrar, tente novamente"));
  }

  @override
  Future<void> atualizar(Operacao operacao) async {
    if (_userId == null) {
      throw CustomException("Usuário não autenticado");
    }

    if (operacao.id == null) {
      throw CustomException("ID da operação não informado");
    }

    final data = operacao.dataReferencia ?? DateTime.now();
    final collection = "${data.month}${data.year}";

    await _operacaoCollection
        .doc(_userId)
        .collection(collection)
        .doc(operacao.id)
        .update(OperacaoModel.toFirestore(operacao))
        .catchError((error) => throw CustomException(
            "Ocorreu um erro ao atualizar, tente novamente", error));
  }

  @override
  Future<void> excluir(Operacao operacao) async {
    if (_userId == null) {
      throw CustomException("Usuário não autenticado");
    }

    if (operacao.id == null) {
      throw CustomException("ID da operação não informado");
    }

    final data = operacao.dataReferencia ?? DateTime.now();
    final collection = "${data.month}${data.year}";

    await _operacaoCollection
        .doc(_userId)
        .collection(collection)
        .doc(operacao.id)
        .delete()
        .catchError((error) => throw CustomException(
            "Ocorreu um erro ao excluir, tente novamente"));
  }

  @override
  Future<List<Operacao>> buscarPorMesAno(int mes, int ano) async {
    List<Operacao> list = [];

    if (_userId == null) return list;

    final snapshot = await _operacaoCollection
        .doc(_userId)
        .collection("$mes$ano")
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final operacao = OperacaoModel.fromFirestore(data, doc.id);
      list.add(operacao);
    }

    return list;
  }

  @override
  Future<List<Operacao>> buscarTodasDoAno() async {
    List<Operacao> list = [];
    int mes = 1;

    if (_userId == null) return list;

    while (mes <= 12) {
      final snapshot = await _operacaoCollection
          .doc(_userId)
          .collection("$mes${DateTime.now().year}")
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final operacao = OperacaoModel.fromFirestore(data, doc.id);
        list.add(operacao);
      }

      mes++;
    }

    return list;
  }

  @override
  Future<List<Operacao>> buscarPorData(Operacao operacao) async {
    List<Operacao> lista = [];
    int mesCad = 1;
    final anoCad = operacao.dataCadastro?.year ?? DateTime.now().year;

    if (_userId == null) return lista;

    while (mesCad <= 12) {
      final snapshot = await _operacaoCollection
          .doc(_userId)
          .collection("$mesCad$anoCad")
          .where('descricao', isEqualTo: operacao.descricao)
          .where('valor', isEqualTo: operacao.valor)
          .where('titulo', isEqualTo: operacao.titulo)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final op = OperacaoModel.fromFirestore(data, doc.id);
        lista.add(op);
      }

      mesCad++;
    }

    return lista;
  }
}
