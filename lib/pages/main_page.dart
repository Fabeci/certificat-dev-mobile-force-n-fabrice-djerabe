import 'package:flutter/material.dart';
import 'package:tasks_manager_forcen/api/models/profile_model.dart';
import 'package:tasks_manager_forcen/api/repository/auth_repository.dart';
import 'package:tasks_manager_forcen/api/repository/profile_repository.dart';
import 'package:tasks_manager_forcen/api/repository/user_repository.dart';
import 'package:tasks_manager_forcen/constants/app_colors.dart';
import 'package:tasks_manager_forcen/widgets/app_bar.dart';
import 'package:tasks_manager_forcen/widgets/app_drawer.dart';
import 'profile/profile_page.dart';
import 'task/tasks_page.dart';
import '../utils/session_manager.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static const String routeName = '/main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  late final SessionManager sessionManager;
  ProfileModel? _user;

  final _pages = [
    const TasksPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    sessionManager = SessionManager();
    _checkSession();
    _loadUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final String? accessToken = await sessionManager.getAccessToken();
      final ProfileRepository profileRepository =
          ProfileRepository(accessToken: accessToken!);
      ProfileModel user = await profileRepository.fetchProfile();
      sessionManager.saveUserSession(
          token: accessToken,
          nom: user.nom,
          prenom: user.prenom,
          email: user.email,
          username: user.username!);

      if (mounted) {
        setState(() {
          _user = user;
        });
      }
    } catch (e) {
      // Gérer les erreurs ici
      print('Erreur lors du chargement des données utilisateur: $e');
    }
  }

  Future<void> _checkSession() async {
    final token = await sessionManager.getAccessToken();
    if (token == null) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();

    return Scaffold(
      appBar: CustomAppBar(authRepository: authRepository),
      backgroundColor: const Color(0xffE8E7E7),
      drawer: const AppDrawer(),
      bottomNavigationBar: BottomNavigationBarTheme(
        data: const BottomNavigationBarThemeData(
            selectedItemColor: AppColors.kPrimaryColor,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold)),
        child: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          currentIndex: selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_sharp),
              label: 'My Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : _pages[selectedIndex],
    );
  }
}
