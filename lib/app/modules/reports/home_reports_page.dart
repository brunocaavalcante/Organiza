import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/core/models/enums.dart';
import 'package:organiza2/app/modules/operacao/data/models/operacao_model.dart';
import 'package:organiza2/app/core/models/report/chartdata.dart';
import 'package:organiza2/app/core/models/report/report.dart';
import 'package:organiza2/app/core/services/alert_service.dart';
import 'package:organiza2/app/modules/usuario/presentation/controllers/usuario_controller.dart';
import 'package:organiza2/app/modules/reports/report_historico_operacao.dart';
import 'package:organiza2/app/modules/reports/report_pizza.dart';
import 'package:organiza2/app/modules/navigation/presentation/pages/home_page.dart';

class HomeReportPage extends StatefulWidget {
  const HomeReportPage({super.key});

  @override
  State<HomeReportPage> createState() => _HomeReportPageState();
}

class _HomeReportPageState extends State<HomeReportPage> {
  final UsuarioController usuarioController = Modular.get<UsuarioController>();
  int monthReportDesRec = DateTime.now().month;
  int monthReportCategoria = DateTime.now().month;
  int monthReportOperacao = DateTime.now().month;
  late ColorScheme colorScheme;
  late Size size;

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            HomePage.scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text(
          "Relatórios",
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: ListView(children: [body()]),
    );
  }

  body() {
    return Container(
        margin: EdgeInsets.only(top: size.height * 0.03),
        width: size.width,
        child: Column(children: [
          relatorioDespezaOperacao(),
          relatorioDespezaCategoria(),
          const RepotHistoricoOperacao()
        ]));
  }

//REGION REPORTS DESPESA X RECEITAS
  List<ChartData> despesaXreceita(AsyncSnapshot<QuerySnapshot> lista) {
    List<ChartData> retorno = [];
    double totalDespesa = 0;
    double totalReceita = 0;

    if (lista.data == null) {
      return retorno;
    }

    for (var element in lista.data!.docs) {
      final docData = element.data();
      if (docData == null) continue;
      
      Map<String, dynamic> data = docData as Map<String, dynamic>;
      data["Id"] = element.id;
      var item = OperacaoModel.fromFirestore(data, element.id);

      if (item.tipoOperacao == TipoOperacao.Recibo.index &&
          item.afetarTotalizadores) {
        totalReceita += item.valor;
      } else if (item.tipoOperacao == TipoOperacao.Despesa.index &&
          item.afetarTotalizadores) {
        totalDespesa += item.valor;
      }
    }
    var depesa = ChartData(
        "Despesas", totalDespesa, Theme.of(context).colorScheme.error);

    var receita = ChartData("Receitas", totalReceita, Colors.blue);

    retorno.add(receita);
    retorno.add(depesa);
    return retorno;
  }

  relatorioDespezaOperacao() {
    final userId = usuarioController.usuarioAtual.value?.id;
    if (userId == null || userId.isEmpty) {
      return const Center(child: Text('Usuário não está logado'));
    }
    
    var queryStream = FirebaseFirestore.instance
        .collection('operacoes')
        .doc(userId.toString())
        .collection("$monthReportDesRec${DateTime.now().year}")
        .snapshots();

    return Column(children: [
      Container(
          margin: const EdgeInsets.only(top: 10, bottom: 2),
          width: size.width,
          color: colorScheme.primaryContainer,
          height: size.height * 0.07,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text("Relatório receitas X despezas",
                style: TextStyle(
                    fontSize: size.width * 0.035, fontWeight: FontWeight.bold)),
            OutlinedButton.icon(
                onPressed: () {
                  AlertService.alertSelect(
                          context, "Meses", null, mes, () => null)
                      .then((valueFromDialog) {
                    monthReportDesRec = valueFromDialog ?? monthReportDesRec;
                    setState(() {});
                  });
                },
                icon: const Icon(Icons.calendar_month),
                label: Text("${mes[monthReportDesRec]}/${DateTime.now().year}",
                    style: const TextStyle(fontSize: 16)))
          ])),
      SizedBox(
          width: size.width * 0.9,
          height: size.height * 0.35,
          child: StreamBuilder<QuerySnapshot>(
              stream: queryStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Algo deu errado.');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var relatorio = Report();
                relatorio.listData = despesaXreceita(snapshot);
                return ReportPizza(report: relatorio);
              }))
    ]);
  }

//REGION REPORTS CATEGORIA
  relatorioDespezaCategoria() {
    final userId = usuarioController.usuarioAtual.value?.id;
    if (userId == null || userId.isEmpty) {
      return const Center(child: Text('Usuário não está logado'));
    }
    
    var queryStream = FirebaseFirestore.instance
        .collection('operacoes')
        .doc(userId.toString())
        .collection("$monthReportCategoria${DateTime.now().year}")
        .snapshots();

    return Column(children: [
      Container(
          margin: const EdgeInsets.only(top: 10, bottom: 2),
          width: size.width,
          color: colorScheme.primaryContainer,
          height: size.height * 0.07,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text("Relatório despezas por categorias",
                style: TextStyle(
                    fontSize: size.width * 0.035, fontWeight: FontWeight.bold)),
            OutlinedButton.icon(
                onPressed: () {
                  AlertService.alertSelect(
                          context, "Meses", null, mes, () => null)
                      .then((valueFromDialog) {
                    monthReportCategoria =
                        valueFromDialog ?? monthReportCategoria;
                    setState(() {});
                  });
                },
                icon: const Icon(Icons.calendar_month),
                label: Text(
                    "${mes[monthReportCategoria]}/${DateTime.now().year}",
                    style: const TextStyle(fontSize: 16)))
          ])),
      SizedBox(
          width: size.width * 0.95,
          height: size.height * 0.50,
          child: StreamBuilder<QuerySnapshot>(
              stream: queryStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Algo deu errado.');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var relatorio = Report();
                relatorio.listData = obtemListaCategoria(snapshot);
                return ReportPizza(report: relatorio);
              }))
    ]);
  }

  List<ChartData> obtemListaCategoria(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<ChartData> lista = [];
    
    if (snapshot.data == null) {
      return lista;
    }
    
    for (var element in snapshot.data!.docs) {
      final docData = element.data();
      if (docData == null) continue;
      
      Map<String, dynamic> data = docData as Map<String, dynamic>;
      data["Id"] = element.id;
      var operacao = OperacaoModel.fromFirestore(data, element.id);

      if (operacao.tipoOperacao == TipoOperacao.Recibo.index) continue;
      
      if (operacao.categoria == null) continue;

      if (lista.any(
          (element) => element.text.contains(operacao.categoria!.descricao))) {
        int index = lista.indexWhere((element) =>
            element.text.contains((operacao.categoria!.descricao)));
        lista[index].value += operacao.valor;
      } else {
        var item = ChartData(operacao.categoria!.descricao, operacao.valor,
            Color(operacao.categoria!.color));
        lista.add(item);
      }
    }
    return lista;
  }
}
