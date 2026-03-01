import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/core/models/custom_exception.dart';
import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/atualizar_operacao_usecase.dart';

class RotinaService extends ChangeNotifier {
  //Issue 3 Rotina verifica erro data de Referencia operação
  verificaErroDataRefrencia(Operacao op, int mesCollection) async {
    final dataRef = op.dataReferencia;
    if (dataRef == null) return false;
    
    if (dataRef.month != mesCollection) {
      try {
        final updated = op.copyWith(
          dataReferencia: DateTime(dataRef.year, mesCollection, 1),
        );
        final atualizarUseCase = Modular.get<AtualizarOperacaoUseCase>();
        await atualizarUseCase.call(updated);

        return true;
      } on CustomException {
        return false;
      }
    }
  }
}
