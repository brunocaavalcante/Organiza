import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/core/models/custom_exception.dart';
import 'package:organiza2/app/core/models/enums.dart';
import 'package:organiza2/app/modules/categoria/domain/entities/categoria.dart';
import 'package:organiza2/app/modules/operacao/presentation/controllers/operacao_controller.dart';
import 'package:organiza2/app/modules/operacao/domain/entities/operacao.dart';
import 'package:organiza2/app/core/services/rotina.service.dart';
import 'package:organiza2/app/core/utils/date_ultils.dart';
import 'package:organiza2/app/core/utils/masks.dart';
import 'package:organiza2/app/core/utils/string_utils.dart';
import '../../../../core/widgets/widget_ultil.dart';

class CadastroOperacaoPage extends StatefulWidget {
  const CadastroOperacaoPage({super.key});

  @override
  State<CadastroOperacaoPage> createState() => _CadastroOperacaoPageState();
}

class _CadastroOperacaoPageState extends State<CadastroOperacaoPage> {
  final OperacaoController controller = Modular.get<OperacaoController>();
  final RotinaService _rotinaService = Modular.get<RotinaService>();
  final formKey = GlobalKey<FormState>();
  final descricao = TextEditingController();
  final titulo = TextEditingController();
  final valor = TextEditingController();
  final qtdParcelas = TextEditingController();
  final diaVencimento = TextEditingController();
  TipoFrequencia? frequencia = TipoFrequencia.Nunca;
  DateTime? dataRef;
  Operacao? operacaoModel;
  int operacao = 1;
  bool isRepetir = false;
  bool afetarTotalizadores = true;
  Categoria? categoria;
  bool exibir = false;
  Widget customMsgErro = Container();

  @override
  void initState() {
    final args = Modular.args.data;
    dataRef = args['dataRef'];
    operacaoModel = args['operacao'];

    if (operacaoModel != null) {
      var op = operacaoModel;
      descricao.text = op!.descricao;
      valor.text = FormatarMoeda.formatar(op.valor);
      qtdParcelas.text = op.totalParcelas.toString();
      categoria = op.categoria;
      operacao = op.tipoOperacao ?? 1;
      isRepetir = op.repetir;
      afetarTotalizadores = op.afetarTotalizadores;
      titulo.text = op.titulo;
      diaVencimento.text = op.diaVencimento.toString();
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
                              "Título: ",
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
                              "Dia vencimento",
                              diaVencimento,
                              TextInputType.datetime,
                              [Masks.diaVencimentoFormatter],
                              "##",
                              false,
                              validarDiaVencimento()),
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
                          const SizedBox(height: 10),
                          operacaoModel == null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                      const Text("Repetir ?",
                                          style: TextStyle(fontSize: 15)),
                                      Switch(
                                          value: isRepetir,
                                          onChanged: (value) {
                                            setState(() {
                                              isRepetir = value;
                                              if (isRepetir == false) {
                                                frequencia =
                                                    TipoFrequencia.Nunca;
                                              }
                                            });
                                          }),
                                      fieldAfetaTotalizadores()
                                    ])
                              : fieldAfetaTotalizadores(),
                          containerRepetir(),
                          const SizedBox(height: 30),
                          WidgetUltil.returnButtonSalvar(onPressedSalvar())
                        ])))));
  }

  fieldAfetaTotalizadores() {
    return Row(children: [
      const Text("Afetar Totalizadores ?", style: TextStyle(fontSize: 15)),
      Switch(
          value: afetarTotalizadores,
          onChanged: (value) {
            setState(() {
              afetarTotalizadores = value;
            });
          })
    ]);
  }

  String? Function(String?)? validacaoSimples() {
    return (((value) {
      if (value == "") {
        if (value == null || value.isEmpty) return "Campo obrigatório";
        return null;
      }
      return null;
    }));
  }

  String? Function(String?)? validarDataVencimento() {
    return (((value) {
      if (value != null && value != "") {
        DateTime? data = DateUltils.stringToDate(value);

        if (data!.isBefore(DateTime.now())) {
          return "A data de vencimento não pode ser menor que a data atual";
        }
      }
      return null;
    }));
  }

  String? Function(String?)? validarDiaVencimento() {
    return ((value) {
      if (value != null && value.isNotEmpty) {
        int? intValue = int.tryParse(value);
        if (intValue != null && intValue >= 1 && intValue <= 28) {
          return null;
        }
      }
      return "Dia do vencimento inválido, o dia deve estar entre 01 e 28.";
    });
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
          "Selecione a categoria!", Theme.of(context).colorScheme.error);
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
      var valorCalculado = StringUtil().CoverterValorToDecimal(valor.text)!;
      
      // Ajusta valor se for parcelado
      if (frequencia == TipoFrequencia.Parcelado && parcelas > 0) {
        valorCalculado = valorCalculado / parcelas;
      }

      final item = operacaoModel?.copyWith(
        repetir: isRepetir,
        totalParcelas: parcelas,
        tipoFrequencia: frequencia!.index,
        dataCadastro: DateTime.now(),
        dataReferencia: dataRef,
        descricao: descricao.text,
        categoria: categoria ?? Categoria.empty(),
        valor: valorCalculado,
        tipoOperacao: operacao,
        titulo: titulo.text,
        afetarTotalizadores: afetarTotalizadores,
        diaVencimento: int.parse(diaVencimento.text),
      ) ?? Operacao(
        repetir: isRepetir,
        totalParcelas: parcelas,
        tipoFrequencia: frequencia!.index,
        dataCadastro: DateTime.now(),
        dataReferencia: dataRef,
        descricao: descricao.text,
        categoria: categoria ?? Categoria.empty(),
        valor: valorCalculado,
        tipoOperacao: operacao,
        titulo: titulo.text,
        afetarTotalizadores: afetarTotalizadores,
        diaVencimento: int.parse(diaVencimento.text),
        status: Status.Pendente.index,
      );

      if (operacaoModel == null) {
        // Usa o controller para chamar os use cases apropriados
        if (item.tipoFrequencia == TipoFrequencia.Parcelado.index) {
          await controller.salvarComParcelas(item);
        } else if (item.tipoFrequencia == TipoFrequencia.AnoTodo.index) {
          await controller.salvarAnoTodo(item);
        } else {
          await controller.salvarOperacaoSimples(item);
        }
        Navigator.pop(context, false);
      } else {
        await controller.atualizarOperacao(item);
        Modular.to.popAndPushNamed('/operacao/detalhe',
            arguments: {'dataRef': dataRef, 'operacao': item});
      }
    } on CustomException catch (e) {
      var sucesso = false;

      if (e.error != null && e.error!.code == "not-found") {
        sucesso = await _rotinaService.verificaErroDataRefrencia(
            Operacao(dataReferencia: dataRef), dataRef!.month);
      }

      if (sucesso == false) {
        e.show(context);
      }
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
    if (isRepetir && operacaoModel == null) {
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
          final categoriaNew =
              await Modular.to.pushNamed<Categoria>('/categoria/select');

          if (categoriaNew != null) {
            setState(() {
              categoria = categoriaNew;
              validarForm();
            });
          }
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
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).hintColor))),
        tileColor: Theme.of(context).colorScheme.surface,
        trailing: Icon(Icons.arrow_forward_ios_sharp,
            color: Theme.of(context).hintColor));
  }
}
