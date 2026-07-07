package com.secondhand.service;

import com.secondhand.pojo.Category;

import java.util.List;

public interface CategoryService {

    List<Category> findAll();

    Category findById(Integer id);

    void addCategory(Category category);

    void updateCategory(Category category);

    void deleteCategory(Integer id);
}