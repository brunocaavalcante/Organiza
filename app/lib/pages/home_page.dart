import 'package:app/pages/operacao/home_despesa_page.dart';
import 'package:app/pages/reports/home_reports_page.dart';
import 'package:app/pages/settings/settings_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

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
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.background,
      animationDuration: const Duration(milliseconds: 300),
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        Icon(
          Icons.home,
          color: Theme.of(context).colorScheme.background,
        ),
        Icon(
          Icons.incomplete_circle_sharp,
          color: Theme.of(context).colorScheme.background,
        ),
        Icon(Icons.settings, color: Theme.of(context).colorScheme.background),
      ],
    );
  }

  returnView() {
    telas = [];
    telas.add(const HomeDespesaPage());
    telas.add(const HomeReportPage());
    telas.add(const SettingsPage());
    return telas[_currentIndex];
  }
}
