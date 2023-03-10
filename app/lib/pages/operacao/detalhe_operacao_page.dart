import 'package:app/pages/operacao/cadastro_despes_page.dart';
import 'package:app/services/alert_service.dart';
import 'package:app/core/widgets/widget_ultil.dart';
import 'package:app/models/operacao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/date_ultils.dart';
import '../../core/masks.dart';
import '../../models/custom_exception.dart';
import '../../models/enums.dart';
import '../../services/operacao_service.dart';

class DetalheOperacaoPage extends StatefulWidget {
  Operacao operacao;
  DetalheOperacaoPage({super.key, required this.operacao});

  @override
  State<DetalheOperacaoPage> createState() => _DetalheOperacaoPageState();
}

class _DetalheOperacaoPageState extends State<DetalheOperacaoPage> {
  var valueSelected = 0;
  int parcelasPagas = 0;

  @override
  void initState() {
    retornQtdParcelasPagas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetUltil.barWithArrowBackIos(context, "Detalhes", null, [
          btnExcluirIcon(),
          btnEditarIcon(),
          SizedBox(width: MediaQuery.of(context).size.width * 0.05)
        ]),
        body: body());
  }

  body() {
    double spaceAlt = MediaQuery.of(context).size.height * 0.01;
    return Column(children: [
      Container(
          padding: const EdgeInsets.only(top: 20, left: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.60,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            returnItem("Titulo:", widget.operacao.titulo, Icons.description),
            SizedBox(height: spaceAlt),
            returnItem(
                "Descrição:", widget.operacao.descricao, Icons.description),
            SizedBox(height: spaceAlt),
            returnItem(
                "Data:",
                DateUltils.formatarData(widget.operacao.dataReferencia),
                Icons.date_range),
            SizedBox(height: spaceAlt),
            returnItem(
                "Data Vencimento:",
                DateUltils.formatarData(widget.operacao.dataVencimento),
                Icons.date_range),
            SizedBox(height: spaceAlt),
            returnItem("Valor:", FormatarMoeda.formatar(widget.operacao.valor),
                Icons.attach_money_outlined),
            SizedBox(height: spaceAlt),
            returnItem(
                "Categoria:",
                widget.operacao.categoria!.descricao,
                IconData(widget.operacao.categoria!.icon,
                    fontFamily: widget.operacao.categoria!.fontFamily)),
            SizedBox(height: spaceAlt),
            returnItem(
                "Tipo Operação:",
                TipoOperacao.values[widget.operacao.tipoOperacao ?? 0].name,
                Icons.adjust_rounded),
            SizedBox(height: spaceAlt),
            returnItem("Status:",
                Status.values[widget.operacao.status ?? 0].name, Icons.task),
            SizedBox(height: spaceAlt),
            returnItem("Repetir?", widget.operacao.repetir ? "Sim" : "Não",
                Icons.repeat),
            SizedBox(height: spaceAlt),
            returnItem(
                "Frequencia:",
                TipoFrequencia.values[widget.operacao.tipoFrequencia ?? 0].name,
                Icons.playlist_add_check_circle),
            SizedBox(height: spaceAlt),
            returnItem("Quantidade de parcelas:",
                widget.operacao.totalParcelas.toString(), Icons.file_open),
            SizedBox(height: spaceAlt),
            returnItem("Total de parcelas pagas:", parcelasPagas.toString(),
                Icons.file_copy_rounded)
          ])),
      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      btnPagar()
    ]);
  }

  returnItem(txt, value, IconData icon) {
    return value != null && value != "" && value != "0"
        ? Row(children: [
            Icon(icon, color: Theme.of(context).hintColor),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            Text(txt, style: const TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            Text(value)
          ])
        : Container();
  }

  btnExcluirIcon() {
    return SizedBox(
        child: WidgetUltil.returnButtonIcon(
            Icons.delete_forever, Theme.of(context).errorColor, () async {
      await excluirItem(widget.operacao);
    }));
  }

  btnEditarIcon() {
    return SizedBox(
        child: WidgetUltil.returnButtonIcon(
            Icons.edit, Theme.of(context).colorScheme.primary, () async {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CadastroOperacaoPage(
                  dataRef: widget.operacao.dataReferencia,
                  operacao: widget.operacao)));
    }));
  }

  excluirItem(Operacao item) async {
    try {
      if (item.repetir ?? false) {
        AlertService.alertRadios(
            context,
            "Alerta!",
            "Identificamos que essa operação repete nos meses futuros selecione uma das opções abaixo:",
            ["Excluir somente essa", "Excluir essa e as futuras"],
            item,
            onPressExcluirOk(item));
      } else {
        await Provider.of<OperacaoService>(context, listen: false)
            .excluir(item);
        Navigator.pop(context);
      }
      setState(() {});
    } on CustomException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Function()? onPressExcluirOk(item) {
    try {
      return (() async {
        if (AlertService.opSelecionada == 0) {
          await Provider.of<OperacaoService>(context, listen: false)
              .excluir(item);
        }
        if (AlertService.opSelecionada == 1) {
          var listaExcluir =
              await Provider.of<OperacaoService>(context, listen: false)
                  .buscarTodasOperacoesPorOperacao(item);

          for (var item in listaExcluir) {
            await Provider.of<OperacaoService>(context, listen: false)
                .excluir(item);
          }
        }
        Navigator.pop(context);
        Navigator.pop(context);
        setState(() {});
      });
    } on CustomException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
      return null;
    }
  }

  btnPagar() {
    return widget.operacao.status == Status.Pendente.index
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.height * 0.09,
            child: WidgetUltil.returnButton(
                "Marcar como paga.", Icons.check_circle, () async {
              try {
                widget.operacao.status = Status.Pago.index;
                await Provider.of<OperacaoService>(context, listen: false)
                    .atualizar(widget.operacao);
                Navigator.pop(context);
              } on CustomException catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.message)));
                return null;
              }
            }))
        : SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.height * 0.09,
            child: WidgetUltil.returnButton(
                "Marcar como pendente.", Icons.close_rounded, () async {
              try {
                widget.operacao.status = Status.Pendente.index;
                await Provider.of<OperacaoService>(context, listen: false)
                    .atualizar(widget.operacao);
                Navigator.pop(context);
              } on CustomException catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.message)));
                return null;
              }
            }, Theme.of(context).colorScheme.error.withOpacity(.9),
                Theme.of(context).colorScheme.onError));
  }

  retornQtdParcelasPagas() async {
    var parcelas = await Provider.of<OperacaoService>(context, listen: false)
        .buscarTodasOperacoesPorOperacao(widget.operacao);

    if (widget.operacao.totalParcelas > 0) {
      setState(() {
        parcelasPagas =
            parcelas.where((x) => x.status == Status.Pago.index).length;
      });
    }
  }
}
