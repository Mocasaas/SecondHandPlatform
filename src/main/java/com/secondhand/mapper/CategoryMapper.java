package com.secondhand.mapper;

import com.secondhand.pojo.Category;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CategoryMapper {

    List<Category> findAll();

    Category findById(Integer id);

    int insert(Category category);

    int update(Category category);

    int deleteById(Integer id);
}