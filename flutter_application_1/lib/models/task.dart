import 'package:flutter/material.dart';

enum TaskCategory {
  grocery,
  work,
  sport,
  design,
  university,
  social,
  music,
  health,
  movie,
  home,
  personal,
  other,
  shopping,
}

enum TaskPriority { HIGH, MEDIUM, LOW }

enum TaskStatus { TODO, IN_PROGRESS, COMPLETED }
class Task {
  final int? id;
  final String title;
  final String description;
  final TaskCategory category;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime dateTime;
  final DateTime dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int userId;
  final int? categoryId;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    this.status = TaskStatus.TODO,
    required this.dateTime,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.categoryId,
  });

factory Task.fromJson(Map<String, dynamic> json) {
  return Task(
    id: json['id'] as int?, // Use casting with null-safety
    title: json['title'] as String? ?? 'Untitled', 
    description: json['description'] as String? ?? 'No description provided',
    category: TaskCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == (json['category'] as String?)?.toLowerCase(),
      orElse: () => TaskCategory.other, 
    ),
    priority: TaskPriority.values.firstWhere(
      (e) => e.name.toLowerCase() == (json['priority'] as String?)?.toLowerCase(),
      orElse: () => TaskPriority.MEDIUM,
    ),
    status: TaskStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == (json['status'] as String?)?.toLowerCase(),
      orElse: () => TaskStatus.TODO,
    ),
  dateTime: json['dateTime'] != null
        ? DateTime.parse(json['dateTime'] as String)
        : DateTime.now(),
    dueDate: json['dueDate'] != null
        ? DateTime.parse(json['dueDate'] as String)
        : DateTime.now(),
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : DateTime.now(),
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'] as String)
        : DateTime.now(),
    userId: json['userId'] as int? ?? 0,
    categoryId: json['categoryId'] as int?,
  );
}
  Map<String, dynamic> toJson({bool forCreate = false}) {
    final map = {
      'title': title,
      'description': description,
      'category': category.toString().split('.').last.toUpperCase(),
      'priority': priority.toString().split('.').last,
      'status': status.toString().split('.').last,
      'dateTime': dateTime.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
      'categoryId': categoryId,
    };

    if (!forCreate && id != null) {
      map['id'] = id;
    }

    return map;
  }

  Map<String, dynamic> toJsonForCreate() {
    return toJson(forCreate: true);
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    TaskCategory? category,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? dateTime,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? userId,
    int? categoryId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dateTime: dateTime ?? this.dateTime,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
