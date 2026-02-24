class Categoria {
  final String id;
  final String descricao;
  final int color;
  final int icon;
  final String fontFamily;

  Categoria({
    required this.id,
    required this.descricao,
    required this.color,
    required this.icon,
    required this.fontFamily,
  });

  bool isValid() {
    return descricao.isNotEmpty && 
           descricao.length >= 3 && 
           color > 0;
  }

  // Factory para criar categoria vazia/nova
  factory Categoria.empty() {
    return Categoria(
      id: '',
      descricao: '',
      color: 0,
      icon: 0,
      fontFamily: 'MaterialIcons',
    );
  }

  // CopyWith para criar cópias modificadas
  Categoria copyWith({
    String? id,
    String? descricao,
    int? color,
    int? icon,
    String? fontFamily,
  }) {
    return Categoria(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}