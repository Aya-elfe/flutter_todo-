// File: lib/widgets/task/task_list_view.dart
/*import 'package:flutter/material.dart';
import '../../screens/home/home_screen.dart';
import '../../models/task.dart';
import 'task_list_item.dart';
import '../common/empty_state.dart';
import 'package:dart_date/dart_date.dart';


class TaskListView extends StatelessWidget {
  final List<Task> tasks;
  final void Function(Task) onTaskTap;
  final void Function(Task, bool)? onStatusChanged;
  final ScrollController? scrollController;
  final bool showCategories;
  final bool groupByDate;
  final Widget? emptyWidget;

  const TaskListView({
    super.key,
    required this.tasks,
    required this.onTaskTap,
    this.onStatusChanged,
    this.scrollController,
    this.showCategories = true,
    this.groupByDate = true,
    this.emptyWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return emptyWidget ?? const EmptyState(
        icon: Icons.task_outlined,
        title: 'No Tasks',
        subtitle: 'Add some tasks to get started',
      );
    }

    if (!groupByDate) {
      return ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) => TaskListItem(
          task: tasks[index],
          onTap: () => onTaskTap(tasks[index]),
          onStatusChanged: onStatusChanged != null 
            ? (value) => onStatusChanged!(tasks[index], value)
            : null,
          showCategory: showCategories,
        ),
      );
    }

    // Group tasks by date
    final groupedTasks = <DateTime, List<Task>>{};
    for (final task in tasks) {
      final date = DateTime(
        task.dueDate.year,
        task.dueDate.month,
        task.dueDate.day,
      );
      groupedTasks[date] = [...(groupedTasks[date] ?? []), task];
    }

    final sortedDates = groupedTasks.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final tasksForDate = groupedTasks[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: 16),
            Text(
              _formatDateHeader(date),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            ...tasksForDate.map((task) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TaskListItem(
                task: task,
                onTap: () => onTaskTap(task),
                onStatusChanged: onStatusChanged != null 
                  ? (value) => onStatusChanged!(task, value)
                  : null,
                showCategory: showCategories,
              ),
            )),
          ],
        );
      },
    );
  }

  String _formatDateHeader(DateTime date) {
    if (date.isToday()) {
      return 'Today';
    } else if (date.isTomorrow()) {
      return 'Tomorrow';
    }

    final now = DateTime.now();
    final difference = date.difference(DateTime(now.year, now.month, now.day)).inDays;

    if (difference < 7) {
      final weekday = date.weekday;
      switch (weekday) {
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
          return '';
      }
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}
// Update the _formatDate method to use the extension:
String _formatDate(DateTime date) {
  return date.toFriendlyDate();
}*/

// File: lib/widgets/task/task_list_view.dart
import 'package:flutter/material.dart';
import '../../models/task.dart';
import 'task_list_item.dart';
import '../common/empty_state.dart';

class TaskListView extends StatelessWidget {
  final List<Task> tasks;
  final void Function(Task) onTaskTap;
  final void Function(Task, bool)? onStatusChanged;
  final ScrollController? scrollController;
  final bool showCategories;
  final bool groupByDate;
  final Widget? emptyWidget;

  const TaskListView({
    super.key,
    required this.tasks,
    required this.onTaskTap,
    this.onStatusChanged,
    this.scrollController,
    this.showCategories = true,
    this.groupByDate = true,
    this.emptyWidget,
  });

  String _toFriendlyDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));

    if (date.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (date.isAtSameMomentAs(tomorrow)) {
      return 'Tomorrow';
    } else {
      // Format as needed, e.g., 'dd/MM/yyyy'
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return emptyWidget ??
          const EmptyState(
            icon: Icons.task_outlined,
            title: 'No Tasks',
            subtitle: 'Add some tasks to get started',
          );
    }

    if (!groupByDate) {
      return ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) => TaskListItem(
          task: tasks[index],
          onTap: () => onTaskTap(tasks[index]),
          onStatusChanged: onStatusChanged != null
              ? (value) => onStatusChanged!(tasks[index], value)
              : null,
          showCategory: showCategories,
        ),
      );
    }

    

    // Group tasks by date
    final groupedTasks = <DateTime, List<Task>>{};
    for (final task in tasks) {
      final date = DateTime(
        task.dueDate.year,
        task.dueDate.month,
        task.dueDate.day,
      );
      groupedTasks[date] = [...(groupedTasks[date] ?? []), task];
    }

    final sortedDates = groupedTasks.keys.toList()..sort((a, b) => a.compareTo(b));

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final tasksForDate = groupedTasks[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: 16),
            Text(
              _toFriendlyDate(date),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            ...tasksForDate.map(
              (task) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TaskListItem(
                  task: task,
                  onTap: () => onTaskTap(task),
                  onStatusChanged: onStatusChanged != null
                      ? (value) => onStatusChanged!(task, value)
                      : null,
                  showCategory: showCategories,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
