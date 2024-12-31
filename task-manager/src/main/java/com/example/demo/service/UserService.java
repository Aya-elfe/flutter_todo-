package com.example.demo.service;

import com.example.demo.dto.UserDTO;
import com.example.demo.entity.User;
import com.example.demo.mapper.UserMapper;
import com.example.demo.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UserService {

    @Autowired
    private final UserRepository userRepository;

    @Autowired
    private final UserMapper userMapper;

    @Autowired
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, UserMapper userMapper, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.userMapper = userMapper;
        this.passwordEncoder = passwordEncoder;
    }

    // Create or update a user and return as DTO
    public UserDTO createUser(String username, String email, String password) {
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(password)); // Encode password

        // Save the user to the database
        user = userRepository.save(user);

        // Convert User entity to UserDTO and return
        return userMapper.toDTO(user);
    }

    // Register a new user
    public User registerUser(String username, String email, String password) {
        // Check if username already exists
        if (userRepository.findByUsername(username).isPresent()) {
            throw new IllegalArgumentException("Username already exists"); // Throw exception if username is taken
        }

        // Create a new User object
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(password)); // Encode password

        // Save the new user to the database and return the saved user
        return userRepository.save(user);
    }


    // Find a user by ID and return as DTO
    public Optional<UserDTO> findUserById(Long id) {
        Optional<User> user = userRepository.findById(id);
        return user.map(userMapper::toDTO);
    }

    // Retrieve all users and return as a list of DTOs
    public List<UserDTO> findAllUsers() {
        return userRepository.findAll()
                .stream()
                .map(userMapper::toDTO)
                .collect(Collectors.toList());
    }

    // Delete a user
    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    // Find a user by username (used in authentication and validation)
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public boolean updateUsername(Long id, String username) {
        Optional<User> userOptional = userRepository.findById(id);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            user.setUsername(username);
            userRepository.save(user);
            return true;
        }
        return false;
    }

    public Optional<Long> authenticateUser(String username, String password) {
        Optional<User> user = userRepository.findByUsername(username);
        if (user.isPresent() && passwordEncoder.matches(password, user.get().getPassword())) {
            return Optional.of(user.get().getId());
        }
        return Optional.empty();
    }
    public boolean updatePassword(Long userId, String currentPassword, String newPassword) {
        // Fetch the user by ID
        Optional<User> userOptional = userRepository.findById(userId);

        if (userOptional.isEmpty()) {
            throw new IllegalArgumentException("User not found.");
        }

        User user = userOptional.get();

        // Verify the current password
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            return false; // Current password does not match
        }

        // Hash and update the new password
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        return true; // Password updated successfully
    }

}
