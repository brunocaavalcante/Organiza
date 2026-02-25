import 'preferencia_usuario.dart';

class Usuario {
  final String id;
  final String authId;
  final String name;
  final String email;
  final String telefone;
  final DateTime? dataNascimento;
  final String photoUrl;
  final String photoRef;
  final PreferenciaUsuario preferencias;

  Usuario({
    this.id = '',
    this.authId = '',
    this.name = '',
    this.email = '',
    this.telefone = '',
    this.dataNascimento,
    this.photoUrl = '',
    this.photoRef = '',
    PreferenciaUsuario? preferencias,
  }) : preferencias = preferencias ?? PreferenciaUsuario.empty();

  bool isValid() {
    return name.isNotEmpty &&
        email.isNotEmpty &&
        isEmailValid() &&
        telefone.isNotEmpty;
  }

  bool isEmailValid() {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool hasPhoto() {
    return photoUrl.isNotEmpty;
  }

  int getAge() {
    if (dataNascimento == null) return 0;
    final now = DateTime.now();
    int age = now.year - dataNascimento!.year;
    if (now.month < dataNascimento!.month ||
        (now.month == dataNascimento!.month && now.day < dataNascimento!.day)) {
      age--;
    }
    return age;
  }

  Usuario copyWith({
    String? id,
    String? authId,
    String? name,
    String? email,
    String? telefone,
    DateTime? dataNascimento,
    String? photoUrl,
    String? photoRef,
    PreferenciaUsuario? preferencias,
  }) {
    return Usuario(
      id: id ?? this.id,
      authId: authId ?? this.authId,
      name: name ?? this.name,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      photoUrl: photoUrl ?? this.photoUrl,
      photoRef: photoRef ?? this.photoRef,
      preferencias: preferencias ?? this.preferencias,
    );
  }

  factory Usuario.empty() {
    return Usuario();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Usuario &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          authId == other.authId &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ authId.hashCode ^ email.hashCode;
}