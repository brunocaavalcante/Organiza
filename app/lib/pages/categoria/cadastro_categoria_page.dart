import 'package:app/models/categoria.dart';
import 'package:app/pages/categoria/select_color_page.dart';
import 'package:app/pages/categoria/select_icon_page.dart';
import 'package:app/services/categoria_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/widget_ultil.dart';
import '../../models/custom_exception.dart';

class CadastroCategoriaPage extends StatefulWidget {
  const CadastroCategoriaPage({super.key});

  @override
  State<CadastroCategoriaPage> createState() => _CadastroCategoriaPageState();
}

class _CadastroCategoriaPageState extends State<CadastroCategoriaPage> {
  final formKey = GlobalKey<FormState>();
  final descricao = TextEditingController();
  IconData icon = Icons.home;
  Color color = Colors.amber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetUltil.barWithArrowBackIos(
            context, "Cadastro Categoria", true),
        body: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.07),
                padding: const EdgeInsets.all(10),
                child: Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WidgetUltil.returnField("Descrição: ", descricao,
                              TextInputType.text, null, ""),
                          const SizedBox(height: 30),
                          containerIcon()
                        ])))));
  }

  containerIcon() {
    double altura = MediaQuery.of(context).size.height * 0.1;
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text("Cor", style: TextStyle(fontSize: 30)),
        Text("Icone", style: TextStyle(fontSize: 30))
      ]),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
              onTap: () async {
                color = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectColorPage())) ??
                    Colors.amber;
                setState(() {});
              },
              child: Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    color: color),
              )),
          IconButton(
              icon: Icon(icon),
              iconSize: 100,
              onPressed: () async {
                icon = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectIconPage())) ??
                    Icons.home;
                setState(() {});
              })
        ],
      ),
      SizedBox(height: altura),
      SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
              shadowColor: Theme.of(context).colorScheme.primary,
              elevation: 5,
              surfaceTintColor: Theme.of(context).colorScheme.background,
              child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: Container(
                      width: 60,
                      height: 60,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Icon(
                        icon,
                        size: 55,
                        color: color,
                      )),
                  title: Text(descricao.text,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 30))))),
      SizedBox(height: altura),
      ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              await salvar();
            }
          },
          child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(Icons.save),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Salvar", style: TextStyle(fontSize: 20)),
            )
          ])),
    ]);
  }

  salvar() async {
    try {
      Categoria item = Categoria();
      item.color = color.value;
      item.descricao = descricao.text;
      item.fontFamily = "MaterialIcons";
      item.icon = icon.codePoint;
      await Provider.of<CategoriaService>(context, listen: false).salvar(item);
      Navigator.pop(context);
    } on CustomException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}
