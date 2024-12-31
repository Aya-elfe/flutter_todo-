package com.example.demo.service;

import com.example.demo.dto.CommentDTO;
import com.example.demo.entity.Comment;
import com.example.demo.repository.CommentRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.repository.TaskRepository;
import com.example.demo.mapper.CommentMapper;  // Import the CommentMapper
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CommentService {
	
    @Autowired
    private final CommentRepository commentRepository;
    @Autowired
    private final UserRepository userRepository;
    @Autowired
    private final TaskRepository taskRepository;

    public CommentService(CommentRepository commentRepository, UserRepository userRepository, TaskRepository taskRepository) {
        this.commentRepository = commentRepository;
        this.userRepository = userRepository;
        this.taskRepository = taskRepository;
    }

    // Create a comment for a task
    public CommentDTO saveComment(CommentDTO commentDTO) {
        // Use the mapper to convert DTO to entity
        Comment comment = CommentMapper.toEntity(commentDTO);  // Call static method

        // Set user and task from their IDs
        userRepository.findById(commentDTO.getUserId()).ifPresent(comment::setUser);
        taskRepository.findById(commentDTO.getTaskId()).ifPresent(comment::setTask);

        comment = commentRepository.save(comment);

        // Use the mapper to convert the saved entity back to DTO
        return CommentMapper.toDTO(comment);  // Call static method
    }

    // Find a comment by ID
    public Optional<CommentDTO> findCommentById(Long id) {
        Optional<Comment> comment = commentRepository.findById(id);
        return comment.map(CommentMapper::toDTO);  // Call static method
    }

    // Get comments by task ID
    public List<CommentDTO> getCommentsByTaskId(Long taskId) {
        List<Comment> comments = commentRepository.findByTaskId(taskId);
        return comments.stream()
                .map(CommentMapper::toDTO)  // Call static method
                .collect(Collectors.toList());
    }

    // Update an existing comment
    public CommentDTO updateComment(Long id, String content) {
        Optional<Comment> comment = commentRepository.findById(id);
        if (comment.isPresent()) {
            Comment updatedComment = comment.get();
            updatedComment.setContent(content);
            updatedComment = commentRepository.save(updatedComment);
            return CommentMapper.toDTO(updatedComment);  // Call static method
        }
        return null; // Or throw exception if comment not found
    }

    // Delete a comment
    public void deleteComment(Long id) {
        commentRepository.deleteById(id);
    }
}
