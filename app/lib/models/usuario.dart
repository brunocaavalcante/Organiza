import 'package:app/models/preferencia_user.dart';

class Usuario {
  var name;
  var email;
  var senha;
  var confirmSenha;
  var telefone;
  var authId;
  var dataNascimento;
  var id;
  bool? check = false;
  String photo = "";
  String refPhoto = "";
  PreferenciaUser preferencias = PreferenciaUser();

  Map<String, Object?> toJson() {
    return {
      'nome': name,
      'email': email,
      'telefone': telefone,
      'id': id,
      'dataNascimento': dataNascimento,
      'photo': photo,
      'refPhoto': refPhoto,
      'preferencias': preferencias.toJson()
    };
  }

  Usuario toEntity(Map<String, dynamic> map) {
    id = map['id'] ?? "";
    name = map['nome'] ?? "";
    email = map['email'] ?? "";
    telefone = map['telefone'] ?? "";
    photo = map['photo'] ?? "";
    refPhoto = map['refPhoto'] ?? "";
    preferencias = preferencias.toEntity(map['preferencias']);
    if (map['dataNascimento'] != null) {
      dataNascimento = (map['dataNascimento']).toDate();
    }

    return this;
  }
}
