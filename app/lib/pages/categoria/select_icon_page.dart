import 'package:app/core/widgets/widget_ultil.dart';
import 'package:flutter/material.dart';

class SelectIconPage extends StatefulWidget {
  const SelectIconPage({super.key});

  @override
  State<SelectIconPage> createState() => _SelectIconPageState();
}

class _SelectIconPageState extends State<SelectIconPage> {
  var listIcons = [
    Icons.face_retouching_natural_sharp,
    Icons.handyman_outlined,
    Icons.account_balance_wallet_rounded,
    Icons.ad_units_rounded,
    Icons.account_balance_rounded,
    Icons.add_a_photo_rounded,
    Icons.favorite,
    Icons.add_shopping_cart_outlined,
    Icons.airport_shuttle_sharp,
    Icons.airline_seat_flat_sharp,
    Icons.home,
    Icons.photo_size_select_actual,
    Icons.gamepad,
    Icons.event_available_rounded,
    Icons.train_rounded,
    Icons.time_to_leave_sharp,
    Icons.airplanemode_active_outlined,
    Icons.add_card_sharp,
    Icons.card_giftcard_outlined,
    Icons.card_travel_rounded,
    Icons.apple_rounded,
    Icons.apartment_rounded,
    Icons.attach_money_rounded,
    Icons.attractions_rounded,
    Icons.local_movies,
    Icons.checkroom_rounded,
    Icons.downhill_skiing_rounded,
    Icons.dining_rounded,
  ];

  List<Widget> list = [];

  @override
  Widget build(BuildContext context) {
    returnIcons();
    return Scaffold(
        appBar: AppBar(
            title: const Text(""),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context, Icons.home);
                })),
        body: Column(
          children: list,
        ));
  }

  returnIcons() {
    double size = 40;
    list = [];
    for (var i = 0; i < listIcons.length; i = i + 4) {
      var row =
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        IconButton(
            onPressed: retornaIconSelecionado(listIcons[i]),
            icon: Icon(listIcons[i]),
            iconSize: size),
        IconButton(
            onPressed: retornaIconSelecionado(listIcons[i + 1]),
            icon: Icon(listIcons[i + 1]),
            iconSize: size),
        IconButton(
            onPressed: retornaIconSelecionado(listIcons[i + 2]),
            icon: Icon(listIcons[i + 2]),
            iconSize: size),
        IconButton(
            onPressed: retornaIconSelecionado(listIcons[i + 3]),
            icon: Icon(listIcons[i + 3]),
            iconSize: size)
      ]);
      list.add(row);
    }
  }

  Function()? retornaIconSelecionado(IconData icon) {
    return (() => {Navigator.pop(context, icon)});
  }
}
