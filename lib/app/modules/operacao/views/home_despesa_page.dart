import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/core/models/enums.dart';
import 'package:organiza2/app/modules/operacao/core/models/operacao.dart';
import 'package:organiza2/app/modules/usuario/presentation/controllers/usuario_controller.dart';
import 'package:organiza2/app/core/utils/masks.dart';
import 'package:organiza2/app/modules/operacao/core/widgets/widget_list_itens_operacao.dart';

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
  final UsuarioController usuarioController = Modular.get<UsuarioController>();
  DateTime data = DateTime.now();
  TextEditingController titulo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    colorOnPrimary = Theme.of(context).colorScheme.onPrimary;

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
                  Modular.to.pushNamed('/operacao/cadastro',
                      arguments: {'dataRef': data, 'operacao': null});
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
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      IconButton(
          onPressed: () {
            setState(() {
              data = DateTime(data.year, data.month - 1, 1);
            });
          },
          icon: Icon(Icons.arrow_back_ios, color: colorOnPrimary)),
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
          icon: Icon(Icons.arrow_forward_ios, color: colorOnPrimary)),
      retornaFotoUser()
    ]);
  }

  containerTop() {
    final userId = usuarioController.usuarioAtual.value?.id;
    if (userId == null || userId.isEmpty) {
      return const Center(child: Text('Usuário não está logado'));
    }
    
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('operacoes')
            .doc(userId.toString())
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
            var operacao = Operacao().toEntity(data);
            operacao.id = element.id;
            atualizaTotalizadores(operacao);
          }
          return Container(
              width: width,
              height: height * 0.24,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(60.0),
                      bottomRight: Radius.circular(60.0))),
              child: Column(children: [
                Text("Balanço do Mês",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 14)),
                SizedBox(height: height * 0.01),
                Text("${FormatarMoeda.formatar(total)}",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: height * 0.01),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Receitas",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 14)),
                      Text("Despesas",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 14)),
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

  retornaFotoUser() {
    return Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05, right: 10, top: 5),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary),
        child: usuarioController.usuarioAtual.value?.photoUrl != null &&
                usuarioController.usuarioAtual.value!.photoUrl.isNotEmpty
            ? Image.network(usuarioController.usuarioAtual.value!.photoUrl,
                fit: BoxFit.cover)
            : containerImagem());
  }

  Widget containerImagem() {
    return Icon(Icons.account_circle_rounded,
        size: 45, color: Theme.of(context).colorScheme.surface);
  }

  labelTotal(String text, double value) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Text(text,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary, fontSize: 14)),
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
