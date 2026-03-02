import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/core/utils/theme/preferencia_tema.dart';
import 'package:organiza2/app/modules/usuario/presentation/controllers/usuario_controller.dart';
import 'package:organiza2/app/modules/navigation/presentation/widgets/drawer_header_widget.dart';
import 'package:organiza2/app/modules/navigation/presentation/widgets/drawer_item_widget.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String? _currentRoute;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute = ModalRoute.of(context)?.settings.name;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateTo(String route) {
    Navigator.pop(context); 
    
    // Só navega se não estiver na rota atual
    if (_currentRoute != route) {
      Modular.to.navigate(route);
    }
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedItem(Widget child, int index) {
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.1 * index,
          0.3 + (0.1 * index),
          curve: Curves.easeOut,
        ),
      ),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.2, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuarioController = Modular.get<UsuarioController>();
    final usuario = usuarioController.usuarioAtual.value;

    return Drawer(
      child: ValueListenableBuilder(
        valueListenable: PreferenciaTema.valueNotifier,
        builder: (context, value, _) {
          return Column(
            children: [
              // Header com informações do usuário
              if (usuario != null)
                DrawerHeaderWidget(usuario: usuario),

              // Lista de itens do menu
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 8),

                    // Seção Principal
                    _buildAnimatedItem(
                      DrawerItemWidget(
                        icon: Icons.account_balance_wallet,
                        title: 'Orçamentos',
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Implementar navegação quando módulo for criado
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Módulo de Orçamentos em desenvolvimento'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        isSelected: _currentRoute?.contains('orcamento') ?? false,
                      ),
                      0,
                    ),

                    _buildAnimatedItem(
                      DrawerItemWidget(
                        icon: Icons.flag,
                        title: 'Metas',
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Implementar navegação quando módulo for criado
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Módulo de Metas em desenvolvimento'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        isSelected: _currentRoute?.contains('metas') ?? false,
                      ),
                      1,
                    ),

                    _buildAnimatedItem(
                      DrawerItemWidget(
                        icon: Icons.category,
                        title: 'Categorias',
                        onTap: () => _navigateTo('/categoria/'),
                        isSelected: _currentRoute?.contains('categoria') ?? false,
                      ),
                      2,
                    ),

                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),

                    // Seção Secundária
                    _buildAnimatedItem(
                      DrawerItemWidget(
                        icon: Icons.help_outline,
                        title: 'Ajuda',
                        onTap: () {
                          Navigator.pop(context);
                          _showDialog(
                            context,
                            'Ajuda',
                            'Para suporte, entre em contato através do email: suporte@organiza.app',
                          );
                        },
                      ),
                      3,
                    ),

                    _buildAnimatedItem(
                      DrawerItemWidget(
                        icon: Icons.info_outline,
                        title: 'Sobre',
                        onTap: () {
                          Navigator.pop(context);
                          _showDialog(
                            context,
                            'Sobre o Organiza.',
                            'Organiza. v1.0.0\n\n'
                            'Aplicativo de gestão financeira pessoal com recursos de '
                            'compartilhamento de despesas.\n\n'
                            'Desenvolvido com Flutter.',
                          );
                        },
                      ),
                      4,
                    ),
                  ],
                ),
              ),

              // Footer com versão
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Organiza. v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
