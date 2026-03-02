import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/modules/usuario/domain/entities/usuario.dart';
import 'package:organiza2/app/modules/navigation/presentation/controllers/navigation_controller.dart';

class DrawerHeaderWidget extends StatelessWidget {
  final Usuario usuario;

  const DrawerHeaderWidget({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.secondary,
          ],
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          final navController = Modular.get<NavigationController>();
          navController.changeTab(3);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Hero(
                tag: 'user-avatar',
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.onPrimary,
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: colorScheme.surface,
                    backgroundImage: usuario.hasPhoto()
                        ? NetworkImage(usuario.photoUrl)
                        : null,
                    child: !usuario.hasPhoto()
                        ? Icon(
                            Icons.person,
                            size: 32,
                            color: colorScheme.primary,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Textos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Nome
                    Text(
                      usuario.name.isNotEmpty ? usuario.name : 'Usuário',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Email
                    Text(
                      usuario.email,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onPrimary.withOpacity(0.9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
