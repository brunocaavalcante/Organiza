class Categoria {
  String id = "";
  int color = 0;
  String descricao = "";
  String fontFamily = "";
  int icon = 0;

  Map<String, Object?> toJson() {
    return {
      'descricao': descricao,
      'id': id,
      'fontFamily': fontFamily,
      'color': color,
      'icon': icon
    };
  }

  Categoria toEntity(Map<String, dynamic> map) {
    descricao = map['descricao'];
    id = map['id'];
    icon = map['icon'];
    fontFamily = map['fontFamily'];
    color = map['color'];
    return this;
  }
}
