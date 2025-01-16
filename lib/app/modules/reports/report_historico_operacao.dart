import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:organiza2/app/core/models/enums.dart';
import 'package:organiza2/app/modules/operacao/core/models/operacao.dart';
import 'package:organiza2/app/modules/operacao/core/services/operacao_service.dart';
import 'package:organiza2/app/modules/usuario/core/services/usuario_service.dart';
import 'package:organiza2/app/core/utils/date_ultils.dart';
import 'package:organiza2/app/core/utils/masks.dart';
import '../../core/widgets/widget_ultil.dart';

class RepotHistoricoOperacao extends StatefulWidget {
  const RepotHistoricoOperacao({super.key});

  @override
  State<RepotHistoricoOperacao> createState() => _RepotHistoricoOperacaoState();
}

class _RepotHistoricoOperacaoState extends State<RepotHistoricoOperacao>
    with TickerProviderStateMixin {
  final UserService auth = Modular.get<UserService>();
  final OperacaoService opService = Modular.get<OperacaoService>();
  final formKey = GlobalKey<FormState>();
  TextEditingController de = TextEditingController();
  TextEditingController ate = TextEditingController();
  TextEditingController titulo = TextEditingController();
  late ColorScheme colorScheme;
  late Size size;
  late TabController _tabController;
  List<Operacao> _operacoes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    de.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    ate.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    size = MediaQuery.of(context).size;
    return relatorioHistoricoOp();
  }
  //REGION REPORTS OPERACAO

  carregaListaOperacao() async {
    final operacoes = await opService!.buscarOperacoesPorData(
        DateUltils.stringToDate(de.text)!, DateUltils.stringToDate(ate.text)!);

    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _operacoes = operacoes;
      });
    });
  }

  Widget relatorioHistoricoOp() {
    return DefaultTabController(
        length: 2,
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(top: size.height * 0.02, bottom: 5),
            color: colorScheme.primaryContainer,
            child: Column(children: [
              Text("Relatório evolução da operação por ano",
                  style: TextStyle(
                      fontSize: size.width * 0.040,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: size.height * 0.01),
              TabBar(
                  labelColor: colorScheme.onPrimaryContainer,
                  controller: _tabController,
                  tabs: [Tab(text: 'Filtros'), Tab(text: 'Resultado')])
            ]),
          ),
          SizedBox(
              height: size.height * 0.80,
              child: TabBarView(controller: _tabController, children: [
                Center(child: formFiltro()),
                Center(child: containerHistoricoOperacao())
              ])),
        ]));
  }

  containerHistoricoOperacao() {
    return Column(children: [
      Container(
          width: MediaQuery.of(context).size.width * 0.95,
          margin: EdgeInsets.only(top: size.height * 0.02),
          child: WidgetUltil.barraConsulta(barOnchange())),
      containerListaOperacao()
    ]);
  }

  Function(String)? barOnchange() {
    return ((val) {
      titulo.text = val;
      setState(() {});
    });
  }

  formFiltro() {
    return Container(
        margin: EdgeInsets.all(size.height * 0.02),
        child: Form(
            key: formKey,
            child: Column(children: [
              WidgetUltil.returnField("De", de, TextInputType.datetime,
                  [Masks.dataFormatter], "##/##/####", false, validarData()),
              SizedBox(height: size.height * 0.02),
              WidgetUltil.returnField("Até", ate, TextInputType.datetime,
                  [Masks.dataFormatter], "##/##/####", false, validarData()),
              SizedBox(height: size.height * 0.02),
              WidgetUltil.returnButton(
                  "Gerar Relatorio", Icons.addchart_rounded, () async {
                if (formKey.currentState!.validate()) {
                  _tabController.animateTo(1);
                  carregaListaOperacao();
                }
              })
            ])));
  }

  String? Function(String?)? validarData() {
    return (((value) {
      DateTime? data = DateUltils.stringToDate(value);

      if (data == null) {
        return "Data fornecida é inválida.";
      }
      if (de.text != "" && ate.text != "") {
        var dataInicio = DateUltils.stringToDate(de.text)!;
        var dataFim = DateUltils.stringToDate(ate.text)!;

        if (dataFim.isBefore(dataInicio)) {
          return "A data de início não deve ser maior que a data final.";
        }

        if (dataInicio.isAfter(DateTime.now())) {
          return "A data de início não pode se maior que a data atual.";
        }
      }

      return null;
    }));
  }

  containerListaOperacao() {
    return Container(
        width: size.width,
        height: size.height * 0.69,
        margin: const EdgeInsets.only(left: 5, top: 10),
        child: FutureBuilder<List<Operacao>>(
            future: Future.value(_operacoes),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar os dados'));
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = snapshot.data![index];
                      item.titulo =
                          item.titulo == "" ? item.descricao : item.titulo;

                      if (titulo.text.isEmpty) {
                        return reeturItem(item);
                      }
                      if (item.titulo
                          .toString()
                          .toLowerCase()
                          .startsWith(titulo.text.toLowerCase())) {
                        return reeturItem(item);
                      }
                      return Container();
                    });
              }
            }));
  }

  reeturItem(Operacao item) {
    return ListTile(
        onTap: () {
          Modular.to.pushNamed('/operacao/detalhe',
              arguments: {'dataRef': item.dataReferencia, 'operacao': item});
        },
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(item.titulo),
          Text(DateUltils.formatarData(item.dataReferencia)),
        ]),
        subtitle:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Text(item.descricao,
                  overflow: TextOverflow.ellipsis, maxLines: 2)),
          Text(FormatarMoeda.formatar(item.valor),
              style: TextStyle(
                  color: item.status == Status.Pago.index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error))
        ]));
  }
}
