import 'package:app/models/categoria.dart';
import 'package:app/models/despesa.dart';
import 'package:app/models/ultil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../core/masks.dart';
import '../../core/widgets/widget_ultil.dart';

class CadastroDespesaPage extends StatefulWidget {
  const CadastroDespesaPage({super.key});

  @override
  State<CadastroDespesaPage> createState() => _CadastroDespesaPageState();
}

class _CadastroDespesaPageState extends State<CadastroDespesaPage> {
  final formKey = GlobalKey<FormState>();
  final descricao = TextEditingController();
  final valor = TextEditingController();

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
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {}
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

  cadastrar() {
    Despesa item = Despesa();
    item.dataCadastro = DateTime.now();
    item.descricao = descricao.text;
    item.categoria = CategoriaDepesa();
    item.categoria!.descricao = "Casa";
    item.categoria!.id = "1";
    item.valor = Ultil().CoverterValorToDecimal(valor.text)!;
  }
}
