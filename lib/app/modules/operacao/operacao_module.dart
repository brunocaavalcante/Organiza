import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/modules/operacao/views/aprovacao_opercao_page.dart';
import 'package:organiza2/app/modules/operacao/views/cadastro_operacao_page.dart';
import 'package:organiza2/app/modules/operacao/views/detalhe_operacao_page.dart';
import 'package:organiza2/app/modules/operacao/views/home_despesa_page.dart';

class OperacaoModule extends Module {
  @override
  void binds(i) {
   
  }

  @override
  void routes(r) {
    r.child('/home', child: (context) => const HomeDespesaPage());
    r.child('/cadastro', child: (context) => const CadastroOperacaoPage());
    r.child('/detalhe', child: (context) => const DetalheOperacaoPage());
    r.child('/aprovacao', child: (context) => const AprovacaoOperacao());
  }
}
