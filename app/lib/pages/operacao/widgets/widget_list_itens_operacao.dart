import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/masks.dart';
import '../../../core/widgets/widget_ultil.dart';
import '../../../models/enums.dart';
import '../../../models/operacao.dart';
import '../../../services/usuario_service.dart';
import '../detalhe_operacao_page.dart';

class ListItensOperacao extends StatefulWidget {
  DateTime data;
  ListItensOperacao({super.key, required this.data});

  @override
  State<ListItensOperacao> createState() => _ListItensOperacaoState();
}

class _ListItensOperacaoState extends State<ListItensOperacao> {
  UserService? auth;
  TextEditingController titulo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<UserService>(context);
    return containerMenu();
  }

  containerMenu() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          margin: const EdgeInsets.only(top: 15, bottom: 5),
          child: const Text("Contas",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      Container(
          width: MediaQuery.of(context).size.width * 0.95,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.02),
          child: WidgetUltil.barraConsulta(barOnchange())),
      SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          child: itemHistorico())
    ]);
  }

  itemHistorico() {
    Stream<QuerySnapshot> _participanteStream = FirebaseFirestore.instance
        .collection('operacoes')
        .doc(auth!.usuario!.uid.toString())
        .collection("${widget.data.month}${widget.data.year}")
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

          return Column(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            var operacao = Operacao().toEntity(data);
            operacao.id = document.id;

            if (titulo.text.isEmpty) {
              return returnCardItem(operacao);
            }
            if (operacao.titulo
                .toString()
                .toLowerCase()
                .startsWith(titulo.text.toLowerCase())) {
              return returnCardItem(operacao);
            }
            return Container();
          }).toList());
        });
  }

  Widget returnCardItem(Operacao operacao) {
    return Card(
        child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetalheOperacaoPage(
                          operacao: operacao, dataRef: widget.data)));
            },
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (operacao.totalParcelas > 0
                    ? Text(
                        "${operacao.parcelaAtual}/${operacao.totalParcelas}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    : const Text("")),
                Text(
                  FormatarMoeda.formatar(operacao.valor),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: operacao.status == Status.Pago.index
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
            subtitle: returnTxtStatus(operacao),
            title: Text(
                operacao.titulo == "" ? operacao.descricao : operacao.titulo,
                textAlign: TextAlign.start)));
  }

  returnTxtStatus(Operacao operacao) {
    String txt = "";
    if (operacao.tipoOperacao == TipoOperacao.Recibo.index) {
      txt = (operacao.status == Status.Pago.index ? "Recebido" : "Pendente");
    } else {
      txt = Status.values[operacao.status ?? 0].name;
    }
    return Text(txt,
        style: TextStyle(
            color: operacao.status == Status.Pago.index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.error));
  }

  Function(String)? barOnchange() {
    return ((val) {
      titulo.text = val;
      setState(() {});
    });
  }
}
