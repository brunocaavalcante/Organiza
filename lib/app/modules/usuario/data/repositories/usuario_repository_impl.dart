import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/models/custom_exception.dart';
import '../../domain/entities/preferencia_usuario.dart';
import '../../domain/entities/usuario.dart' as domain;
import '../../domain/repositories/i_usuario_repository.dart';
import '../models/preferencia_usuario_model.dart';
import '../models/usuario_model.dart';

class UsuarioRepositoryImpl implements IUsuarioRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  UsuarioRepositoryImpl(this._auth, this._firestore);

  CollectionReference get _usersCollection => _firestore.collection('users');

  @override
  Stream<String?> get authStateChanges {
    return _auth.authStateChanges().map((user) => user?.uid);
  }

  @override
  Future<void> register(domain.Usuario usuario, String senha) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: senha,
      );

      final User? firebaseUser = result.user;
      
      if (firebaseUser == null) {
        throw CustomException('Erro ao criar usuário');
      }

      // Atualizar perfil do Firebase Auth
      await firebaseUser.updateDisplayName(usuario.name);
      if (usuario.photoUrl.isNotEmpty) {
        await firebaseUser.updatePhotoURL(usuario.photoUrl);
      }

      // Criar modelo com authId do Firebase
      final usuarioComAuth = usuario.copyWith(authId: firebaseUser.uid);
      final model = UsuarioModel.fromEntity(usuarioComAuth);

      // Salvar no Firestore usando authId como document ID
      await _usersCollection.doc(firebaseUser.uid).set(model.toJson());
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw CustomException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException('Este email já está cadastrado');
      } else if (e.code == 'invalid-email') {
        throw CustomException('Email inválido!');
      } else if (e.code == 'network-request-failed') {
        throw CustomException('Erro de conexão. Verifique sua internet e tente novamente.');
      } else {
        throw CustomException('Erro ao cadastrar: ${e.message}');
      }
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw CustomException('Servidor indisponível. Tente novamente mais tarde.');
      }
      throw CustomException('Erro de rede: Verifique sua conexão e tente novamente.');
    } catch (e) {
      throw CustomException('Erro ao cadastrar usuário: ${e.toString()}');
    }
  }

  @override
  Future<void> login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw CustomException('Usuário não encontrado');
      } else if (e.code == 'wrong-password') {
        throw CustomException('Senha incorreta');
      } else if (e.code == 'invalid-email') {
        throw CustomException('Email inválido');
      } else if (e.code == 'user-disabled') {
        throw CustomException('Usuário desabilitado');
      } else if (e.code == 'network-request-failed') {
        throw CustomException('Sem conexão com a internet. Verifique sua rede.');
      } else {
        throw CustomException('Erro ao fazer login: ${e.message}');
      }
    } catch (e) {
      throw CustomException('Erro ao fazer login: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw CustomException('Erro ao fazer logout: ${e.toString()}');
    }
  }

  @override
  Future<domain.Usuario?> getById(String id) async {
    try {
      final doc = await _usersCollection.doc(id).get();
      
      if (!doc.exists) {
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;
      final model = UsuarioModel.fromJson(data, doc.id);
      return model.toEntity();
      
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw CustomException('Servidor indisponível. Verifique sua conexão.');
      }
      throw CustomException('Erro de rede ao buscar usuário. Tente novamente.');
    } catch (e) {
      throw CustomException('Erro ao buscar usuário: ${e.toString()}');
    }
  }

  @override
  Future<domain.Usuario?> getByEmail(String email) async {
    try {
      final querySnapshot = await _usersCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;
      final model = UsuarioModel.fromJson(data, doc.id);
      return model.toEntity();
      
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw CustomException('Servidor indisponível. Verifique sua conexão.');
      }
      throw CustomException('Erro de rede ao buscar usuário. Tente novamente.');
    } catch (e) {
      throw CustomException('Erro ao buscar usuário por email: ${e.toString()}');
    }
  }

  @override
  Future<domain.Usuario?> getCurrentUser() async {
    try {
      final currentUser = _auth.currentUser;
      
      if (currentUser == null) {
        return null;
      }

      return await getById(currentUser.uid);
      
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw CustomException('Servidor indisponível. Verifique sua conexão.');
      }
      throw CustomException('Erro de rede. Verifique sua conexão e tente novamente.');
    } catch (e) {
      throw CustomException('Erro ao obter usuário atual: ${e.toString()}');
    }
  }

  @override
  Future<void> update(domain.Usuario usuario) async {
    try {
      final currentUser = _auth.currentUser;
      
      if (currentUser == null) {
        throw CustomException('Usuário não está logado');
      }

      // Atualizar perfil do Firebase Auth
      await currentUser.updateDisplayName(usuario.name);
      if (usuario.photoUrl.isNotEmpty) {
        await currentUser.updatePhotoURL(usuario.photoUrl);
      }

      // Atualizar documento no Firestore
      final model = UsuarioModel.fromEntity(usuario);
      await _usersCollection.doc(currentUser.uid).update(model.toJson());
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw CustomException('Sem conexão com a internet. Verifique sua rede.');
      }
      throw CustomException('Erro ao atualizar autenticação: ${e.message}');
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw CustomException('Servidor indisponível. Verifique sua conexão.');
      }
      throw CustomException('Erro de rede ao atualizar. Tente novamente.');
    } catch (e) {
      throw CustomException('Erro ao atualizar usuário: ${e.toString()}');
    }
  }

  @override
  Future<void> updatePreferences(
    String userId,
    PreferenciaUsuario preferencias,
  ) async {
    try {
      if (userId.isEmpty) {
        throw CustomException('ID do usuário inválido');
      }

      final model = PreferenciaUsuarioModel.fromEntity(preferencias);
      
      await _usersCollection.doc(userId).update({
        'preferencias': model.toJson(),
      });
      
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw CustomException('Servidor indisponível. Verifique sua conexão.');
      }
      throw CustomException('Erro de rede ao atualizar preferências. Tente novamente.');
    } catch (e) {
      throw CustomException('Erro ao atualizar preferências: ${e.toString()}');
    }
  }
}