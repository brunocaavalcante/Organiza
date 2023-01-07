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
                    data = new DateTime(data.year, data.month - 1, data.day);
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
                    data = new DateTime(data.year, data.month + 1, data.day);
                  });
                },
                icon: Icon(Icons.arrow_forward_ios, color: colorOnPrimary))
          ],
        ),
        SizedBox(height: height * 0.03),
        Text("Total do mês",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary, fontSize: 16)),
        SizedBox(height: height * 0.01),
        Text("RS 2.083,34",
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
          Text("RS 100,00",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16)),
          Text("RS 50,00",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16)),
        ])
      ]),
    );
  }

  containerMenu() {
    auth = Provider.of<UserService>(context);
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
              var despesa = Operacao().toEntity(data);

              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(bottom: 5, top: 5),
                  child: Card(
                      child: ListTile(
                          trailing: Text(
                            FormatarMoeda.formatar(despesa.valor),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: despesa.valor > 0
                                    ? Colors.green
                                    : Colors.red),
                          ),
                          /* leading: Container(
                              width: 50,
                              height: 50,
                              clipBehavior: Clip.antiAlias,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: operacao.photoContribuinte == ""
                                  ? Image.asset("imagens/logo_sem_nome.png",
                                      fit: BoxFit.cover)
                                  : Image.network(
                                      operacao.photoContribuinte as String,
                                      fit: BoxFit.cover)),*/
                          subtitle: Text(
                              DateUltils.formatarData(despesa.dataCadastro)),
                          title: Text(despesa.descricao.toString(),
                              textAlign: TextAlign.start))));
            }).toList(),
          );
        });
  }
}
