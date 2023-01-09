import 'package:app/pages/despesas/cadastro_despes_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/date_ultils.dart';
import '../../core/masks.dart';
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
  double totalPago = 0;
  double totalPagar = 0;
  double total = 0;
  UserService? auth;
  late DateTime data = DateTime.now();
  List mes = [
    '',
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    colorOnPrimary = Theme.of(context).colorScheme.onPrimary;
    auth = Provider.of<UserService>(context);

    return Scaffold(
      body: body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CadastroDespesaPage(dataRef: data)));
        },
        tooltip: 'Add Despesa',
        child: const Icon(Icons.add),
      ),
    );
  }

  body() {
    return Column(
      children: [containerTop(), containerMenu()],
    );
  }

  containerTop() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('despesas')
          .doc(auth!.usuario!.uid.toString())
          .collection("${data.month}${data.year}")
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
          height: height * 0.33,
          padding: EdgeInsets.only(top: height * 0.05),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(60.0),
                bottomRight: Radius.circular(60.0),
              )),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        data = DateTime(data.year, data.month - 1, data.day);
                      });
                    },
                    icon: Icon(Icons.arrow_back_ios, color: colorOnPrimary)),
                const SizedBox(width: 15),
                Text("${mes[data.month]} ${data.year}",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 15),
                IconButton(
                    onPressed: () {
                      setState(() {
                        data = DateTime(data.year, data.month + 1, data.day);
                      });
                    },
                    icon: Icon(Icons.arrow_forward_ios, color: colorOnPrimary))
              ],
            ),
            SizedBox(height: height * 0.03),
            Text("Total do mês",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16)),
            SizedBox(height: height * 0.01),
            Text("${FormatarMoeda.formatar(total)}",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 23,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: height * 0.02),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text("Pago",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16)),
              Text("A pagar",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16)),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text("${FormatarMoeda.formatar(totalPago)}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16)),
              Text("${FormatarMoeda.formatar(totalPagar)}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16)),
            ])
          ]),
        );
      },
    );
  }

  atualizaTotalizadores(Operacao item) {
    if (item.tipoOperacao == TipoOperacao.Despesa.index) {
      totalPagar = totalPagar + item.valor;
      total = total + item.valor;
    }
    if (item.tipoOperacao == TipoOperacao.Recibo.index) {
      totalPago = totalPago + item.valor;
      totalPagar = totalPagar - totalPago;
    }
  }

  containerMenu() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.53,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Contas",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: itemHistorico(),
            )
          ],
        ));
  }

  itemHistorico() {
    Stream<QuerySnapshot> _participanteStream = FirebaseFirestore.instance
        .collection('despesas')
        .doc(auth!.usuario!.uid.toString())
        .collection("${data.month}${data.year}")
        //.orderBy('DataCadastro', descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: _participanteStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Erro!');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Carregando");
          }

          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              data["Id"] = document.id;
              var operacao = Operacao().toEntity(data);
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(bottom: 5, top: 5),
                  child: Card(
                      child: ListTile(
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (operacao.totalParcelas > 0
                                  ? Text(
                                      "${operacao.parcelasPagas}/${operacao.totalParcelas}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : const Text("")),
                              Text(
                                FormatarMoeda.formatar(operacao.valor),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: operacao.tipoOperacao ==
                                            TipoOperacao.Recibo.index
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.error),
                              )
                            ],
                          ),
                          /* leading: Container(
                              width: 50,
                              height: 50,
                              clipBehavior: Clip.antiAlias,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: Icon(Icons.ac_unit_rounded)),*/
                          subtitle: Text(
                              DateUltils.formatarData(operacao.dataCadastro)),
                          title: Text(operacao.descricao.toString(),
                              textAlign: TextAlign.start))));
            }).toList(),
          );
        });
  }
}
