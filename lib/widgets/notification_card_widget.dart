import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(notification.title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        subtitle: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Priorité: ${notification.priority}', style: TextStyle(color: Colors.grey[600])),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Date: ${notification.date}', style: TextStyle(color: Colors.grey[600])),
                  Text('Heure: ${notification.time}', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ],
          ),
        ),
        leading: Icon(
          notification.priority == 'Haute' ? Icons.priority_high : Icons.notifications,
          color: notification.priority == 'Haute' ? Colors.red : Colors.blue,
        ),
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String priority;
  final String date;
  final String time;

  NotificationItem({
    required this.title,
    required this.priority,
    required this.date,
    required this.time,
  });
}