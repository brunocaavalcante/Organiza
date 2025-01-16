import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/core/models/custom_exception.dart';
import 'package:organiza2/app/core/models/enums.dart';
import 'package:organiza2/app/modules/operacao/core/models/operacao.dart';
import 'package:organiza2/app/core/services/alert_service.dart';
import 'package:organiza2/app/core/services/file_service.dart';
import 'package:organiza2/app/modules/operacao/core/services/operacao_service.dart';
import 'package:organiza2/app/core/services/rotina.service.dart';
import 'package:organiza2/app/modules/usuario/core/services/usuario_service.dart';
import 'package:organiza2/app/core/utils/date_ultils.dart';
import 'package:organiza2/app/core/utils/masks.dart';
import 'package:organiza2/app/core/widgets/file_ultil.dart';
import 'package:organiza2/app/core/widgets/widget_ultil.dart';
import 'package:organiza2/app/modules/operacao/core/widgets/bottom_sheet/phone_input_bottom_sheet.dart';
import 'package:organiza2/app/modules/operacao/core/widgets/exibir_comprovante_widget.dart';

class DetalheOperacaoPage extends StatefulWidget {
  const DetalheOperacaoPage({super.key});

  @override
  State<DetalheOperacaoPage> createState() => _DetalheOperacaoPageState();
}

class _DetalheOperacaoPageState extends State<DetalheOperacaoPage> {
  final FileService _fileSevice = Modular.get<FileService>();
  final UserService _usuarioService = Modular.get<UserService>();
  final RotinaService _rotinaService = Modular.get<RotinaService>();
  final OperacaoService _operacaoService = Modular.get<OperacaoService>();
  var valueSelected = 0;
  int parcelasPagas = 0;
  bool anexar = false;
  late Operacao operacao;
  DateTime? dataRef;

