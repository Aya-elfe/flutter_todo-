package com.example.demo.service;

import com.example.demo.dto.TaskDTO;
import com.example.demo.entity.Task;
import com.example.demo.entity.User;
import com.example.demo.entity.Category; // Assuming Category is an entity
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.TaskRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.repository.CategoryRepository;
import com.example.demo.enums.TaskPriority;
import com.example.demo.enums.TaskStatus;
import com.example.demo.mapper.TaskMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class TaskService {

	@Autowired
    private final TaskRepository taskRepository;
	@Autowired
    private final UserRepository userRepository;
	@Autowired
    private final CategoryRepository categoryRepository;

    public TaskService(TaskRepository taskRepository, UserRepository userRepository, CategoryRepository categoryRepository) {
        this.taskRepository = taskRepository;
        this.userRepository = userRepository;
        this.categoryRepository = categoryRepository;
    }

    // Create or update a task
    public Task saveTask(Task task) {
        validateTask(task);

        // Fetch user and category if they're not already set
        if (task.getUser() == null) {
            throw new IllegalArgumentException("Task must be associated with a valid user ID");
        }

        if (task.getCategory() == null) {
            throw new IllegalArgumentException("Task must be associated with a valid category ID");
        }

        // Validate and set the user and category entities
        User user = userRepository.findById(task.getUser().getId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        task.setUser(user);

        Category category = categoryRepository.findById(task.getCategory().getId())
                .orElseThrow(() -> new IllegalArgumentException("Category not found"));
        task.setCategory(category);

        // Set default values if necessary
        if (task.getPriority() == null) {
            task.setPriority(TaskPriority.MEDIUM); // Default priority
        }

        if (task.getStatus() == null) {
            task.setStatus(TaskStatus.TODO); // Default status
        }

        // Save the task to the repository
        return taskRepository.save(task);
    }

    // Validate task details before saving
    private void validateTask(Task task) {
        if (task.getTitle() == null || task.getTitle().isEmpty()) {
            throw new IllegalArgumentException("Title cannot be null or empty");
        }
    }

    // Find a task by ID
    public Optional<TaskDTO> findTaskById(Long id) {
        Optional<Task> task = taskRepository.findById(id);
        return task.map(TaskMapper::toDTO);
    }

    // Get all tasks
    public List<TaskDTO> getAllTasks() {
        return taskRepository.findAll().stream()
                .map(TaskMapper::toDTO)
                .collect(Collectors.toList());
    }

    // Get tasks by status
    public List<TaskDTO> getTasksByStatus(TaskStatus status) {
        return taskRepository.findByStatus(status).stream()
                .map(TaskMapper::toDTO)
                .collect(Collectors.toList());
    }

    // Get tasks by priority
    public List<TaskDTO> getTasksByPriority(TaskPriority priority) {
        return taskRepository.findByPriority(priority).stream()
                .map(TaskMapper::toDTO)
                .collect(Collectors.toList());
    }

    // Delete a task
    public void deleteTask(Long id) {
        if (!taskRepository.existsById(id)) {
            throw new IllegalArgumentException("Task not found");
        }
        taskRepository.deleteById(id);
    }
    public List<TaskDTO> getTasksByUserId(Long userId) {
        return taskRepository.findByUserId(userId)
                .stream()
                .map(TaskMapper::toDTO)
                .collect(Collectors.toList());
    }

    public Optional<Task> getTaskById(Long id) {
        return taskRepository.findById(id);
    }

}

