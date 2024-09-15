import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isCompleted; // Exemple de champ pour indiquer si la tâche est terminée ou non

  const TaskCard({
    required this.title,
    required this.description,
    this.isCompleted = false, // Par défaut, la tâche n'est pas terminée
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isCompleted ? Colors.grey : Colors.black,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: isCompleted ? Colors.grey : Colors.black54,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Checkbox(
          value: isCompleted,
          onChanged: (newValue) {
            // Logique pour marquer la tâche comme terminée ou non
            // Par exemple, mettre à jour l'état dans une liste ou une base de données
          },
        ),
      ),
    );
  }
}
