import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/modules/operacao/presentation/widgets/cards/aprove_item_card_widget.dart';
import 'package:organiza2/app/modules/operacao/domain/entities/operacao_shared.dart';
import 'package:organiza2/app/modules/operacao/presentation/controllers/operacao_shared_controller.dart';

class AprovacaoOperacao extends StatefulWidget {
  const AprovacaoOperacao({super.key});

  @override
  State<AprovacaoOperacao> createState() => _AprovacaoOperacaoState();
}

class _AprovacaoOperacaoState extends State<AprovacaoOperacao>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late OperacaoSharedController _controller;
  late Size size;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<OperacaoSharedController>();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: body(),
    );
  }

  Widget body() {
    return DefaultTabController(
        length: 2,
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(top: size.height * 0.05, bottom: 5),
            child: Column(children: [
              Text("Compartilhamentos",
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurface)),
              SizedBox(height: size.height * 0.02),
              TabBar(
                  labelColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  controller: _tabController,
                  tabs: const [Tab(text: 'Novo'), Tab(text: 'Histórico')])
            ]),
          ),
          SizedBox(
              height: size.height * 0.74,
              child: TabBarView(controller: _tabController, children: [
                Center(
                  child: StreamBuilder<List<OperacaoShared>>(
                    stream: _controller.obterOperacaoCompartilhadas(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text("Erro ao carregar dados"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text("Nenhuma operação encontrada"));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var operacao = snapshot.data![index];
                            return AproveItemCad(op: operacao);
                          },
                        );
                      }
                    },
                  ),
                ),
                Center(
                  child: StreamBuilder<List<OperacaoShared>>(
                    stream: _controller.buscarHistoricoOperacoesCompartilhada(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text("Erro ao carregar dados"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text("Nenhuma operação encontrada"));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var operacao = snapshot.data![index];
                            return AproveItemCad(op: operacao);
                          },
                        );
                      }
                    },
                  ),
                ),
              ]))
        ]));
  }
}
