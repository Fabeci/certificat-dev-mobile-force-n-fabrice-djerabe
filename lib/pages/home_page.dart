import 'package:flutter/material.dart';
import 'package:tasks_manager_forcen/api/repository/auth_repository.dart';
import 'package:tasks_manager_forcen/widgets/app_bar.dart';

import '../constants/app_style.dart';
import '../widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();
    return Scaffold(
      appBar: CustomAppBar(
        authRepository: authRepository,
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Text(
                'Home',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff112255),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Welcome to your task management system',
                style: AppStyle.textStyle,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'This system help you to be motivated and realist in you everyday tasks. Every one must try to be organised',
                style: AppStyle.textStyle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10),
              child: Image.asset(
                'assets/images/image.png',
                fit: BoxFit.contain,
              ),
            )
          ],
        ),
      ),
    );
  }
}
