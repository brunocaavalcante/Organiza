import 'package:app/pages/operacao/cadastro_operacao_page.dart';
import 'package:app/pages/operacao/widgets/widget_list_itens_operacao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/masks.dart';
import '../../models/enums.dart';
import '../../models/operacao.dart';
import '../../services/usuario_service.dart';

class HomeDespesaPage extends StatefulWidget {
  const HomeDespesaPage({super.key});

  @override
  State<HomeDespesaPage> createState() => _HomeDespesaPageState();
}

class _HomeDespesaPageState extends State<HomeDespesaPage> {
  var height;
  var width;
  Color? colorOnPrimary;
  double totalReceita = 0;
  double totalDespesa = 0;
  double totalPagar = 0;
  double totalPago = 0;
  double total = 0;
  int? valueSelected;
  UserService? auth;
  DateTime data = DateTime.now();
  TextEditingController titulo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    colorOnPrimary = Theme.of(context).colorScheme.onPrimary;
    auth = Provider.of<UserService>(context);

    return Dismissible(
        resizeDuration: const Duration(milliseconds: 10),
        key: UniqueKey(),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            data = DateTime(data.year, data.month + 1, 1);
          } else {
            data = DateTime(data.year, data.month - 1, 1);
          }
          setState(() {});
        },
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                title: containerMes()),
            body: body(),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CadastroOperacaoPage(dataRef: data)));
                },
                tooltip: 'Add Despesa',
                child: const Icon(Icons.add))));
  }

  body() {
    return ListView(children: [
      Column(children: [containerTop(), ListItensOperacao(data: data)])
    ]);
  }

  Widget containerMes() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      IconButton(
          onPressed: () {
            setState(() {
              data = DateTime(data.year, data.month - 1, 1);
            });
          },
          icon: Icon(Icons.arrow_back_ios, color: colorOnPrimary)),
      const SizedBox(width: 15),
      Text("${mes[data.month]} ${data.year}",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold)),
      IconButton(
          onPressed: () {
            setState(() {
              data = DateTime(data.year, data.month + 1, 1);
            });
          },
          icon: Icon(Icons.arrow_forward_ios, color: colorOnPrimary))
    ]);
  }

  containerTop() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('operacoes')
            .doc(auth!.usuario!.uid.toString())
            .collection("${data.month}${data.year}")
            .orderBy('status')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Algo deu errado.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          totalDespesa = 0;
          totalReceita = 0;
          totalPagar = 0;
          totalPago = 0;
          total = 0;
          for (var element in snapshot.data!.docs) {
            Map<String, dynamic> data = element.data()! as Map<String, dynamic>;
            data["Id"] = element.id;
            var operacao = Operacao().toEntity(data);
            atualizaTotalizadores(operacao);
          }
          return Container(
              width: width,
              height: height * 0.24,
              padding: EdgeInsets.only(top: height * 0.01),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(60.0),
                      bottomRight: Radius.circular(60.0))),
              child: Column(children: [
                Text("Balanço do Mês",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 16)),
                SizedBox(height: height * 0.01),
                Text("${FormatarMoeda.formatar(total)}",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 23,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: height * 0.01),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Receitas",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 16)),
                      Text("Despesas",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 16)),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("${FormatarMoeda.formatar(totalReceita)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 16)),
                      Text("${FormatarMoeda.formatar(totalDespesa)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 16)),
                    ]),
                SizedBox(height: height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    labelTotal("Despesa pagas", totalPago),
                    labelTotal("Despesa pendente", totalPagar)
                  ],
                )
              ]));
        });
  }

  labelTotal(String text, double value) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Text(text,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary, fontSize: 16)),
      Text("${FormatarMoeda.formatar(value)}",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 16))
    ]);
  }

  atualizaTotalizadores(Operacao item) {
    if (item.tipoOperacao == TipoOperacao.Despesa.index &&
        item.afetarTotalizadores) {
      totalDespesa = totalDespesa + item.valor;

      if (item.status == Status.Pendente.index) {
        totalPagar = totalPagar + item.valor;
      }

      if (item.status == Status.Pago.index) {
        totalPago = totalPago + item.valor;
      }
    }
    if (item.tipoOperacao == TipoOperacao.Recibo.index &&
        item.afetarTotalizadores) {
      totalReceita = totalReceita + item.valor;
    }

    if (item.afetarTotalizadores) {
      total = totalReceita - totalDespesa;
    }
  }
}
