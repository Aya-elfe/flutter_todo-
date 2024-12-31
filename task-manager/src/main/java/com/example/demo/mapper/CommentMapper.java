package com.example.demo.mapper;

import com.example.demo.dto.CommentDTO;
import com.example.demo.entity.Comment;
import com.example.demo.entity.Task;
import com.example.demo.entity.User;

import java.util.List;
import java.util.stream.Collectors;

public class CommentMapper {

    // Convert Comment entity to CommentDTO
    public static CommentDTO toDTO(Comment comment) {
        if (comment == null) {
            return null;
        }

        return new CommentDTO.Builder()
                .id(comment.getId())
                .content(comment.getContent())  // Using 'content' field from Comment entity
                .createdAt(comment.getCreatedAt())
                .updatedAt(comment.getUpdatedAt())
                .userId(comment.getUser().getId())  // Assuming the User entity has getId() method
                .taskId(comment.getTask().getId())  // Assuming the Task entity has getId() method
                .build();
    }

    // Convert CommentDTO to Comment entity
    public static Comment toEntity(CommentDTO commentDTO) {
        if (commentDTO == null) {
            return null;
        }

        Comment comment = new Comment();
        comment.setId(commentDTO.getId());
        comment.setContent(commentDTO.getContent());
        comment.setCreatedAt(commentDTO.getCreatedAt());
        comment.setUpdatedAt(commentDTO.getUpdatedAt());

        // Setting the associated User and Task entities (assuming these entities are fetched or exist)
        comment.setUser(new User(commentDTO.getUserId()));  // Assuming a constructor in User entity that accepts Long ID
        comment.setTask(new Task(commentDTO.getTaskId()));  // Assuming a constructor in Task entity that accepts Long ID

        return comment;
    }

    // Convert a list of Comment entities to a list of CommentDTOs
    public static List<CommentDTO> toDTOList(List<Comment> comments) {
        return comments.stream()
                .map(CommentMapper::toDTO)
                .collect(Collectors.toList());
    }

    // Convert a list of CommentDTOs to a list of Comment entities
    public static List<Comment> toEntityList(List<CommentDTO> commentDTOs) {
        return commentDTOs.stream()
                .map(CommentMapper::toEntity)
                .collect(Collectors.toList());
    }
}
