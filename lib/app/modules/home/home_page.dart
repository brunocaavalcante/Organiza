import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:organiza2/app/modules/operacao/views/aprovacao_opercao_page.dart';
import 'package:organiza2/app/modules/operacao/views/home_despesa_page.dart';
import 'package:organiza2/app/modules/reports/home_reports_page.dart';
import 'package:organiza2/app/modules/usuario/presentation/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> telas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: returnView(), bottomNavigationBar: returnNavigatorBarBottom());
  }

  returnNavigatorBarBottom() {
    return CurvedNavigationBar(
      height: 60,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      animationDuration: const Duration(milliseconds: 300),
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        Icon(Icons.home, color: Theme.of(context).colorScheme.surface),
        Icon(
          Icons.access_time_filled_sharp,
          color: Theme.of(context).colorScheme.surface,
        ),
        Icon(
          Icons.incomplete_circle_sharp,
          color: Theme.of(context).colorScheme.surface,
        ),
        Icon(Icons.settings, color: Theme.of(context).colorScheme.surface),
      ],
    );
  }

  returnView() {
    telas = [];
    telas.add(const HomeDespesaPage());
    telas.add(const AprovacaoOperacao());
    telas.add(const HomeReportPage());
    telas.add(const SettingsPage());
    return telas[_currentIndex];
  }
}
