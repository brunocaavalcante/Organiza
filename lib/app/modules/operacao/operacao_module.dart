import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/modules/operacao/controller/operacao_controller.dart';
import 'package:organiza2/app/modules/operacao/controller/operacao_shared_controller.dart';
import 'package:organiza2/app/modules/operacao/core/services/operacao_service.dart';
import 'package:organiza2/app/modules/operacao/core/services/operacao_shared_service.dart';
import 'package:organiza2/app/modules/operacao/views/aprovacao_opercao_page.dart';
import 'package:organiza2/app/modules/operacao/views/cadastro_operacao_page.dart';
import 'package:organiza2/app/modules/operacao/views/detalhe_operacao_page.dart';
import 'package:organiza2/app/modules/operacao/views/home_despesa_page.dart';

class OperacaoModule extends Module {
  @override
  void binds(i) {
    // Services
    i.addLazySingleton(OperacaoService.new);
    i.addLazySingleton(OperacaoSharedService.new);
    
    // Controllers
    i.addLazySingleton(OperacaoController.new);
    i.addLazySingleton(OperacaoSharedController.new);
  }

  @override
  void routes(r) {
    r.child('/home', child: (context) => const HomeDespesaPage());
    r.child('/cadastro', child: (context) => const CadastroOperacaoPage());
    r.child('/detalhe', child: (context) => const DetalheOperacaoPage());
    r.child('/aprovacao', child: (context) => const AprovacaoOperacao());
  }
}
