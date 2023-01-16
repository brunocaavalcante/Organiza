import 'package:app/core/widgets/widget_ultil.dart';
import 'package:app/models/operacao.dart';
import 'package:flutter/material.dart';

import '../../core/date_ultils.dart';
import '../../core/masks.dart';

class DetalheOperacaoPage extends StatefulWidget {
  Operacao operacao;
  DetalheOperacaoPage({super.key, required this.operacao});

  @override
  State<DetalheOperacaoPage> createState() => _DetalheOperacaoPageState();
}

class _DetalheOperacaoPageState extends State<DetalheOperacaoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetUltil.barWithArrowBackIos(context, "Detalhes", null),
        body: body());
  }

  body() {
    double spaceAlt = MediaQuery.of(context).size.height * 0.01;
    return Column(children: [
      Container(
          padding: const EdgeInsets.only(top: 20, left: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.55,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            returnItem(
                "Descrição:", widget.operacao.descricao, Icons.description),
            SizedBox(height: spaceAlt),
            returnItem(
                "Data:",
                DateUltils.formatarData(widget.operacao.dataReferencia),
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
            returnItem(
                "Parcelado:",
                widget.operacao.totalParcelas > 0 ? "Sim" : "Não",
                Icons.playlist_add_check_circle),
            SizedBox(height: spaceAlt),
            returnItem("Quantidade de parcelas:",
                widget.operacao.totalParcelas.toString(), Icons.file_open),
            SizedBox(height: spaceAlt),
            returnItem(
                "Total de parcelas pagas:",
                widget.operacao.parcelasPagas.toString(),
                Icons.file_copy_rounded),
            SizedBox(height: spaceAlt),
            returnItem("Repetir?", widget.operacao.repetir ? "Sim" : "Não",
                Icons.repeat),
            SizedBox(height: spaceAlt),
            returnItem(
                "Frequencia:",
                TipoFrequencia.values[widget.operacao.status ?? 0].name,
                Icons.repeat_on_rounded)
          ])),
      const SizedBox(height: 30),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [btnExcluir(), btnEditar()])
    ]);
  }

  returnItem(txt, value, IconData icon) {
    return Row(children: [
      Icon(icon, color: Theme.of(context).hintColor, size: 30),
      const SizedBox(width: 15),
      Text(txt,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      const SizedBox(width: 15),
      Text(value, style: const TextStyle(fontSize: 19))
    ]);
  }

  btnExcluir() {
    return SizedBox(
        width: 150, child: WidgetUltil.returnButtonExcluir(() => null));
  }

  btnEditar() {
    return SizedBox(
        width: 150, child: WidgetUltil.returnButtonEditar(() => null));
  }
}
