import 'package:flutter/material.dart';
import 'package:tasks_manager_forcen/auth/login.dart';
import 'package:tasks_manager_forcen/auth/password_reset.dart';
import 'package:tasks_manager_forcen/auth/register.dart';
import 'package:tasks_manager_forcen/pages/dashboard_page.dart';
import 'package:tasks_manager_forcen/pages/home_page.dart';
import 'package:tasks_manager_forcen/pages/main_page.dart';
import 'package:tasks_manager_forcen/pages/notification/notification_page.dart';
import 'package:tasks_manager_forcen/pages/profile/change_password_page.dart';
import 'package:tasks_manager_forcen/pages/profile/profile_edit_page.dart';
import 'package:tasks_manager_forcen/pages/profile/profile_page.dart';
import 'package:tasks_manager_forcen/pages/task/add_task_page.dart';
import 'package:tasks_manager_forcen/pages/task/completed_tasks_page.dart';
import 'package:tasks_manager_forcen/pages/task/tasks_page.dart';
import '../constants/app_colors.dart';
import '../pages/splash_screen_page.dart';
import '../pages/task/uncompleted_tasks_page.dart';
import 'app_routes.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.kPrimaryColor,
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade800),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
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
        // AppRoutes.detailTask : (context) => const TaskDetailPage(),
        // AppRoutes.editTask : (context) => const EditTaskPage(title: '', description: '', date: DateTime.timestamp, time: 'null', priority: '',)
      },
      initialRoute: "/splash",
    );
  }
}
