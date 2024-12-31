package com.example.demo.mapper;

import com.example.demo.dto.CategoryDTO;
import com.example.demo.entity.Category;
import org.springframework.stereotype.Component;

@Component
public class CategoryMapper {

    // Convert Category entity to CategoryDTO
    public CategoryDTO toDTO(Category category) {
        if (category == null) {
            return null;
        }
        return new CategoryDTO(
            category.getId(),
            category.getName(),
            category.getColor(),
            category.getIcon()
        );
    }

    // Convert CategoryDTO to Category entity
    public Category toEntity(CategoryDTO categoryDTO) {
        if (categoryDTO == null) {
            return null;
        }
        Category category = new Category();
        category.setName(categoryDTO.getName());
        category.setColor(categoryDTO.getColor());
        category.setIcon(categoryDTO.getIcon());
        return category;
    }
}
