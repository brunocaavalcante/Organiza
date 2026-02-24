import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/models/custom_exception.dart';
import '../../domain/entities/categoria.dart';
import '../../domain/repositories/i_categoria_repository.dart';
import '../models/categoria_model.dart';

class CategoriaRepositoryImpl implements ICategoriaRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CategoriaRepositoryImpl(this._firestore, this._auth);

  @override
  Future<void> save(Categoria categoria) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw CustomException('Usuário não autenticado');
      }

      final model = CategoriaModel.fromEntity(categoria);

      await _firestore
          .collection('categorias-user')
          .doc(currentUser.uid)
          .collection('categorias')
          .add(model.toJson());
    } catch (e) {
      throw CustomException('Erro ao salvar categoria: ${e.toString()}');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw CustomException('Usuário não autenticado');
      }

      if (id.isEmpty) {
        throw CustomException('ID inválido');
      }

      await _firestore
          .collection('categorias-user')
          .doc(currentUser.uid)
          .collection('categorias')
          .doc(id)
          .delete();
    } catch (e) {
      throw CustomException('Erro ao excluir categoria: ${e.toString()}');
    }
  }

  @override
  Future<List<Categoria>> getAll() async {
    try {
      final gerais = await getCategoriasGerais();
      final usuario = await getByUserId(_auth.currentUser?.uid ?? '');

      return [...gerais, ...usuario];
    } catch (e) {
      throw CustomException('Erro ao buscar categorias: ${e.toString()}');
    }
  }

  @override
  Future<List<Categoria>> getByUserId(String userId) async {
    try {
      if (userId.isEmpty) {
        return [];
      }

      final querySnapshot = await _firestore
          .collection('categorias-user')
          .doc(userId)
          .collection('categorias')
          .orderBy('descricao')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return CategoriaModel.fromJson(data).toEntity();
      }).toList();
    } catch (e) {
      throw CustomException('Erro ao buscar categorias do usuário: ${e.toString()}');
    }
  }

  @override
  Future<List<Categoria>> getCategoriasGerais() async {
    try {
      final querySnapshot = await _firestore
          .collection('categorias')
          .orderBy('descricao')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return CategoriaModel.fromJson(data).toEntity();
      }).toList();
    } catch (e) {
      throw CustomException('Erro ao buscar categorias gerais: ${e.toString()}');
    }
  }
}