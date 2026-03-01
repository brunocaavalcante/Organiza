import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/modules/operacao/data/repositories/operacao_repository_impl.dart';
import 'package:organiza2/app/modules/operacao/data/repositories/operacao_shared_repository_impl.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_repository.dart';
import 'package:organiza2/app/modules/operacao/domain/repositories/operacao_shared_repository.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/aprovar_conta_compartilhada_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/atualizar_operacao_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/buscar_historico_operacoes_compartilhadas_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/buscar_operacao_por_id_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/buscar_operacoes_compartilhadas_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/buscar_operacoes_mes_ano_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/buscar_operacoes_por_data_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/buscar_todas_operacoes_ano_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/editar_operacao_shared_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/excluir_operacao_shared_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/excluir_operacao_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/salvar_ano_todo_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/salvar_com_parcelas_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/salvar_operacao_shared_usecase.dart';
import 'package:organiza2/app/modules/operacao/domain/usecases/salvar_operacao_usecase.dart';
import 'package:organiza2/app/modules/operacao/presentation/controllers/operacao_controller.dart';
import 'package:organiza2/app/modules/operacao/presentation/controllers/operacao_shared_controller.dart';
import 'package:organiza2/app/modules/operacao/presentation/pages/aprovacao_opercao_page.dart';
import 'package:organiza2/app/modules/operacao/presentation/pages/cadastro_operacao_page.dart';
import 'package:organiza2/app/modules/operacao/presentation/pages/detalhe_operacao_page.dart';
import 'package:organiza2/app/modules/operacao/presentation/pages/home_despesa_page.dart';

class OperacaoModule extends Module {
  @override
  void binds(i) {
    // Repositories - agora acessam Firebase diretamente
    i.addLazySingleton<OperacaoRepository>(() => OperacaoRepositoryImpl(
        Modular.get<FirebaseAuth>(), Modular.get<FirebaseFirestore>()));
    i.addLazySingleton<OperacaoSharedRepository>(
      () => OperacaoSharedRepositoryImpl(
        Modular.get<FirebaseAuth>(),
        Modular.get<FirebaseFirestore>(),
      ),
    );

    // UseCases - Operacao
    i.add(() => SalvarOperacaoUseCase(Modular.get<OperacaoRepository>()));
    i.add(() => SalvarComParcelasUseCase(Modular.get<OperacaoRepository>()));
    i.add(() => SalvarAnoTodoUseCase(Modular.get<OperacaoRepository>()));
    i.add(() => AtualizarOperacaoUseCase(Modular.get<OperacaoRepository>()));
    i.add(() => ExcluirOperacaoUseCase(Modular.get<OperacaoRepository>()));
    i.add(
        () => BuscarOperacoesMesAnoUseCase(Modular.get<OperacaoRepository>()));
    i.add(() =>
        BuscarTodasOperacoesAnoUseCase(Modular.get<OperacaoRepository>()));
    i.add(
        () => BuscarOperacoesPorDataUseCase(Modular.get<OperacaoRepository>()));

    // UseCases - OperacaoShared
    i.addLazySingleton(() =>
        SalvarOperacaoSharedUseCase(Modular.get<OperacaoSharedRepository>()));
    i.addLazySingleton(() =>
        EditarOperacaoSharedUseCase(Modular.get<OperacaoSharedRepository>()));
    i.addLazySingleton(() =>
        ExcluirOperacaoSharedUseCase(Modular.get<OperacaoSharedRepository>()));
    i.addLazySingleton(() => BuscarOperacoesCompartilhadasUseCase(
        Modular.get<OperacaoSharedRepository>()));
    i.addLazySingleton(() => BuscarHistoricoOperacoesCompartilhadasUseCase(
        Modular.get<OperacaoSharedRepository>()));
    i.addLazySingleton(() =>
        BuscarOperacaoPorIdUseCase(Modular.get<OperacaoSharedRepository>()));
    i.addLazySingleton(() => AprovarContaCompartilhadaUseCase(
        Modular.get<OperacaoSharedRepository>(),
        Modular.get<OperacaoRepository>()));

    // Controllers
    i.addLazySingleton(
        () => OperacaoController(
              Modular.get<SalvarOperacaoUseCase>(),
              Modular.get<SalvarComParcelasUseCase>(),
              Modular.get<SalvarAnoTodoUseCase>(),
              Modular.get<AtualizarOperacaoUseCase>(),
            ));
    i.addLazySingleton(
      () => OperacaoSharedController(
        Modular.get<BuscarOperacoesCompartilhadasUseCase>(),
        Modular.get<BuscarHistoricoOperacoesCompartilhadasUseCase>(),
        Modular.get<SalvarOperacaoSharedUseCase>(),
        Modular.get<EditarOperacaoSharedUseCase>(),
        Modular.get<ExcluirOperacaoSharedUseCase>(),
        Modular.get<AprovarContaCompartilhadaUseCase>()
      ),
    );
  }

  @override
  void routes(r) {
    r.child('/home', child: (context) => const HomeDespesaPage());
    r.child('/cadastro', child: (context) => const CadastroOperacaoPage());
    r.child('/detalhe', child: (context) => const DetalheOperacaoPage());
    r.child('/aprovacao', child: (context) => const AprovacaoOperacao());
  }
}
