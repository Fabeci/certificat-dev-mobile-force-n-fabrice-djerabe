import 'package:equatable/equatable.dart';

class TaskModel extends Equatable{
  final int? id;
  final String title;
  final String content;
  final String priority;
  final String color;
  final DateTime dueDate;
  final DateTime createdAt;

  const TaskModel({
    this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.color,
    required this.dueDate,
    required this.createdAt
  });

  @override
  List<Object> get props => [id!, title, content, dueDate, priority, color, createdAt];

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      priority: json['priority'],
      color: json['color'],
      dueDate: DateTime.parse(json['dueDate']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'priority': priority,
      'color': color,
      'dueDate': dueDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
