import '../../domain/entities/categoria.dart';

class CategoriaModel {
  final String id;
  final String descricao;
  final int color;
  final int icon;
  final String fontFamily;

  CategoriaModel({
    required this.id,
    required this.descricao,
    required this.color,
    required this.icon,
    required this.fontFamily,
  });

  // JSON → Model
  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      id: json['id'] ?? '',
      descricao: json['descricao'] ?? '',
      color: json['color'] ?? 0,
      icon: json['icon'] ?? 0,
      fontFamily: json['fontFamily'] ?? 'MaterialIcons',
    );
  }

  // Model → JSON (para salvar no Firebase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'color': color,
      'icon': icon,
      'fontFamily': fontFamily,
    };
  }

  // Model → Entity 
  Categoria toEntity() {
    return Categoria(
      id: id,
      descricao: descricao,
      color: color,
      icon: icon,
      fontFamily: fontFamily,
    );
  }

  // Entity → Model (para salvar)
  factory CategoriaModel.fromEntity(Categoria entity) {
    return CategoriaModel(
      id: entity.id,
      descricao: entity.descricao,
      color: entity.color,
      icon: entity.icon,
      fontFamily: entity.fontFamily,
    );
  }
}