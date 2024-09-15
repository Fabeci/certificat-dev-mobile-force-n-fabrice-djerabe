import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../widgets/notification_card_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  static const String routeName = '/notification';

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Tâche urgente',
      priority: 'Haute',
      date: '2024-07-21',
      time: '14:00',
    ),
    NotificationItem(
      title: 'Tâche importante',
      priority: 'Moyenne',
      date: '2024-07-22',
      time: '09:30',
    ),
    NotificationItem(
      title: 'Tâche à faire',
      priority: 'Basse',
      date: '2024-07-23',
      time: '16:00',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        foregroundColor: Colors.white,
        title: Text('Notifications des Tâches'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationCard(notification: notification);
        },
      ),
    );
  }
}