import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/core/models/custom_exception.dart';
import 'package:organiza2/app/modules/operacao/core/models/operacao.dart';

import '../../modules/operacao/core/services/operacao_service.dart';

class RotinaService extends ChangeNotifier {
  final _operacaoService = Modular.get<OperacaoService>();
  //Issue 3 Rotina verifica erro data de Referencia operação
  verificaErroDataRefrencia(Operacao op, int mesCollection) async {
    if (op.dataReferencia!.month != mesCollection) {
      try {
        op.dataReferencia = DateTime(op.dataReferencia!.year, mesCollection, 1);
        await _operacaoService.atualizar(op);

        return true;
      } on CustomException catch (ex) {
        return false;
      }
    }
  }
}
