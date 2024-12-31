    package com.example.demo.entity;

    import jakarta.persistence.*;
    import java.time.LocalDateTime;
    import java.util.ArrayList;
    import java.util.List;

    @Entity
    @Table(name = "users")
    public class User {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;

        @Column(unique = true, nullable = false)
        private String username;

        @Column(unique = true, nullable = false)
        private String email;

        @Column(nullable = false)
        private String password;

        private String firstName;
        private String lastName;

        @Column(nullable = false)
        private LocalDateTime createdAt;

        @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
        private List<Task> tasks = new ArrayList<>();

        @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
        private List<Comment> comments = new ArrayList<>();

        // Default constructor
        public User() {
        }

        public User(Long id) {
            this.id = id;
        }


        // All-arguments constructor
        public User(Long id, String username, String email, String password, String firstName, String lastName, LocalDateTime createdAt, List<Task> tasks, List<Comment> comments) {
            this.id = id;
            this.username = username;
            this.email = email;
            this.password = password;
            this.firstName = firstName;
            this.lastName = lastName;
            this.createdAt = createdAt;
            this.tasks = tasks;
            this.comments = comments;
        }

        // Builder pattern
        public static class Builder {
            private Long id;
            private String username;
            private String email;
            private String password;
            private String firstName;
            private String lastName;
            private LocalDateTime createdAt;
            private List<Task> tasks = new ArrayList<>();
            private List<Comment> comments = new ArrayList<>();

            public Builder id(Long id) {
                this.id = id;
                return this;
            }

            public Builder username(String username) {
                this.username = username;
                return this;
            }

            public Builder email(String email) {
                this.email = email;
                return this;
            }

            public Builder password(String password) {
                this.password = password;
                return this;
            }

            public Builder firstName(String firstName) {
                this.firstName = firstName;
                return this;
            }

            public Builder lastName(String lastName) {
                this.lastName = lastName;
                return this;
            }

            public Builder createdAt(LocalDateTime createdAt) {
                this.createdAt = createdAt;
                return this;
            }

            public Builder tasks(List<Task> tasks) {
                this.tasks = tasks;
                return this;
            }

            public Builder comments(List<Comment> comments) {
                this.comments = comments;
                return this;
            }

            public User build() {
                return new User(id, username, email, password, firstName, lastName, createdAt, tasks, comments);
            }
        }

        // Getters and setters
        public Long getId() {
            return id;
        }

        public void setId(Long id) {
            this.id = id;
        }

        public String getUsername() {
            return username;
        }

        public void setUsername(String username) {
            this.username = username;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getPassword() {
            return password;
        }

        public void setPassword(String password) {
            this.password = password;
        }

        public String getFirstName() {
            return firstName;
        }

        public void setFirstName(String firstName) {
            this.firstName = firstName;
        }

        public String getLastName() {
            return lastName;
        }

        public void setLastName(String lastName) {
            this.lastName = lastName;
        }

        public LocalDateTime getCreatedAt() {
            return createdAt;
        }

        public void setCreatedAt(LocalDateTime createdAt) {
            this.createdAt = createdAt;
        }

        public List<Task> getTasks() {
            return tasks;
        }

        public void setTasks(List<Task> tasks) {
            this.tasks = tasks;
        }

        public List<Comment> getComments() {
            return comments;
        }

        public void setComments(List<Comment> comments) {
            this.comments = comments;
        }

        // Method to set the created date before persisting
        @PrePersist
        protected void onCreate() {
            this.createdAt = LocalDateTime.now();
        }
    }
