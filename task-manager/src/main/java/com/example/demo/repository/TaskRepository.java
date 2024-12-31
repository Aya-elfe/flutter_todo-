package com.example.demo.repository;

import com.example.demo.entity.Task;
import com.example.demo.enums.TaskPriority;
import com.example.demo.enums.TaskStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface TaskRepository extends JpaRepository<Task, Long> {

    List<Task> findByStatus(TaskStatus status);

    List<Task> findByPriority(TaskPriority priority);

    List<Task> findByUserId(Long userId);
    List<Task> findByStatusAndUserId(TaskStatus status, Long userId);
    List<Task> findByPriorityAndUserId(TaskPriority priority, Long userId);
    Optional<Task> findByIdAndUserId(Long id, Long userId);
}
