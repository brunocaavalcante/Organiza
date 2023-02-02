import 'package:app/models/categoria.dart';
import 'package:app/models/operacao.dart';
import 'package:app/models/ultil.dart';
import 'package:app/services/operacao_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/date_ultils.dart';
import '../../core/masks.dart';
import '../../core/widgets/widget_ultil.dart';
import '../../models/custom_exception.dart';
import '../../models/enums.dart';
import '../categoria/select_categoria_page.dart';

class CadastroOperacaoPage extends StatefulWidget {
  DateTime? dataRef;
  Operacao? operacao;
  CadastroOperacaoPage({super.key, required this.dataRef, this.operacao});

  @override
  State<CadastroOperacaoPage> createState() => _CadastroOperacaoPageState();
}

class _CadastroOperacaoPageState extends State<CadastroOperacaoPage> {
  final formKey = GlobalKey<FormState>();
  final descricao = TextEditingController();
  final titulo = TextEditingController();
  final valor = TextEditingController();
  final qtdParcelas = TextEditingController();
  final dataVencimento = TextEditingController();
  TipoFrequencia? frequencia = TipoFrequencia.Nunca;
  int operacao = 1;
  bool isRepetir = false;
  Categoria? categoria;
  bool exibir = false;
  Widget customMsgErro = Container();

