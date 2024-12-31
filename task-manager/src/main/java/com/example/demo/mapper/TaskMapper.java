package com.example.demo.mapper;

import com.example.demo.dto.TaskDTO;
import com.example.demo.entity.Category;
import com.example.demo.entity.Task;
import com.example.demo.entity.User;
import com.example.demo.enums.TaskPriority;
import com.example.demo.enums.TaskStatus;

import java.util.List;
import java.util.stream.Collectors;

public class TaskMapper {

    // Convert Task entity to TaskDTO
    public static TaskDTO toDTO(Task task) {
        if (task == null) {
            return null;
        }

        return new TaskDTO.Builder()
                .id(task.getId())
                .title(task.getTitle())
                .description(task.getDescription())
                .priority(task.getPriority())  // Enum field mapping
                .status(task.getStatus())  // Enum field mapping
                .dueDate(task.getDueDate())
                .createdAt(task.getCreatedAt())
                .updatedAt(task.getUpdatedAt())
                .userId(task.getUser().getId())  // Assuming a User entity with a getId() method
                .categoryId(task.getCategory().getId())  // Assuming a Category entity with a getId() method
                .build();
    }

    // Convert TaskDTO to Task entity
    public static Task toEntity(TaskDTO taskDTO) {
        if (taskDTO == null) {
            return null;
        }

        Task task = new Task();
        task.setId(taskDTO.getId());
        task.setTitle(taskDTO.getTitle());
        task.setDescription(taskDTO.getDescription());
        
        // Properly handling the enums from TaskDTO to Task entity
        if (taskDTO.getPriority() != null) {
            task.setPriority(TaskPriority.valueOf(taskDTO.getPriority().name())); // Ensure valid enum value
        }

        if (taskDTO.getStatus() != null) {
            task.setStatus(TaskStatus.valueOf(taskDTO.getStatus().name())); // Ensure valid enum value
        }

        task.setDueDate(taskDTO.getDueDate());
        task.setCreatedAt(taskDTO.getCreatedAt());
        task.setUpdatedAt(taskDTO.getUpdatedAt());

        // Assuming you have User and Category objects ready to be set in the task
        task.setUser(new User(taskDTO.getUserId()));  // Assuming the User constructor takes a Long ID
        task.setCategory(new Category(taskDTO.getCategoryId())); // Assuming the Category constructor takes a Long ID

        return task;
    }

    // Convert a list of Task entities to a list of TaskDTOs
    public static List<TaskDTO> toDTOList(List<Task> tasks) {
        return tasks.stream()
                .map(TaskMapper::toDTO)
                .collect(Collectors.toList());
    }

    // Convert a list of TaskDTOs to a list of Task entities
    public static List<Task> toEntityList(List<TaskDTO> taskDTOs) {
        return taskDTOs.stream()
                .map(TaskMapper::toEntity)
                .collect(Collectors.toList());
    }
}
