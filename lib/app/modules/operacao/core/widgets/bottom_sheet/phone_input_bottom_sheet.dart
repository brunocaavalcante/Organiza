import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/core/models/enums.dart';
import 'package:organiza2/app/core/utils/validator/email_validator.dart';
import 'package:organiza2/app/modules/operacao/controller/operacao_shared_controller.dart';
import 'package:organiza2/app/modules/operacao/core/models/operacao.dart';
import 'package:organiza2/app/modules/operacao/core/models/operacao_shared.dart';
import 'package:organiza2/app/modules/usuario/core/services/usuario_service.dart';
import 'package:organiza2/app/core/widgets/widget_ultil.dart';

class BottomSheetUtil {
  static UserService userService = Modular.get<UserService>();
  static final controller = Modular.get<OperacaoSharedController>();

  static void showPhoneInputBottomSheet(BuildContext context, Operacao op) {
    TextEditingController emailController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Digite o email do usuário',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  WidgetUltil.returnField(
                      "E-mail: ",
                      emailController,
                      TextInputType.emailAddress,
                      null,
                      "",
                      false,
                      validarEmail()),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetUltil.returnButton(
                        "Cancelar",
                        Icons.close,
                        () => Navigator.pop(context),
                        Theme.of(context).colorScheme.error,
                        Theme.of(context).colorScheme.onError,
                      ),
                      WidgetUltil.returnButton(
                          "Compartilhar", Icons.mobile_screen_share_rounded,
                          () async {
                        await controller.salvarOperacaoCompartilhada(
                            op, emailController.text, context);
                      }, Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.surface),
                    ],
                  )
                ]));
      },
    );
  }

  static void showRecusaInputBottomSheet(
      BuildContext context, OperacaoShared op) {
    TextEditingController justificativaController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Justificativa recusa:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  WidgetUltil.returnField(
                    "Justificativa: ",
                    justificativaController,
                    TextInputType.text,
                    null,
                    "",
                    false,
                  ),
                  const SizedBox(height: 16),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetUltil.returnButton(
                          "Cancelar",
                          Icons.close,
                          () => Navigator.pop(context),
                          Theme.of(context).colorScheme.error,
                          Theme.of(context).colorScheme.onError,
                        ),
                        WidgetUltil.returnButton(
                          "Confirmar",
                          Icons.mobile_screen_share_rounded,
                          () async {
                            if (justificativaController.text.isNotEmpty) {
                              op.status = Status.Recusada.index;
                              op.justificativa = justificativaController.text;
                              await controller.editarOperacaoCompartilhada(
                                  op, context);
                              Navigator.pop(context);
                            }
                          },
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.surface,
                        ),
                      ])
                ]));
      },
    );
  }
}
