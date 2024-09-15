import 'package:flutter/material.dart';
import 'package:tasks_manager_forcen/constants/app_colors.dart';

class DrawerItems extends StatelessWidget {
  const DrawerItems({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedColor: AppColors.kPrimaryColor,
      title: Text(
        title,
        style: const TextStyle(
          //color: Colors.black,
          fontSize: 18,
        ),
      ),
      leading: Icon(
        icon,
        //color: const Color(0xff7592B6),
      ),
      onTap: onTap,
    );
  }
}
