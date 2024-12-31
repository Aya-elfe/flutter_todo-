package com.example.demo.mapper;

import com.example.demo.dto.UserDTO;
import com.example.demo.entity.User;
import org.springframework.stereotype.Component;

@Component
public class UserMapper {

    // Method to convert User entity to UserDTO
    public UserDTO toDTO(User user) {
        if (user == null) {
            return null;
        }

        // Create and populate the UserDTO object
        UserDTO userDTO = new UserDTO();
        userDTO.setId(user.getId());
        userDTO.setUsername(user.getUsername());
        userDTO.setEmail(user.getEmail());
        userDTO.setPassword(user.getPassword()); // Be careful with sensitive data
        userDTO.setCreatedAt(user.getCreatedAt());
        userDTO.setUpdatedAt(user.getCreatedAt());

        return userDTO;
    }

    // Method to convert UserDTO to User entity
    public User toEntity(UserDTO userDTO) {
        if (userDTO == null) {
            return null;
        }

        // Create and populate the User entity
        User user = new User();
        user.setId(userDTO.getId());
        user.setUsername(userDTO.getUsername());
        user.setEmail(userDTO.getEmail());
        user.setPassword(userDTO.getPassword()); // Be cautious with storing passwords directly
        user.setCreatedAt(userDTO.getCreatedAt());
        user.setCreatedAt(userDTO.getUpdatedAt());

        return user;
    }
}
