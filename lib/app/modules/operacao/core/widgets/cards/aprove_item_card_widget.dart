import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/core/models/enums.dart';
import 'package:organiza2/app/core/services/alert_service.dart';
import 'package:organiza2/app/core/utils/date_ultils.dart';
import 'package:organiza2/app/core/utils/masks.dart';
import 'package:organiza2/app/modules/operacao/controller/operacao_shared_controller.dart';
import 'package:organiza2/app/modules/operacao/core/models/operacao_shared.dart';
import 'package:organiza2/app/modules/usuario/core/services/usuario_service.dart';

class AproveItemCad extends StatelessWidget {
  final OperacaoShared op;
  final userService = Modular.get<UserService>();
  final controller = Modular.get<OperacaoSharedController>();
  AproveItemCad({super.key, required this.op});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7, right: 16, left: 16, bottom: 10),
      child: Container(
        padding: const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título e avatares
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Text(
                    op.titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      radius: 12,
                      backgroundImage: NetworkImage(op.imgProprietario),
                    ),
                    const SizedBox(width: 4),
                    CircleAvatar(
                      radius: 12,
                      backgroundColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      backgroundImage: NetworkImage(op.imgDestinatario),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Subtítulo
            Text(
              op.descricao,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 16),
            rowParcelas(context),
            Row(
              children: [
                const Text(
                  'Data',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text(
                  DateUltils.formatarData(op.dataReferencia),
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            // Linha de status e valor
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Status',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      statusDescricoes[op.status!],
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
                const Spacer(), // Adiciona espaço flexível entre os textos
                Text(
                  "${FormatarMoeda.formatar(op.valor)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            // Linha divisória
            Container(
              height: 1,
              color: const Color.fromARGB(118, 158, 158, 158),
              margin: const EdgeInsets.only(top: 15, bottom: 0),
            ),
            rowBtns(context)
          ],
        ),
      ),
    );
  }

  Widget rowParcelas(BuildContext context) {
    if (op.totalParcelas == 0) return const SizedBox.shrink();

    return Row(children: [
      const Text(
        'Parcelas',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      const SizedBox(width: 8),
      Text(op.totalParcelas.toString(),
          style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onPrimaryContainer))
    ]);
  }

  Widget rowBtns(BuildContext context) {
    if (op.idProprietario == userService.usuario.value!.uid) {
      return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            minimumSize: const Size(60, 30),
          ),
          onPressed: () {
            AlertService.alertConfirm(context, "Deseja realmente excluir?", "",
                () async {
              await controller.excluirOperacaoCompartilhada(op, context);
            }, null);
          },
          icon: const Icon(Icons.close, size: 15),
          label: const Text("Excluir", style: TextStyle(fontSize: 12)),
        )
      ]);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            minimumSize: const Size(60, 30),
          ),
          onPressed: () {},
          icon: const Icon(Icons.close, size: 15),
          label: const Text("RECUSAR", style: TextStyle(fontSize: 12)),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            minimumSize: const Size(60, 30),
          ),
          onPressed: () async {
            await controller.aprovarContaCompartilhada(op, context);
          },
          icon: const Icon(Icons.check, size: 15),
          label: const Text("APROVAR", style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
