import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks_manager_forcen/api/blocs/user_profile_bloc.dart';
import 'package:tasks_manager_forcen/api/repository/profile_repository.dart';
import 'package:tasks_manager_forcen/pages/dashboard_page.dart';
import 'package:tasks_manager_forcen/pages/home_page.dart';
import 'package:tasks_manager_forcen/pages/main_page.dart';
import 'package:tasks_manager_forcen/pages/notification/notification_page.dart';
import 'package:tasks_manager_forcen/pages/profile/change_password_page.dart';
import 'package:tasks_manager_forcen/pages/profile/profile_edit_page.dart';
import 'package:tasks_manager_forcen/pages/profile/profile_page.dart';
import 'package:tasks_manager_forcen/pages/splash_screen_page.dart';
import 'package:tasks_manager_forcen/pages/task/add_task_page.dart';
import 'package:tasks_manager_forcen/pages/task/completed_tasks_page.dart';
import 'package:tasks_manager_forcen/pages/task/tasks_page.dart';
import 'package:tasks_manager_forcen/pages/task/uncompleted_tasks_page.dart';
import 'package:tasks_manager_forcen/routes/app_routes.dart';
import 'package:tasks_manager_forcen/utils/session_manager.dart';

import 'api/blocs/sign_in_bloc.dart';
import 'api/blocs/task_bloc.dart';
import 'api/blocs/user_bloc.dart';
import 'api/blocs/user_event.dart';
import 'api/repository/auth_repository.dart';
import 'api/repository/task_repository.dart';
import 'api/repository/user_repository.dart';
import 'auth/login.dart';
import 'auth/password_reset.dart';
import 'auth/register.dart';
import 'constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SessionManager sessionManager = SessionManager();
  final String? accessToken = await sessionManager.getAccessToken();
  final UserRepository userRepository = UserRepository();
  final TaskRepository taskRepository =
      TaskRepository(accessToken: accessToken ?? '');

  if (accessToken != null) {
    try {
      final userProfile = await userRepository.fetchUserProfile(accessToken);
      print('User Profile: $userProfile');
      final String nom = userProfile.nom;
      final String prenom = userProfile.prenom;
      final String email = userProfile.email;
      final String username = userProfile.username!;
      sessionManager.saveUserSession(
          token: accessToken,
          email: email,
          nom: nom,
          prenom: prenom,
          username: username);
      print('Firstname: $nom, Email: $email, Lastname: $prenom');
    } catch (e) {
      print('Failed to fetch user profile: $e');
    }
  }

  runApp(MyApp(
    userRepository: userRepository,
    taskRepository: taskRepository,
    accessToken: accessToken,
  ));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final TaskRepository taskRepository;
  final String? accessToken;

  const MyApp({
    Key? key,
    required this.userRepository,
    required this.taskRepository,
    this.accessToken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileBloc(
              profileRepository:
                  ProfileRepository(accessToken: accessToken ?? '')),
        ),
        BlocProvider(
          create: (context) => UserBloc(userRepository: userRepository)
            ..add(LoadUser(accessToken ?? '')),
        ),
        BlocProvider(
          create: (context) => TaskBloc(taskRepository: taskRepository),
        ),
        BlocProvider(
          create: (context) => SignInBloc(authRepository: AuthRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.kPrimaryColor,
          useMaterial3: true,
        ),
        initialRoute: accessToken == null ? AppRoutes.login : AppRoutes.splash,
        routes: {
          AppRoutes.splash: (context) => const SplashScreenPage(),
          AppRoutes.main: (context) => const MainPage(),
          AppRoutes.home: (context) => const HomePage(),
          AppRoutes.dashboard: (context) => DashboardPage(),
          AppRoutes.login: (context) => const LoginPage(),
          AppRoutes.register: (context) => const RegisterPage(),
          AppRoutes.profile: (context) => const ProfilePage(),
          AppRoutes.profileEdit: (context) => const ProfileEditPage(),
          AppRoutes.passwordReset: (context) => const PasswordResetPage(),
          AppRoutes.changePassword: (context) => const ChangePasswordPage(),
          AppRoutes.tasks: (context) => const TasksPage(),
          AppRoutes.addTask: (context) => const AddTaskPage(),
          AppRoutes.uncompletedTasks: (context) => const UncompletedTasksPage(),
          AppRoutes.completedTasks: (context) => const CompletedTasksPage(),
          AppRoutes.notification: (context) => const NotificationPage(),
        },
      ),
    );
  }
}
