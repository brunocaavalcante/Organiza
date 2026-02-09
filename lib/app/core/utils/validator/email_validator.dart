String? Function(String?)? validarEmail() {
  return (((value) {
    if (value == "") {
      if (value == null || value.isEmpty) return "Campo obrigatório";
      return null;
    }

    final RegExp regex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$');

    bool valido = regex.hasMatch(value ?? "");
    if (!valido) return "E-mail inválido";
    return null;
  }));
}