import 'package:tasks_manager_forcen/auth/login.dart';
import 'package:tasks_manager_forcen/auth/register.dart';
import 'package:tasks_manager_forcen/pages/dashboard_page.dart';
import 'package:tasks_manager_forcen/pages/home_page.dart';
import 'package:tasks_manager_forcen/pages/main_page.dart';
import 'package:tasks_manager_forcen/pages/profile/change_password_page.dart';
import 'package:tasks_manager_forcen/pages/profile/profile_edit_page.dart';
import 'package:tasks_manager_forcen/pages/profile/profile_page.dart';
import 'package:tasks_manager_forcen/pages/task/add_task_page.dart';
import 'package:tasks_manager_forcen/pages/task/completed_tasks_page.dart';
import 'package:tasks_manager_forcen/pages/task/uncompleted_tasks_page.dart';

import '../auth/password_reset.dart';
import '../pages/notification/notification_page.dart';
import '../pages/splash_screen_page.dart';
import '../pages/task/detail_task_page.dart';
import '../pages/task/edit_task_page.dart';
import '../pages/task/tasks_page.dart';

class AppRoutes {
  static const String splash = SplashScreenPage.routeName;
  static const String main = MainPage.routeName;
  static const String home = HomePage.routeName;
  static const String dashboard = DashboardPage.routeName;
  static const String login = LoginPage.routeName;
  static const String register = RegisterPage.routeName;
  static const String passwordReset = PasswordResetPage.routeName;
  static const String profile = ProfilePage.routeName;
  static const String profileEdit = ProfileEditPage.routeName;
  static const String changePassword = ChangePasswordPage.routeName;
  static const String tasks = TasksPage.routeName;
  static const String addTask = AddTaskPage.routeName;
  static const String detailTask = TaskDetailPage.routeName;
  static const String editTask = EditTaskPage.routeName;
  static const String completedTasks = CompletedTasksPage.routeName;
  static const String uncompletedTasks = UncompletedTasksPage.routeName;
  static const String notification = NotificationPage.routeName;
}