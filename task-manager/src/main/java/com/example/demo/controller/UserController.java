package com.example.demo.controller;

import com.example.demo.dto.UserDTO;
import com.example.demo.entity.User;
import com.example.demo.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.nio.charset.StandardCharsets;
import java.util.*;

@RestController
@RequestMapping("/users")
public class UserController {

    @Autowired
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    // Register endpoint
    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody UserDTO userDTO) {
        try {
            // Register the user and get the created User object
            User registeredUser = userService.registerUser(userDTO.getUsername(), userDTO.getEmail(), userDTO.getPassword());

            // Build the response with the user details
            Map<String, Object> response = new HashMap<>();
            response.put("userId", registeredUser.getId());
            response.put("username", registeredUser.getUsername());
            response.put("email", registeredUser.getEmail());
            response.put("createdAt", registeredUser.getCreatedAt());

            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (IllegalArgumentException e) {
            // Return a bad request response with the error message
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error", e.getMessage()));
        }
    }


    // Login endpoint
    /*@PostMapping("/login")
   public ResponseEntity<String> login() {return ResponseEntity.ok("Login successful.");
   }*/
    // Login endpoint


    // Create user
    @PostMapping
    public ResponseEntity<UserDTO> createUser(@RequestBody UserDTO userDTO) {
        UserDTO createdUserDTO = userService.createUser(userDTO.getUsername(), userDTO.getEmail(), userDTO.getPassword());
        return ResponseEntity.status(HttpStatus.CREATED).body(createdUserDTO);
    }
    // Login endpoint
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody UserDTO userDTO, @RequestHeader Map<String, String> headers) {
        headers.forEach((key, value) -> System.out.println(key + ": " + value));
        System.out.println("Username: " + userDTO.getUsername());
        System.out.println("Password: " + userDTO.getPassword());

        Optional<Long> userId = userService.authenticateUser(userDTO.getUsername(), userDTO.getPassword());
        if (userId.isPresent()) {
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Login successful");
            response.put("userId", userId.get());
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("message", "Invalid credentials"));
    }



    // Get user by ID
    @GetMapping("/{id}")
    public ResponseEntity<UserDTO> getUserById(@PathVariable Long id) {
        Optional<UserDTO> userDTO = userService.findUserById(id);
        return userDTO.isPresent() ? ResponseEntity.ok(userDTO.get()) : ResponseEntity.notFound().build();
    }

    // Get all users
    @GetMapping
    public ResponseEntity<List<UserDTO>> getAllUsers() {
        List<UserDTO> users = userService.findAllUsers();
        return ResponseEntity.ok(users);
    }

    // Delete user
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }
    // Update username
    @PutMapping("/username/{id}")
    public ResponseEntity<String> updateUsername(@PathVariable Long id, @RequestBody Map<String, String> requestBody) {
        // Extract the username from the request body
        String username = requestBody.get("username");

        if (username == null || username.isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Username cannot be null or empty.");
        }

        // Call the service to update the username
        boolean isUpdated = userService.updateUsername(id, username);

        if (isUpdated) {
            return ResponseEntity.ok("Username updated successfully.");
        }
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Failed to update username.");
    }
    @PutMapping("/password/{id}")
    public ResponseEntity<String> updatePassword(
            @PathVariable Long id,
            @RequestBody Map<String, String> requestBody) {
        // Extract currentPassword and newPassword from the request body
        String currentPassword = requestBody.get("currentPassword");
        String newPassword = requestBody.get("newPassword");

        if (currentPassword == null || currentPassword.isEmpty() ||
                newPassword == null || newPassword.isEmpty()) {
            return ResponseEntity.badRequest().body("Current and new passwords must be provided.");
        }

        try {
            boolean isUpdated = userService.updatePassword(id, currentPassword, newPassword);

            if (isUpdated) {
                return ResponseEntity.ok("Password updated successfully.");
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid current password.");
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("An error occurred while updating the password: " + e.getMessage());
        }
    }

}
