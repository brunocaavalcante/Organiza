import 'package:flutter/material.dart';

class SelectColorPage extends StatefulWidget {
  const SelectColorPage({super.key});

  @override
  State<SelectColorPage> createState() => _SelectColorPageState();
}

class _SelectColorPageState extends State<SelectColorPage> {
  var listColors = [
    Colors.yellow.shade100,
    Colors.yellowAccent.shade400,
    Colors.yellow,
    Colors.yellow.shade900,
    Colors.red.shade100,
    Colors.redAccent.shade400,
    Colors.red,
    Colors.red.shade900,
    Colors.blue.shade100,
    Colors.blueAccent.shade400,
    Colors.blue,
    Colors.blue.shade900,
    Colors.green.shade100,
    Colors.greenAccent.shade400,
    Colors.green,
    Colors.green.shade900,
    Colors.pink.shade100,
    Colors.pinkAccent.shade400,
    Colors.pink,
    Colors.pink.shade900,
    Colors.purple.shade100,
    Colors.purple.shade400,
    Colors.purple,
    Colors.purple.shade900,
    Colors.grey.shade100,
    Colors.grey,
    Colors.grey.shade700,
    Colors.grey.shade900,
    Colors.cyan.shade100,
    Colors.cyan,
    Colors.cyan.shade700,
    Colors.cyan.shade900,
  ];
  List<Widget> list = [];

  @override
  Widget build(BuildContext context) {
    returnColors();
    return Scaffold(
        appBar: AppBar(
            title: const Text(""),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context, Colors.amber);
                })),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: list,
        ));
  }

  returnColors() {
    double width = 0.15;
    double height = 0.05;
    list = [];
    for (var i = 0; i < listColors.length; i = i + 4) {
      var row =
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        InkWell(
            onTap: retornaIconSelecionado(listColors[i]),
            child: Container(
                width: MediaQuery.of(context).size.width * width,
                height: MediaQuery.of(context).size.height * height,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    color: listColors[i]))),
        InkWell(
            onTap: retornaIconSelecionado(listColors[i + 1]),
            child: Container(
                width: MediaQuery.of(context).size.width * width,
                height: MediaQuery.of(context).size.height * height,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    color: listColors[i + 1]))),
        InkWell(
            onTap: retornaIconSelecionado(listColors[i + 2]),
            child: Container(
                width: MediaQuery.of(context).size.width * width,
                height: MediaQuery.of(context).size.height * height,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    color: listColors[i + 2]))),
        InkWell(
            onTap: retornaIconSelecionado(listColors[i + 3]),
            child: Container(
                width: MediaQuery.of(context).size.width * width,
                height: MediaQuery.of(context).size.height * height,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    color: listColors[i + 3]))),
      ]);
      list.add(row);
    }
  }

  Function()? retornaIconSelecionado(Color color) {
    return (() => {Navigator.pop(context, color)});
  }
}
