
/*class MockDataService {

  static final List<Task> _mockTasks = [
    Task(
      id: '1',
      title: 'Complete Project Proposal',
      description: 'Write and submit the Q4 project proposal document',
      priority: TaskPriority.HIGH,
      status: TaskStatus.TODO,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: '1',
      categoryId: '1',
    ),
    Task(
      id: '2',
      title: 'Gym Session',
      description: 'Weekly workout routine',
      priority: TaskPriority.MEDIUM,
      status: TaskStatus.TODO,
      dueDate: DateTime.now().add(const Duration(hours: 3)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: '1',
      categoryId: '2',
    ),
    Task(
      id: '3',
      title: 'Buy Groceries',
      description: 'Get weekly groceries and household items',
      priority: TaskPriority.LOW,
      status: TaskStatus.COMPLETED,
      dueDate: DateTime.now().subtract(const Duration(hours: 2)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: '1',
      categoryId: '3',
    ),
  ];

  // Simulate API delay
  Future<T> _mockDelay<T>(T data) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return data;
  }

  Future<List<Task>> getTasks() async {
    return _mockDelay(_mockTasks);
  }

  Future<Task> createTask(Task task) async {
    final newTask = task.copyWith(
      id: ((_mockTasks.length + 1).toString()),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _mockTasks.add(newTask);
    return _mockDelay(newTask);
  }

  Future<Task> updateTask(Task task) async {
    final index = _mockTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _mockTasks[index] = task.copyWith(updatedAt: DateTime.now());
      return _mockDelay(_mockTasks[index]);
    }
    throw Exception('Task not found');
  }

  Future<void> deleteTask(String taskId) async {
    _mockTasks.removeWhere((task) => task.id == taskId);
    return _mockDelay(null);
  }
}*/