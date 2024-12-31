package com.example.demo.controller;

import com.example.demo.dto.TaskDTO;
import com.example.demo.entity.Task;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.service.TaskService;
import com.example.demo.enums.TaskPriority;
import com.example.demo.enums.TaskStatus;
import com.example.demo.mapper.TaskMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/tasks")
public class TaskController {

    @Autowired
    private final TaskService taskService;

    public TaskController(TaskService taskService) {
        this.taskService = taskService;
    }

    // old Endpoint to create or update a task

    @PostMapping
    public ResponseEntity<TaskDTO> createTask(@RequestBody TaskDTO taskDTO) {
        // Use TaskMapper to convert DTO to entity
        Task task = TaskMapper.toEntity(taskDTO);

        // Save the task using TaskService
        Task savedTask = taskService.saveTask(task);

        // Convert the saved Task entity back to TaskDTO
        TaskDTO savedTaskDTO = TaskMapper.toDTO(savedTask);

        return ResponseEntity.ok(savedTaskDTO);  // Return the saved TaskDTO
    }



    // Endpoint to get all tasks
    @GetMapping
    public List<TaskDTO> getAllTasks() {
        return taskService.getAllTasks();
    }

    // Endpoint to get tasks by status
    @GetMapping("/status/{status}")
    public ResponseEntity<List<TaskDTO>> getTasksByStatus(@PathVariable String status) {
        try {
            TaskStatus taskStatus = TaskStatus.valueOf(status.toUpperCase()); // Convert String to TaskStatus enum
            List<TaskDTO> tasks = taskService.getTasksByStatus(taskStatus);
            return ResponseEntity.ok(tasks);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null); // Invalid status
        }
    }

    // Endpoint to get tasks by priority
    @GetMapping("/priority/{priority}")
    public ResponseEntity<List<TaskDTO>> getTasksByPriority(@PathVariable String priority) {
        try {
            TaskPriority taskPriority = TaskPriority.valueOf(priority.toUpperCase()); // Convert String to TaskPriority enum
            List<TaskDTO> tasks = taskService.getTasksByPriority(taskPriority);
            return ResponseEntity.ok(tasks);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null); // Invalid priority
        }
    }

    // Endpoint to get a task by ID
    @GetMapping("/{id}")
    public ResponseEntity<TaskDTO> getTaskById(@PathVariable Long id) {
        Optional<TaskDTO> taskDTO = taskService.findTaskById(id);
        return taskDTO.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).build());
    }

    // Endpoint to update an existing task
    @PutMapping("/{id}")
    public ResponseEntity<TaskDTO> updateTask(@PathVariable Long id, @RequestBody TaskDTO taskDTO) {
        taskDTO.setId(id);  // Ensure the ID from the path is set in the DTO

        // Convert DTO to entity using TaskMapper
        Task task = TaskMapper.toEntity(taskDTO);

        // Save the updated Task entity using the service
        Task updatedTask = taskService.saveTask(task);

        // Convert the updated Task entity back to TaskDTO
        TaskDTO updatedTaskDTO = TaskMapper.toDTO(updatedTask);

        // Return the updated TaskDTO
        return ResponseEntity.ok(updatedTaskDTO);
    }


    // Endpoint to delete a task
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTask(@PathVariable Long id) {
        taskService.deleteTask(id);
        return ResponseEntity.noContent().build();
    }
    // adding put status endpoint



}

