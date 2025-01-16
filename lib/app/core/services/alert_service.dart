import 'package:flutter/material.dart';
import 'package:organiza2/app/modules/operacao/core/models/operacao.dart';

class AlertService {
  static int opSelecionada = 0;

  /// Exibe um aviso em formato de Bottom Sheet
  static alertAviso(BuildContext context, String title, String subtitle) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding:
              const EdgeInsets.only(top: 30, bottom: 10, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.orange, size: 60),
              const SizedBox(height: 16),
              Text(subtitle,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              const SizedBox(height: 16)
            ],
          ),
        );
      },
    );
  }

  static alertErro(BuildContext context, String text) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding:
              const EdgeInsets.only(top: 30, bottom: 10, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Erro",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Icon(Icons.error_outline_rounded,
                  color: Colors.red, size: 60),
              const SizedBox(height: 16),
              Text(text,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              const SizedBox(height: 16)
            ],
          ),
        );
      },
    );
  }

  static alertConfirm(BuildContext context, String title, String subtitle,
      Function()? onPressedConfirm, Function()? onPressedCancelar) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
            width: MediaQuery.of(context).size.width, // 100% da largura da tela
            child: Container(
                padding: const EdgeInsets.only(
                    top: 30, bottom: 10, left: 20, right: 20),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(subtitle),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed: onPressedCancelar ??
                                () => Navigator.pop(context),
                            icon: const Icon(Icons.close, size: 16),
                            label: const Text("NÃO",
                                style: TextStyle(fontSize: 12)),
                          ),
                          ElevatedButton.icon(
                            onPressed: onPressedConfirm,
                            icon: const Icon(Icons.check, size: 16),
                            label: const Text("SIM",
                                style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      )
                    ])));
      },
    );
  }

  static alertConfirmAnexar(BuildContext context, String title, String subtitle,
      Function()? onPressedAnexar, Function()? onPressedCancelar) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding:
              const EdgeInsets.only(top: 30, bottom: 10, left: 20, right: 20),
          child: Wrap(
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Text(subtitle),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed:
                        onPressedCancelar ?? () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text("Não Anexar",
                        style: TextStyle(fontSize: 12)),
                  ),
                  ElevatedButton.icon(
                    onPressed: onPressedAnexar,
                    icon: const Icon(Icons.file_present, size: 16),
                    label: const Text("Anexar", style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Exibe um alerta com opções de rádio em formato de Bottom Sheet
  static alertRadios(BuildContext context, String title, String desc,
      List<String> options, Operacao op, Function()? onPressedOk) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Text(desc),
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    children: [
                      for (var i = 0; i < options.length; i++)
                        ListTile(
                          leading: Radio(
                            value: i,
                            groupValue: opSelecionada,
                            onChanged: (int? value) {
                              setState(() {
                                opSelecionada = value ?? 0;
                              });
                            },
                          ),
                          title: Text(options[i]),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text("Cancelar"),
                  ),
                  ElevatedButton.icon(
                    onPressed: onPressedOk,
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text("OK"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Exibe uma lista de seleção em formato de Bottom Sheet
  static alertSelect(
      BuildContext context, String title, String? desc, List<String> options,
      [Function()? onPressedOk]) {
    int indexItemSelected = 0;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              if (desc != null) ...[
                const SizedBox(height: 8),
                Text(desc),
              ],
              const SizedBox(height: 8),
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: 300.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        return options[index] == ""
                            ? Container()
                            : ListTile(
                                onTap: () {
                                  indexItemSelected = index;
                                  setState(() {});
                                },
                                title: Text(
                                  options[index],
                                  style: TextStyle(
                                    color: index == indexItemSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : null,
                                  ),
                                ),
                              );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text("Cancelar"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context, indexItemSelected),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text("OK"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static void alertaSucess(BuildContext context, [String text = ""]) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding:
              const EdgeInsets.only(top: 30, bottom: 10, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Operação realizada com sucesso!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 16),
              Text(text,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]))
            ],
          ),
        );
      },
    );
  }
}