  @override
  void initState() {
    final args = Modular.args.data;
    dataRef = args['dataRef'];
    operacao = args['operacao'];

    retornQtdParcelasPagas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetUltil.barWithArrowBackIos(context, "Detalhes", null, [
          btnExcluirIcon(),
          btnEditarIcon(),
          btnCompartilharIcon(),
          SizedBox(width: MediaQuery.of(context).size.width * 0.05)
        ]),
        body: body());
  }

  body() {
    double spaceAlt = MediaQuery.of(context).size.height * 0.01;
    return SingleChildScrollView(
      reverse: true,
      child: Column(children: [
        Container(
            padding: const EdgeInsets.only(top: 20, left: 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.60,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              returnItem("Titulo:", operacao.titulo, Icons.description),
              SizedBox(height: spaceAlt),
              returnItem("Descrição:", operacao.descricao, Icons.description),
              SizedBox(height: spaceAlt),
              returnItem(
                  "Data:",
                  DateUltils.formatarData(operacao.dataReferencia),
                  Icons.date_range),
              SizedBox(height: spaceAlt),
              returnItem("Data Vencimento:", retornaDataVencimento(),
                  Icons.date_range),
              SizedBox(height: spaceAlt),
              returnItem("Valor:", FormatarMoeda.formatar(operacao.valor),
                  Icons.attach_money_outlined),
              SizedBox(height: spaceAlt),
              returnItem(
                  "Categoria:",
                  operacao.categoria!.descricao,
                  IconData(operacao.categoria!.icon,
                      fontFamily: operacao.categoria!.fontFamily)),
              SizedBox(height: spaceAlt),
              returnItem(
                  "Tipo Operação:",
                  TipoOperacao.values[operacao.tipoOperacao ?? 0].name,
                  Icons.adjust_rounded),
              SizedBox(height: spaceAlt),
              returnItem("Status:", Status.values[operacao.status ?? 0].name,
                  Icons.task),
              SizedBox(height: spaceAlt),
              returnItem(
                  "Repetir?", operacao.repetir ? "Sim" : "Não", Icons.repeat),
              SizedBox(height: spaceAlt),
              returnItem(
                  "Frequencia:",
                  TipoFrequencia.values[operacao.tipoFrequencia ?? 0].name,
                  Icons.playlist_add_check_circle),
              SizedBox(height: spaceAlt),
              returnItem("Quantidade de parcelas:",
                  operacao.totalParcelas.toString(), Icons.file_open),
              SizedBox(height: spaceAlt),
              returnItem("Total de parcelas pagas:", parcelasPagas.toString(),
                  Icons.file_copy_rounded)
            ])),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        btnVerComporvantePagamento(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        btnAnexarComprovante(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        btnPagar()
      ]),
    );
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

  String retornaDataVencimento() {
    if (operacao.diaVencimento > 0 && operacao.dataReferencia != null) {
      var dia = operacao.diaVencimento;
      var mes = operacao.dataReferencia!.month;
      var ano = operacao.dataReferencia!.year;
      return DateUltils.formatarData(DateTime(ano, mes, dia));
    }
    return "";
  }

  btnExcluirIcon() {
    return SizedBox(
        child: WidgetUltil.returnButtonIcon(
            Icons.delete_forever, Theme.of(context).colorScheme.error,
            () async {
      await excluirItem(operacao);
    }));
  }

  btnCompartilharIcon() {
    return SizedBox(
        child: WidgetUltil.returnButtonIcon(
            Icons.person_add_sharp, Theme.of(context).colorScheme.primary,
            () async {
      BottomSheetUtil.showPhoneInputBottomSheet(context, operacao);
    }));
  }

  btnEditarIcon() {
    return SizedBox(
        child: WidgetUltil.returnButtonIcon(
            Icons.edit, Theme.of(context).colorScheme.primary, () async {
      Modular.to.pushNamed('/operacao/cadastro',
          arguments: {'dataRef': dataRef, 'operacao': operacao});
    }));
  }

  excluirItem(Operacao item) async {
    try {
      if (item.repetir) {
        AlertService.alertRadios(
            context,
            "Alerta!",
            "Identificamos que essa operação repete nos meses futuros selecione uma das opções abaixo:",
            ["Excluir somente essa", "Excluir de todos os meses"],
            item,
            onPressExcluirOk(item));
      } else {
        await _operacaoService.excluir(item);

        if (item.refImage != "") {
          await _fileSevice.excluirFile(item.refImage);
        }

        Navigator.pop(context);
      }
      setState(() {});
    } on CustomException catch (e) {
      e.show(context);
    }
  }

  Function()? onPressExcluirOk(item) {
    return (() async {
      try {
        if (AlertService.opSelecionada == 0) {
          await _operacaoService!.excluir(item);

          if (item.refImage != "") await _fileSevice.excluirFile(item.refImage);
        }
        if (AlertService.opSelecionada == 1) {
          var listaExcluir = await _operacaoService.buscarOperacoesByData(item);

          for (var item in listaExcluir) {
            await _operacaoService.excluir(item);

            if (item.refImage != "") {
              await _fileSevice.excluirFile(item.refImage);
            }
          }
        }
        Navigator.pop(context);
        Navigator.pop(context);
        setState(() {});
      } on CustomException catch (e) {
        if (e.error!.code == "not-found") {
          await _rotinaService.verificaErroDataRefrencia(item, dataRef!.month);
        }

       e.show(context);
        return null;
      }
    });
  }

  btnVerComporvantePagamento() {
    return operacao.status == Status.Pago.index && operacao.urlComprovante != ""
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
                                  url: operacao.urlComprovante)))
                    },
                Theme.of(context).colorScheme.inversePrimary))
        : Container();
  }

  btnAnexarComprovante() {
    return operacao.urlComprovante == "" && operacao.status == Status.Pago.index
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.06,
            child: WidgetUltil.returnButton(
                "Anexar comprovante de pagamento", Icons.file_present_outlined,
                () async {
              anexar = true;
              await pagarConta();
            }, Theme.of(context).colorScheme.inversePrimary))
        : Container();
  }

  btnPagar() {
    return operacao.status == Status.Pendente.index
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
                operacao.status = Status.Pendente.index;
                operacao.urlComprovante = "";
                await _operacaoService.atualizar(operacao);
                Navigator.pop(context);
              } on CustomException catch (e) {
                e.show(context);
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
      operacao.status = Status.Pago.index;
      var userId = _usuarioService.auth.currentUser!.uid;

      if (anexar) {
        var file =
            FileUtil(context, "", "comprovante/$userId", operacao.refImage);
        file.selectFile().then((value) async {
          setState(() {
            operacao.urlComprovante = _fileSevice.destino;
            operacao.refImage = _fileSevice.refImage;
          });

          await _operacaoService.atualizar(operacao);
        });
      } else {
        await _operacaoService.atualizar(operacao);
      }
      setState(() {});
    } on CustomException catch (e) {
      var sucesso = false;

      if (e.error!.code == "not-found") {
        sucesso = await _rotinaService.verificaErroDataRefrencia(
            operacao, dataRef!.month);
      }

      if (sucesso == false) {
        e.show(context);
      }
      return null;
    }
  }

  retornQtdParcelasPagas() async {
    if (operacao.totalParcelas > 0) {
      var parcelas = await _operacaoService.buscarOperacoesByData(operacao);

      setState(() {
        parcelasPagas =
            parcelas.where((x) => x.status == Status.Pago.index).length;
      });
    }
  }
}