  @override
  void initState() {
    if (widget.operacao != null) {
      var op = widget.operacao;
      descricao.text = op!.descricao;
      valor.text = FormatarMoeda.formatar(op.valor);
      qtdParcelas.text = op.totalParcelas.toString();
      categoria = op.categoria;
      operacao = op.tipoOperacao ?? 1;
      isRepetir = op.repetir;
      titulo.text = op.titulo;
      dataVencimento.text = DateUltils.formatarData(op.dataVencimento);
      frequencia = TipoFrequencia.values[op.tipoFrequencia ?? 0];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            WidgetUltil.barWithArrowBackIos(context, "Cadastro Despesa", true),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WidgetUltil.returnField(
                              "Titulo: ",
                              titulo,
                              TextInputType.text,
                              null,
                              "",
                              false,
                              validacaoSimples()),
                          const SizedBox(height: 10),
                          WidgetUltil.returnField("Descrição: (opcional) ",
                              descricao, TextInputType.text, null, ""),
                          const SizedBox(height: 10),
                          WidgetUltil.returnField(
                              "Data Vencimento: (opcional)",
                              dataVencimento,
                              TextInputType.datetime,
                              [Masks.dataFormatter],
                              "##/##/####",
                              false,
                              validarDataVencimento()),
                          const SizedBox(height: 10),
                          WidgetUltil.returnField(
                              "Valor: ",
                              valor,
                              TextInputType.number,
                              [
                                FilteringTextInputFormatter.digitsOnly,
                                CurrencyInputFormatter()
                              ],
                              "R\$ 0,00",
                              false,
                              validacaoSimples()),
                          const SizedBox(height: 10),
                          fieldCategoria(),
                          (exibir == true ? customMsgErro : Container()),
                          const SizedBox(height: 15),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                customRadioButton("Despesa", 1,
                                    Icons.money_off_csred_rounded, Colors.red),
                                const SizedBox(width: 15),
                                customRadioButton("Recibo", 2,
                                    Icons.attach_money_outlined, Colors.green)
                              ]),
                          widget.operacao == null
                              ? Row(children: [
                                  const Text("Repetir ?",
                                      style: TextStyle(fontSize: 15)),
                                  Switch(
                                      value: isRepetir,
                                      onChanged: (value) {
                                        setState(() {
                                          isRepetir = value;
                                          if (isRepetir == false) {
                                            frequencia = TipoFrequencia.Nunca;
                                          }
                                        });
                                      })
                                ])
                              : Container(),
                          containerRepetir(),
                          const SizedBox(height: 30),
                          WidgetUltil.returnButtonSalvar(onPressedSalvar())
                        ])))));
  }

  String? Function(String?)? validacaoSimples() {
    return (((value) {
      if (value == "") {
        if (value == null || value.isEmpty) return "Campo obrigatorio";
        return null;
      }
    }));
  }

  String? Function(String?)? validarDataVencimento() {
    return (((value) {
      if (value != null && value != "") {
        DateTime? data = DateUltils.stringToDate(value);

        if (data!.isBefore(DateTime.now()))
          return "A data de vencimento não pode ser menor que a data atual";
      }
      return null;
    }));
  }

  onPressedSalvar() {
    return (() async {
      if (validarForm()) {
        await cadastrar();
      }
      setState(() {});
    });
  }

  bool validarForm() {
    if (categoria == null) {
      customMsgErro = WidgetUltil.returnTextErro(
          "Selecione a categoria!", Theme.of(context).errorColor);
      exibir = true;
      formKey.currentState!.validate();
      return false;
    } else {
      exibir = false;
      customMsgErro = Container();
      return (true && formKey.currentState!.validate());
    }
  }

  cadastrar() async {
    try {
      var parcelas = int.tryParse(qtdParcelas.text) ?? 0;
      Operacao item = widget.operacao ?? Operacao();
      item.repetir = isRepetir;
      item.totalParcelas = parcelas;
      item.tipoFrequencia = frequencia!.index;
      item.dataCadastro = DateTime.now();
      item.dataReferencia = widget.dataRef;
      item.descricao = descricao.text;
      item.categoria = categoria ?? Categoria();
      item.valor = Ultil().CoverterValorToDecimal(valor.text)!;
      item.status = Status.Pendente.index;
      item.tipoOperacao = operacao;
      item.titulo = titulo.text;
      item.dataVencimento = DateUltils.stringToDate(dataVencimento.text);

      if (widget.operacao == null) {
        if (item.tipoFrequencia == TipoFrequencia.Parcelado.index) {
          item.valor = item.valor / parcelas;
          await Provider.of<OperacaoService>(context, listen: false)
              .salvarComParcelas(item);
        } else if (item.tipoFrequencia == TipoFrequencia.AnoTodo.index) {
          await Provider.of<OperacaoService>(context, listen: false)
              .salvarAnoTodo(item);
        } else {
          await Provider.of<OperacaoService>(context, listen: false)
              .salvar(item);
        }
      } else {
        await Provider.of<OperacaoService>(context, listen: false)
            .atualizar(item);
      }
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

  containerRepetir() {
    if (isRepetir && widget.operacao == null) {
      return Column(children: [
        Row(children: [
          Radio(
              value: TipoFrequencia.AnoTodo,
              groupValue: frequencia,
              onChanged: (TipoFrequencia? value) {
                setState(() {
                  frequencia = value;
                });
              }),
          const Text("Ano todo"),
          Radio(
              value: TipoFrequencia.Parcelado,
              groupValue: frequencia,
              onChanged: (TipoFrequencia? value) {
                setState(() {
                  frequencia = value;
                });
              }),
          Text(TipoFrequencia.Parcelado.name)
        ]),
        fieldQtdParcelas()
      ]);
    } else {
      return Container();
    }
  }

  Widget fieldQtdParcelas() {
    if (frequencia == TipoFrequencia.Parcelado) {
      return WidgetUltil.returnField("Quantidade de parcelas: ", qtdParcelas,
          TextInputType.number, null, "", false, validacaoSimples());
    } else {
      return Container();
    }
  }

  Widget fieldCategoria() {
    return ListTile(
        onTap: () async {
          categoria = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SelectCategoriaPage()));
          setState(() {
            validarForm();
          });
        },
        contentPadding:
            const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10),
        title: Text(categoria != null ? categoria!.descricao : "Categoria",
            style: TextStyle(color: Theme.of(context).hintColor)),
        leading: categoria != null
            ? Icon(IconData(categoria!.icon, fontFamily: categoria!.fontFamily),
                color: Color(categoria!.color), size: 30)
            : null,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(05.0)),
            side: BorderSide(
                color: (exibir
                    ? Theme.of(context).errorColor
                    : Theme.of(context).hintColor))),
        tileColor: Theme.of(context).colorScheme.background,
        trailing: Icon(Icons.arrow_forward_ios_sharp,
            color: Theme.of(context).hintColor));
  }
}
