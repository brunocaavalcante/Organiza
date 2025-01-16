import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organiza2/app/modules/usuario/core/models/preferencia_user.dart';

class Usuario {
  String? name;
  String? email;
  String? senha;
  String? confirmSenha;
  String? telefone;
  String? authId;
  DateTime? dataNascimento;
  String? id;
  bool check = false;
  String photo = "";
  String refPhoto = "";
  PreferenciaUser preferencias = PreferenciaUser();

  Usuario({
    this.name,
    this.email,
    this.senha,
    this.confirmSenha,
    this.telefone,
    this.authId,
    this.dataNascimento,
    this.id,
    this.check = false,
    this.photo = "",
    this.refPhoto = "",
    PreferenciaUser? preferencias,
  }) : preferencias = preferencias ?? PreferenciaUser();

  /// Converte a instância de `Usuario` para um Map (JSON)
  Map<String, Object?> toJson() {
    return {
      'nome': name,
      'email': email,
      'telefone': telefone,
      'id': id,
      'dataNascimento': dataNascimento?.toIso8601String(),
      'photo': photo,
      'refPhoto': refPhoto,
      'preferencias': preferencias.toJson()
    };
  }

  /// Converte um Map (JSON) para uma instância de `Usuario`
  Usuario toEntity(Map<String, dynamic> map) {
    id = map['id'] ?? "";
    name = map['nome'] ?? "";
    email = map['email'] ?? "";
    telefone = map['telefone'] ?? "";
    photo = map['photo'] ?? "";
    refPhoto = map['refPhoto'] ?? "";
    preferencias = PreferenciaUser().toEntity(map['preferencias']);
    dataNascimento = map['dataNascimento'] != null
        ? (map['dataNascimento'] is Timestamp
            ? (map['dataNascimento'] as Timestamp).toDate()
            : DateTime.tryParse(map['dataNascimento']))
        : null;

    return this;
  }
}
