class PreferenciaUsuario {
  final int colorTheme;
  final bool darkMode;

  PreferenciaUsuario({
    this.colorTheme = 0xFF6200EE,
    this.darkMode = false,
  });

  bool isValidColor() {
    return colorTheme != 0;
  }

  PreferenciaUsuario copyWith({
    int? colorTheme,
    bool? darkMode,
  }) {
    return PreferenciaUsuario(
      colorTheme: colorTheme ?? this.colorTheme,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  factory PreferenciaUsuario.empty() {
    return PreferenciaUsuario();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreferenciaUsuario &&
          runtimeType == other.runtimeType &&
          colorTheme == other.colorTheme &&
          darkMode == other.darkMode;

  @override
  int get hashCode => colorTheme.hashCode ^ darkMode.hashCode;
}
