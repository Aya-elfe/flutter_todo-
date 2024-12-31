package com.example.demo.service;

import com.example.demo.dto.CategoryDTO;
import com.example.demo.entity.Category;
import com.example.demo.mapper.CategoryMapper;
import com.example.demo.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CategoryService {

	@Autowired
    private final CategoryRepository categoryRepository;
	@Autowired
    private final CategoryMapper categoryMapper;

    public CategoryService(CategoryRepository categoryRepository, CategoryMapper categoryMapper) {
        this.categoryRepository = categoryRepository;
        this.categoryMapper = categoryMapper;
    }

    // Create a new category
    public CategoryDTO createCategory(String name, String color, String icon) {
        Category category = new Category();
        category.setName(name);
        category.setColor(color);
        category.setIcon(icon);

        // Save category to the database
        category = categoryRepository.save(category);

        // Convert Category entity to CategoryDTO and return
        return categoryMapper.toDTO(category);
    }

    // Get all categories
    public List<CategoryDTO> getAllCategories() {
        List<Category> categories = categoryRepository.findAll();
        return categories.stream()
                .map(categoryMapper::toDTO)
                .collect(Collectors.toList());
    }

    // Get category by ID
    public CategoryDTO getCategoryById(Long id) {
        Category category = categoryRepository.findById(id).orElse(null);
        return category != null ? categoryMapper.toDTO(category) : null;
    }

    // Update an existing category
    public CategoryDTO updateCategory(Long id, String name, String color, String icon) {
        Optional<Category> existingCategory = categoryRepository.findById(id);
        if (existingCategory.isPresent()) {
            Category category = existingCategory.get();
            category.setName(name);
            category.setColor(color);
            category.setIcon(icon);
            category = categoryRepository.save(category);
            return categoryMapper.toDTO(category);
        }
        return null;
    }

    // Delete a category
    public void deleteCategory(Long id) {
        categoryRepository.deleteById(id);
    }
}
