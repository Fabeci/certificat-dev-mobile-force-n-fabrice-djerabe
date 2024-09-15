import 'package:flutter/material.dart';
import 'package:tasks_manager_forcen/api/repository/auth_repository.dart';
import 'package:tasks_manager_forcen/auth/login.dart';
import 'package:tasks_manager_forcen/utils/session_manager.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AuthRepository authRepository;
  const CustomAppBar({super.key, required this.authRepository});

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      final SessionManager sessionManager = SessionManager();
      await sessionManager.clearUserSession();

      // Naviguez vers la page de connexion
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );

      // Affichez un message de déconnexion réussie
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Déconnexion réussie.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: 0, left: 10, right: 10),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la déconnexion.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      title: const Text("TaskApp"),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onPressed: () => _handleSignOut(context),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
