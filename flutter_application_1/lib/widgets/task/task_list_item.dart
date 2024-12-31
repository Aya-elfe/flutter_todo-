// File: lib/widgets/task/task_list_item.dart
import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../config/theme.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final ValueChanged<bool>? onStatusChanged;
  final bool showCategory;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onTap,
    this.onStatusChanged,
    this.showCategory = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              if (onStatusChanged != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: task.status == TaskStatus.COMPLETED,
                      onChanged: (value) {
                        if (value != null) {
                          onStatusChanged!(value);
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: task.status == TaskStatus.COMPLETED
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (task.priority == TaskPriority.HIGH)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.priority_high,
                              color: Colors.red[700],
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          decoration: task.status == TaskStatus.COMPLETED
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (showCategory) ...[
                          _CategoryChip(category: task.category),
                          const SizedBox(width: 8),
                        ],
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(task.dueDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _CategoryChip extends StatelessWidget {
  final TaskCategory category;

  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getCategoryColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getCategoryName(),
        style: TextStyle(
          fontSize: 12,
          color: _getCategoryColor(),
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    switch (category) {
      case TaskCategory.grocery:
        return Colors.green;
      case TaskCategory.work:
        return Colors.orange;
      case TaskCategory.sport:
        return Colors.blue;
      case TaskCategory.design:
        return Colors.purple;
      case TaskCategory.university:
        return AppTheme.primaryColor;
      case TaskCategory.social:
        return Colors.pink;
      case TaskCategory.music:
        return Colors.red;
      case TaskCategory.health:
        return Colors.teal;
      case TaskCategory.movie:
        return Colors.indigo;
      case TaskCategory.home:
        return Colors.brown;
      case TaskCategory.personal:
        return Colors.grey.shade300;
      case TaskCategory.shopping:
        return Colors.lightGreen;
      case TaskCategory.other:
        return Colors.grey;
    }
  }

  String _getCategoryName() {
    return category.toString().split('.').last;
  }
}