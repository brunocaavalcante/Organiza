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

  Map<String, Object?> toJson() {
    return {
      'nome': name,
      'email': email,
      'telefone': telefone,
      'id': id,
      'dataNascimento': dataNascimento,
      'photo': photo,
      'refPhoto': refPhoto
    };
  }

  Usuario toEntity(Map<String, dynamic> map) {
    id = map['id'] ?? "";
    name = map['nome'] ?? "";
    email = map['email'] ?? "";
    telefone = map['telefone'] ?? "";
    photo = map['photo'] ?? "";
    refPhoto = map['refPhoto'] ?? "";
    if (map['dataNascimento'] != null) {
      dataNascimento = (map['dataNascimento']).toDate();
    }

    return this;
  }
}
