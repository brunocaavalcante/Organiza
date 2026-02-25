import '../../domain/entities/preferencia_usuario.dart';

class PreferenciaUsuarioModel {
  final int colorTheme;
  final bool darkMode;

  PreferenciaUsuarioModel({
    required this.colorTheme,
    required this.darkMode,
  });

  // Conversão de JSON
  factory PreferenciaUsuarioModel.fromJson(Map<String, dynamic> json) {
    return PreferenciaUsuarioModel(
      colorTheme: json['colorTheme'] as int? ?? 0xFF6200EE,
      darkMode: json['darkMode'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'colorTheme': colorTheme,
      'darkMode': darkMode,
    };
  }

  // Conversão para entidade de domínio
  PreferenciaUsuario toEntity() {
    return PreferenciaUsuario(
      colorTheme: colorTheme,
      darkMode: darkMode,
    );
  }

  // Conversão de entidade de domínio
  factory PreferenciaUsuarioModel.fromEntity(PreferenciaUsuario entity) {
    return PreferenciaUsuarioModel(
      colorTheme: entity.colorTheme,
      darkMode: entity.darkMode,
    );
  }
}