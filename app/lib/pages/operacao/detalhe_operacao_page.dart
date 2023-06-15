import 'package:app/core/widgets/file_ultil.dart';
import 'package:app/pages/operacao/cadastro_operacao_page.dart';
import 'package:app/pages/operacao/widgets/exibir_comprovante_widget.dart';
import 'package:app/services/alert_service.dart';
import 'package:app/core/widgets/widget_ultil.dart';
import 'package:app/models/operacao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/date_ultils.dart';
import '../../core/masks.dart';
import '../../models/custom_exception.dart';
import '../../models/enums.dart';
import '../../services/file_service.dart';
import '../../services/operacao_service.dart';
import '../../services/rotina.service.dart';
import '../../services/usuario_service.dart';

class DetalheOperacaoPage extends StatefulWidget {
  Operacao operacao;
  DateTime dataRef;
  DetalheOperacaoPage(
      {super.key, required this.operacao, required this.dataRef});

  @override
  State<DetalheOperacaoPage> createState() => _DetalheOperacaoPageState();
}

class _DetalheOperacaoPageState extends State<DetalheOperacaoPage> {
  var valueSelected = 0;
  int parcelasPagas = 0;
  bool anexar = false;
  OperacaoService? service;

  @override
  void initState() {
    retornQtdParcelasPagas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    service = Provider.of<OperacaoService>(context, listen: false);
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
      if (widget.operacao.urlComprovante != "" &&
          widget.operacao.status == Status.Pago.index)
        btnVerComporvantePagamento(),
      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      btnPagar()
    ]);
  }

  returnItem(txt, value, IconData icon) {
    return value != null && value != "" && value != "0"
        ? Row(children: [
            Icon(icon, color: Theme.of(context).hintColor),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Wrap(children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Text(txt,
                      style: const TextStyle(fontWeight: FontWeight.bold)))
            ]),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03),
            Wrap(children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.57,
                  child: Text(value))
            ])
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
                  dataRef: widget.dataRef, operacao: widget.operacao)));
    }));
  }

  excluirItem(Operacao item) async {
    try {
      if (item.repetir) {
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

        if (item.refImage != "")
          await context.read<FileService>().excluirFile(item.refImage);

        Navigator.pop(context);
      }
      setState(() {});
    } on CustomException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Function()? onPressExcluirOk(item) {
    return (() async {
      try {
        if (AlertService.opSelecionada == 0) {
          await service!.excluir(item);

          if (item.refImage != "")
            await context.read<FileService>().excluirFile(item.refImage);
        }
        if (AlertService.opSelecionada == 1) {
          var listaExcluir =
              await service!.buscarTodasOperacoesPorOperacao(item);

          for (var item in listaExcluir) {
            await service!.excluir(item);

            if (item.refImage != "")
              await context.read<FileService>().excluirFile(item.refImage);
          }
        }
        Navigator.pop(context);
        Navigator.pop(context);
        setState(() {});
      } on CustomException catch (e) {
        if (e.error!.code == "not-found") {
          await Provider.of<RotinaService>(context, listen: false)
              .verificaErroDataRefrencia(context, item, widget.dataRef.month);
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
        return null;
      }
    });
  }

  btnVerComporvantePagamento() {
    return widget.operacao.status == Status.Pago.index
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.06,
            child: WidgetUltil.returnButton(
                "Ver comprovante pagamento",
                Icons.remove_red_eye_sharp,
                () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExibirComprovanteWidget(
                                  url: widget.operacao.urlComprovante)))
                    },
                Theme.of(context).colorScheme.inversePrimary))
        : Container();
  }

  btnPagar() {
    return widget.operacao.status == Status.Pendente.index
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.06,
            child: WidgetUltil.returnButton(
                "Marcar como paga.", Icons.check_circle, () async {
              AlertService.alertConfirmAnexar(
                  context,
                  "Conta Paga!",
                  "Deseja anexar comprovante de pagamento?",
                  onPressedAnexar,
                  onPressedCancelar);
            }, Theme.of(context).colorScheme.inversePrimary))
        : SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.06,
            child: WidgetUltil.returnButton(
                "Marcar como pendente.", Icons.close_rounded, () async {
              try {
                widget.operacao.status = Status.Pendente.index;
                widget.operacao.urlComprovante = "";
                await Provider.of<OperacaoService>(context, listen: false)
                    .atualizar(widget.operacao);
                Navigator.pop(context);
              } on CustomException catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.message)));
                return null;
              }
            }, Theme.of(context).colorScheme.inversePrimary));
  }

  onPressedAnexar() async {
    anexar = true;
    await pagarConta();
    Navigator.pop(context);
  }

  onPressedCancelar() async {
    anexar = false;
    await pagarConta();
    Navigator.pop(context);
  }

  pagarConta() async {
    try {
      widget.operacao.status = Status.Pago.index;
      var userId = context.read<UserService>().auth.currentUser!.uid;

      if (anexar) {
        var file = FileUtil(
            context, "", "comprovante/${userId}", widget.operacao.refImage);
        file.selectFile().then((value) async {
          widget.operacao.urlComprovante = context.read<FileService>().destino;
          widget.operacao.refImage = context.read<FileService>().refImage;
          await service!.atualizar(widget.operacao);
        });
      } else {
        await service!.atualizar(widget.operacao);
      }

      setState(() {});
    } on CustomException catch (e) {
      var sucesso = false;

      if (e.error!.code == "not-found") {
        sucesso = await Provider.of<RotinaService>(context, listen: false)
            .verificaErroDataRefrencia(
                context, widget.operacao, widget.dataRef.month);
      }

      if (sucesso == false) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
      return null;
    }
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
