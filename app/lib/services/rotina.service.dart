import 'package:app/models/custom_exception.dart';
import 'package:app/models/operacao.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'operacao_service.dart';

class RotinaService extends ChangeNotifier {
  //Issue 3 Rotina verifica erro data de Referencia operação
  verificaErroDataRefrencia(
      BuildContext context, Operacao op, int mesCollection) async {
    if (op.dataReferencia!.month != mesCollection) {
      try {
        op.dataReferencia = DateTime(op.dataReferencia!.year, mesCollection, 1);
        await Provider.of<OperacaoService>(context, listen: false)
            .atualizar(op);

        return true;
      } on CustomException catch (ex) {
        return false;
      }
    }
  }
}
