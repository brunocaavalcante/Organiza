import 'dart:ui';

import 'package:app/models/categoria.dart';
import 'package:app/models/operacao.dart';
import 'package:app/models/ultil.dart';
import 'package:app/services/despesa_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/masks.dart';
import '../../core/widgets/widget_ultil.dart';
import '../../models/custom_exception.dart';

class CadastroDespesaPage extends StatefulWidget {
  DateTime? dataRef;
  CadastroDespesaPage({super.key, required this.dataRef});

  @override
  State<CadastroDespesaPage> createState() => _CadastroDespesaPageState();
}

class _CadastroDespesaPageState extends State<CadastroDespesaPage> {
  final formKey = GlobalKey<FormState>();
  final descricao = TextEditingController();
  final valor = TextEditingController();
  int operacao = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUltil.barWithArrowBackIos(context, "Cadastro Despesa"),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetUltil.returnField(
                  "Descrição: ", descricao, TextInputType.text, null, ""),
              const SizedBox(height: 10),
              WidgetUltil.returnField(
                  "Categoria: ", descricao, TextInputType.text, null, ""),
              const SizedBox(height: 10),
              WidgetUltil.returnField(
                  "Valor: ",
                  valor,
                  TextInputType.number,
                  [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyInputFormatter()
                  ],
                  "R\$ 0,00"),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                customRadioButton(
                    "Despesa", 1, Icons.money_off_csred_rounded, Colors.red),
                const SizedBox(width: 15),
                customRadioButton(
                    "Recibo", 2, Icons.attach_money_outlined, Colors.green)
              ]),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    cadastrar();
                  }
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.save),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("Salvar", style: TextStyle(fontSize: 20)),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      )),
    );
  }

  cadastrar() async {
    try {
      Operacao item = Operacao();
      item.dataCadastro = DateTime.now();
      item.dataReferencia = widget.dataRef;
      item.descricao = descricao.text;
      item.categoria = CategoriaDepesa();
      item.categoria!.descricao = "Casa";
      item.categoria!.id = "1";
      item.valor = Ultil().CoverterValorToDecimal(valor.text)!;
      item.status = Status.Pendente.index;
      item.tipoOperacao = operacao;
      await Provider.of<DespesaService>(context, listen: false).salvar(item);
      Navigator.pop(context);
    } on CustomException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  customRadioButton(String text, int index, IconData icon, Color color) {
    return OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
              color: (operacao == index ? color : Theme.of(context).hintColor)),
        ),
        onPressed: () {
          setState(() {
            operacao = index;
          });
        },
        icon: Icon(icon,
            color: (operacao == index ? color : Theme.of(context).hintColor)),
        label: Text(text,
            style: TextStyle(
                color: (operacao == index
                    ? color
                    : Theme.of(context).hintColor))));
  }
}
