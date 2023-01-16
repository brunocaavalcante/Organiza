import 'package:app/core/widgets/widget_ultil.dart';
import 'package:app/pages/operacao/cadastro_despes_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/date_ultils.dart';
import '../../core/masks.dart';
import '../../models/custom_exception.dart';
import '../../models/operacao.dart';
import '../../services/despesa_service.dart';
import '../../services/usuario_service.dart';
import 'detalhe_operacao_page.dart';

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
  int? valueSelected;
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
                  builder: (context) => CadastroOperacaoPage(dataRef: data)));
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
            SizedBox(height: height * 0.02),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text("Receitas",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16)),
              Text("Despesas",
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
    }
    if (item.tipoOperacao == TipoOperacao.Recibo.index) {
      totalPago = totalPago + item.valor;
    }
    total = totalPago - totalPagar;
  }

  containerMenu() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.55,
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
              height: MediaQuery.of(context).size.height * 0.49,
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
              var operacao = Operacao().toEntity(data);
              operacao.id = document.id;
              return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: WidgetUltil.returnDimissibleExcluir(
                      returnCardItem(operacao), dismissExcluirItem(operacao)));
            }).toList(),
          );
        });
  }

  returnCardItem(Operacao operacao) {
    return Card(
        child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetalheOperacaoPage(operacao: operacao)));
            },
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (operacao.totalParcelas > 0
                    ? Text(
                        "${operacao.parcelasPagas}/${operacao.totalParcelas}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    : const Text("")),
                Text(
                  FormatarMoeda.formatar(operacao.valor),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: operacao.tipoOperacao == TipoOperacao.Recibo.index
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error),
                )
              ],
            ),
            leading: Container(
                width: 50,
                height: 50,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Icon(
                    IconData(operacao.categoria!.icon,
                        fontFamily: operacao.categoria!.fontFamily),
                    color: Color(operacao.categoria!.color))),
            subtitle: Text(DateUltils.formatarData(operacao.dataCadastro)),
            title: Text(operacao.descricao.toString(),
                textAlign: TextAlign.start)));
  }

  Function(DismissDirection)? dismissExcluirItem(Operacao item) {
    return (_) async {
      try {
        if (item.repetir ?? false) {
          alertRadios(context, "Alerta", "Selecione umdas opções abaixo:",
              ["Excluir somente essa", "Excluir essa e as futuras"]);
        } else {
          await Provider.of<DespesaService>(context, listen: false)
              .excluir(item);
        }
        setState(() {});
      } on CustomException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    };
  }

  alertRadios(BuildContext context, String title, String subtitle,
      List<String> options) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                    title: Text(options[0]),
                    leading: Radio(
                      value: 0,
                      groupValue: valueSelected,
                      onChanged: (int? value) {
                        setState(() {
                          valueSelected = value;
                          print(valueSelected);
                        });
                      },
                    )),
                ListTile(
                    title: Text(options[1]),
                    leading: Radio(
                      value: 1,
                      groupValue: valueSelected,
                      onChanged: (int? value) {
                        setState(() {
                          valueSelected = value;
                          print(valueSelected);
                        });
                      },
                    ))
              ],
            ),
            actions: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close, size: 18),
                label: Text("Cancelar"),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.check, size: 18),
                label: Text("OK"),
              )
            ]);
      },
    );
  }
}
