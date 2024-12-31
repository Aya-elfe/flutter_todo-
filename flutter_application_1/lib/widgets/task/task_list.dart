import 'package:flutter/material.dart';
import '../../models/task.dart';
import 'task_card.dart';

class TaskListView extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task, TaskStatus) onStatusChanged;
  final Function(int) onDelete; // Updated to pass task ID (int)
  final bool groupByDate;
  final ScrollController? scrollController;

  const TaskListView({
    super.key,
    required this.tasks,
    required this.onStatusChanged,
    required this.onDelete,
    this.groupByDate = true,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return _buildEmptyState();
    }

    if (!groupByDate) {
      return ListView.builder(
        controller: scrollController,
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskCard(
            task: tasks[index],
            onStatusChanged: (status) => onStatusChanged(tasks[index], status),
            onDelete: () => onDelete(tasks[index].id!), // Pass task ID
          );
        },
      );
    }

    // Group tasks by date
    final groupedTasks = <DateTime, List<Task>>{};
    for (final task in tasks) {
      final date = DateTime(
        task.dateTime.year,
        task.dateTime.month,
        task.dateTime.day,
      );
      if (!groupedTasks.containsKey(date)) {
        groupedTasks[date] = [];
      }
      groupedTasks[date]!.add(task);
    }

    final sortedDates = groupedTasks.keys.toList()..sort();

    return ListView.builder(
      controller: scrollController,
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final tasksForDate = groupedTasks[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _formatDate(date),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...tasksForDate.map((task) => TaskCard(
              task: task,
              onStatusChanged: (status) => onStatusChanged(task, status),
              onDelete: () => onDelete(task.id!), // Pass task ID
            )),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add some tasks to get started',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

    String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) {
      return 'Today';
    } else if (date == tomorrow) {
      return 'Tomorrow';
    } else if (date == yesterday) {
      return 'Yesterday';
    } else if (date.isAfter(today.subtract(const Duration(days: 7)))) {
      // Within last week, show day name
      switch (date.weekday) {
        case 1:
          return 'Monday';
        case 2:
          return 'Tuesday';
        case 3:
          return 'Wednesday';
        case 4:
          return 'Thursday';
        case 5:
          return 'Friday';
        case 6:
          return 'Saturday';
        case 7:
          return 'Sunday';
        default:
          return '${date.day}/${date.month}/${date.year}';
      }
    } else {
      // More than a week ago, show full date
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// A list tile specifically designed for tasks
class TaskListTile extends StatelessWidget {
  final Task task;
  final Function(TaskStatus) onStatusChanged;
  final VoidCallback onDelete;
  final bool showCategory;

  const TaskListTile({
    super.key,
    required this.task,
    required this.onStatusChanged,
    required this.onDelete,
    this.showCategory = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(
          task.status == TaskStatus.COMPLETED
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          color: task.status == TaskStatus.COMPLETED
              ? Colors.green
              : Colors.grey,
        ),
        onPressed: () {
          onStatusChanged(
            task.status == TaskStatus.COMPLETED
                ? TaskStatus.TODO
                : TaskStatus.COMPLETED,
          );
        },
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.status == TaskStatus.COMPLETED
              ? TextDecoration.lineThrough
              : null,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (task.description.isNotEmpty)
            Text(
              task.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                decoration: task.status == TaskStatus.COMPLETED
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          Row(
            children: [
              if (showCategory) ...[
                _CategoryChip(category: task.category),
                const SizedBox(width: 8),
              ],
              Icon(
                Icons.access_time,
                size: 12,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                _formatTime(task.dateTime),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        onSelected: (value) {
          switch (value) {
            case 'delete':
              onDelete();
              break;
            case 'edit':
              // TODO: Implement edit functionality
              break;
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Text('Edit'),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _CategoryChip extends StatelessWidget {
  final TaskCategory category;

  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getCategoryColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _getCategoryName(),
        style: TextStyle(
          fontSize: 10,
          color: _getCategoryColor(),
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    switch (category) {
      case TaskCategory.work:
        return Colors.blue;
      case TaskCategory.personal:
        return Colors.purple;
      case TaskCategory.shopping:
        return Colors.green;
      case TaskCategory.health:
        return Colors.red;
      case TaskCategory.home:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getCategoryName() {
    return category.toString().split('.').last;
  }
}