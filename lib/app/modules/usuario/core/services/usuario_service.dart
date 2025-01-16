import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:organiza2/app/modules/usuario/core/models/preferencia_user.dart';
import 'package:organiza2/app/modules/usuario/core/models/usuario.dart';
import '../../../../core/models/custom_exception.dart';

class UserService {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  var usuario = Rxn<User>();
  var isLoading = true.obs;

  UserService() {
    _authChek();
  }

  _authChek() {
    auth.authStateChanges().listen((User? user) {
      usuario.value = (user == null) ? null : user;
      isLoading.value = false;
    });
  }

  _getUser() {
    usuario.value = auth.currentUser;
  }

  Future<DocumentSnapshot<Object?>> obterUsuarioPorId(String? id) async {
    return users.doc(id).get();
  }

  Future<Usuario?> obterUsuarioPorEmail(String? email) async {
    try {
      QuerySnapshot querySnapshot =
          await users.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        var element = querySnapshot.docs.first;
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;

        var user = Usuario().toEntity(data);
        user.id = element.id;
        return user;
      }
      return null;
    } catch (e) {
      print('Erro ao obter usuário por telefone: $e');
      return null;
    }
  }

  registrar(Usuario usuario) async {
    try {
      var result = await auth.createUserWithEmailAndPassword(
          email: usuario.email!, password: usuario.senha!);

      User? user = result.user;
      user?.updateDisplayName(usuario.name);
      user?.updatePhotoURL(usuario.photo);
      usuario.authId = user?.uid;

      if (auth.currentUser != null) {
        await users.doc(usuario.authId).set(usuario.toJson()).catchError(
            (error) => throw CustomException(
                "ocorreu um erro ao cadastrar tente novamente"));
      }
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw CustomException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException('Este email já está cadastrado');
      } else if (e.code == 'unknown') {
        throw CustomException('Senha inválida');
      } else if (e.code == "invalid-email") {
        throw CustomException('Email inválido!');
      } else {
        throw CustomException('Erro ao cadastrar, tente novamente!');
      }
    }
  }

  atualizar(Usuario usuario) async {
    try {
      if (usuario.senha != usuario.confirmSenha) {
        throw CustomException('As senhas são diferentes!');
      }
      var user = auth.currentUser;
      user?.updateDisplayName(usuario.name);
      user?.updatePhotoURL(usuario.photo);
      usuario.id = user!.uid;
      if (auth.currentUser != null) {
        await users.doc(usuario.id).update(usuario.toJson()).catchError(
            (error) => throw CustomException(
                "ocorreu um erro ao cadastrar tente novamente"));
      }
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw CustomException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException('Este email já está cadastrado');
      } else if (e.code == 'unknown') {
        throw CustomException('Senha inválida');
      } else if (e.code == "invalid-email") {
        throw CustomException('Email inválido!');
      } else {
        throw CustomException('Erro ao cadastrar, tente novamente!');
      }
    }
  }

  login(String email, String senha) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw CustomException('Email não encontrado. Cadastre-se.');
      } else if (e.code == 'wrong-password') {
        throw CustomException('Senha incorreta. Tente novamente');
      } else if (e.code == 'invalid-email') {
        throw CustomException('E-mail no formato inválido');
      }
    }
  }

  logout() async {
    await auth.signOut();
    _getUser();
  }

  atualizarPreferencia(PreferenciaUser item) async {
    if (auth.currentUser != null) {
      await users
          .doc(auth.currentUser!.uid.toString())
          .update({'preferencias': item.toJson()}).catchError((error) =>
              throw CustomException(
                  "ocorreu um erro ao atualizar tente novamente"));
    }
  }

  Future<Usuario?> obterUsuario() async {
    if (auth.currentUser != null) {
      var item = await users.doc(auth.currentUser!.uid.toString()).get();

      if (item!.exists) {
        Map<String, dynamic> data = item.data()! as Map<String, dynamic>;
        var user = Usuario().toEntity(data);
        user.id = item.id;
        return user;
      }
    }
    return null;
  }
}
