import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/usuario.dart';
import 'preferencia_usuario_model.dart';

class UsuarioModel {
  final String id;
  final String authId;
  final String name;
  final String email;
  final String telefone;
  final DateTime? dataNascimento;
  final String photoUrl;
  final String photoRef;
  final PreferenciaUsuarioModel preferencias;

  UsuarioModel({
    required this.id,
    required this.authId,
    required this.name,
    required this.email,
    required this.telefone,
    this.dataNascimento,
    required this.photoUrl,
    required this.photoRef,
    required this.preferencias,
  });

  // Conversão de JSON
  factory UsuarioModel.fromJson(Map<String, dynamic> json, String docId) {
    DateTime? dataNasc;
    if (json['dataNascimento'] != null) {
      if (json['dataNascimento'] is Timestamp) {
        dataNasc = (json['dataNascimento'] as Timestamp).toDate();
      } else if (json['dataNascimento'] is String) {
        dataNasc = DateTime.tryParse(json['dataNascimento']);
      }
    }

    return UsuarioModel(
      id: docId,
      authId: json['authId'] as String? ?? '',
      name: json['nome'] as String? ?? '',
      email: json['email'] as String? ?? '',
      telefone: json['telefone'] as String? ?? '',
      dataNascimento: dataNasc,
      photoUrl: json['photo'] as String? ?? '',
      photoRef: json['refPhoto'] as String? ?? '',
      preferencias: json['preferencias'] != null
          ? PreferenciaUsuarioModel.fromJson(
              json['preferencias'] as Map<String, dynamic>)
          : PreferenciaUsuarioModel(
              colorTheme: 0xFF6200EE,
              darkMode: false,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authId': authId,
      'nome': name,
      'email': email,
      'telefone': telefone,
      'dataNascimento': dataNascimento?.toIso8601String(),
      'photo': photoUrl,
      'refPhoto': photoRef,
      'preferencias': preferencias.toJson(),
    };
  }

  // Conversão para entidade de domínio
  Usuario toEntity() {
    return Usuario(
      id: id,
      authId: authId,
      name: name,
      email: email,
      telefone: telefone,
      dataNascimento: dataNascimento,
      photoUrl: photoUrl,
      photoRef: photoRef,
      preferencias: preferencias.toEntity(),
    );
  }

  // Conversão de entidade de domínio
  factory UsuarioModel.fromEntity(Usuario entity) {
    return UsuarioModel(
      id: entity.id,
      authId: entity.authId,
      name: entity.name,
      email: entity.email,
      telefone: entity.telefone,
      dataNascimento: entity.dataNascimento,
      photoUrl: entity.photoUrl,
      photoRef: entity.photoRef,
      preferencias: PreferenciaUsuarioModel.fromEntity(entity.preferencias),
    );
  }
}