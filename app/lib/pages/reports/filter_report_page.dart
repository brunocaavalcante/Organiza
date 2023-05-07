import 'package:app/core/widgets/widget_ultil.dart';
import 'package:app/models/operacao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/operacao_service.dart';

class FilterReportPage extends StatefulWidget {
  const FilterReportPage({super.key});

  @override
  State<FilterReportPage> createState() => _FilterReportPageState();
}

class _FilterReportPageState extends State<FilterReportPage> {
  List<Operacao> lista = [];
  List<Operacao> listaAux = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUltil.barWithArrowBackIos(context, "", ""),
      body: FutureBuilder(
          future:
              Provider.of<OperacaoService>(context).buscarTodasOperacoesAno(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              lista = snapshot.data ?? [];
              test();
              return body();
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  body() {
    return Column(children: []);
  }

  Widget item(int index) {
    int i = 0;
    while (i < listaAux.length) {
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [for (var i = 0; i < 2; i++) item(index)]);
    }

    if (index >= listaAux.length) {
      return Container();
    }
    String text = listaAux[index].titulo.isNotEmpty
        ? listaAux[index].titulo
        : listaAux[index].descricao;

    Color cor = listaAux[index].isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).hintColor;

    var onPressed = (() {
      setState(() {
        listaAux[index].isSelected = !listaAux[index].isSelected;
      });
    });
    return WidgetUltil.customRadioButton(text, index, cor, onPressed);
  }

  List<Operacao> test() {
    lista =
        lista.where((x) => x.repetir == true && x.tipoOperacao == 1).toList();

    for (var item in lista) {
      if (item.titulo.isNotEmpty) {
        if (listaAux.any((x) =>
                x.titulo.trim().contains(item.titulo.trim()) ||
                x.descricao.trim().contains(item.descricao.trim())) ==
            false) {
          listaAux.add(item);
        }
      }
      if (item.descricao.isNotEmpty) {
        if (listaAux.any((x) =>
                x.descricao.trim().contains(item.descricao.trim()) ||
                x.titulo.trim().contains(item.titulo.trim())) ==
            false) {
          listaAux.add(item);
        }
      }
    }
    return listaAux;
  }
}
