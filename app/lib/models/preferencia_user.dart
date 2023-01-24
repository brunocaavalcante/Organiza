import 'package:flutter/material.dart';

class PreferenciaUser {
  int? colorTheme;
  bool? darkMode;
  String id = "";

  Map<String, Object?> toJson() {
    return {'colorTheme': colorTheme, 'darkMode': darkMode};
  }

  PreferenciaUser toEntity(Map<String, dynamic> map) {
    id = map['id'] ?? "";
    colorTheme = map['colorTheme'] ?? 0;
    darkMode = map['darkMode'] ?? false;
    return this;
  }
}
