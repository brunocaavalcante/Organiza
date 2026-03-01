import 'package:flutter/material.dart';
import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';

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
              const EdgeInsets.only(top: 30, bottom: 100, left: 20, right: 20),
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

  static Future<bool> alertErro(BuildContext context, String mensagem, {String titulo = "Erro"}) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  color: Colors.red.shade600,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                mensagem,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Entendi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    return result ?? false;
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
                    top: 30, bottom: 100, left: 20, right: 20),
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

  static Future<bool> alertaSucesso(BuildContext context, String mensagem, {String titulo = "Sucesso"}) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green.shade600,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                mensagem,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Ok',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    return result ?? false;
  }
}
