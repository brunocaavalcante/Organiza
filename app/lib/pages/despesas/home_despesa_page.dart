import 'package:app/pages/despesas/cadastro_despes_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/masks.dart';
import '../../models/despesa.dart';
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CadastroDespesaPage()));
        },
        tooltip: 'Add Despesa',
        child: const Icon(Icons.add),
      ),
    );
  }

  body() {
    return Column(
      children: [containerTop()],
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

  contasPendentes() {}
  contasPagas() {}

  listaDespesas(Status status) {
    auth = Provider.of<UserService>(context);

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('despesas')
            .doc(auth!.usuario!.uid.toString())
            .collection("${data.month}/${data.year}")
            .snapshots(),
        builder: (context, snapshots) {
          return (snapshots.connectionState == ConnectionState.waiting)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshots.data!.docs[index].data()
                        as Map<String, dynamic>;

                    data["id"] = snapshots.data!.docs[index].id;
                    var despesa = Despesa().toEntity(data);

                    if (despesa.status == status) {
                      return item(despesa);
                    }
                    return Container();
                  });
        });
  }

  item(Despesa item) {
    return SizedBox(
        height: 100,
        child: Card(
            margin: const EdgeInsets.only(bottom: 20),
            child: ListTile(
              onTap: () => null,
              title: Text(
                item.descricao,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                FormatarMoeda.formatar(item.valor),
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              leading: Container(
                  width: 70,
                  height: 70,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Icon(Icons.favorite)),
            )));
  }
}
