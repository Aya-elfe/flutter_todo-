package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf
                        .ignoringRequestMatchers("/users/register", "/users/login", "/users/{id}/username","/categories/**","/tasks/**")
                )

                .cors(cors -> cors
                        .configurationSource(request -> {
                            var corsConfiguration = new org.springframework.web.cors.CorsConfiguration();
                            corsConfiguration.addAllowedOrigin("http://localhost:62666"); // Allow frontend origin
                            corsConfiguration.addAllowedMethod("*"); // Allow all HTTP methods
                            corsConfiguration.addAllowedHeader("*"); // Allow all headers
                            corsConfiguration.setAllowCredentials(true); // Allow cookies and credentials
                            return corsConfiguration;
                        })
                )
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/users/register", "/users/login").permitAll() // Allow public access for user registration and login
                        .requestMatchers("/categories/**").authenticated() // Protect /categories endpoints
                        .anyRequest().authenticated() // Protect all other endpoints
                )
                .httpBasic(httpBasic -> {}); // Enable Basic Authentication

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(); // Use BCrypt for secure password hashing
    }
}
