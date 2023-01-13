class Categoria {
  int id = 0;
  int color = 0;
  String descricao = "";
  String fontFamily = "";

  Map<String, Object?> toJson() {
    return {
      'descricao': descricao,
      'id': id,
      'fontFamily': fontFamily,
      'color': color
    };
  }

  Categoria toEntity(Map<String, dynamic> map) {
    descricao = map['descricao'];
    id = map['id'];
    fontFamily = map['fontFamily'];
    color = map['color'];
    return this;
  }
}
