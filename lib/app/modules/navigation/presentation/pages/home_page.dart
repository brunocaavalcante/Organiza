import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/modules/navigation/presentation/controllers/navigation_controller.dart';
import 'package:organiza2/app/modules/navigation/presentation/widgets/app_drawer.dart';
import 'package:organiza2/app/modules/operacao/presentation/pages/aprovacao_opercao_page.dart';
import 'package:organiza2/app/modules/operacao/presentation/pages/home_despesa_page.dart';
import 'package:organiza2/app/modules/reports/home_reports_page.dart';
import 'package:organiza2/app/modules/usuario/presentation/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NavigationController _navigationController;
  late final List<Widget> _telas;

  @override
  void initState() {
    super.initState();
    _navigationController = Modular.get<NavigationController>();
    _telas = [
      const HomeDespesaPage(),
      const AprovacaoOperacao(),
      const HomeReportPage(),
      const SettingsPage(),
    ];
    _navigationController.addListener(_onNavigationChanged);
  }

  @override
  void dispose() {
    _navigationController.removeListener(_onNavigationChanged);
    super.dispose();
  }

  void _onNavigationChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: HomePage.scaffoldKey,
      drawer: const AppDrawer(),
      body: _telas[_navigationController.currentTabIndex],
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildNavigationBar() {
    return CurvedNavigationBar(
      height: 60,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      animationDuration: const Duration(milliseconds: 300),
      index: _navigationController.currentTabIndex,
      onTap: (index) {
        _navigationController.changeTab(index);
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
}
