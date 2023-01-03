import 'package:flutter/material.dart';

class HomeDespesaPage extends StatefulWidget {
  const HomeDespesaPage({super.key});

  @override
  State<HomeDespesaPage> createState() => _HomeDespesaPageState();
}

class _HomeDespesaPageState extends State<HomeDespesaPage> {
  var height;
  var width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: body(),
    );
  }

  body() {
    return Column(
      children: [containerTop()],
    );
  }

  containerTop() {
    return Container(
      width: width,
      height: height * 0.33,
      padding: EdgeInsets.only(top: height * 0.05),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(60.0),
            bottomRight: Radius.circular(60.0),
          )),
      child: Column(children: [
        Text("Janeiro 2023",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        SizedBox(height: height * 0.03),
        Text("Total do mês",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        SizedBox(height: height * 0.01),
        Text("RS 2.083,34",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 23,
                fontWeight: FontWeight.bold)),
      ]),
    );
  }
}
