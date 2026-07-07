package com.secondhand.mapper;

import com.secondhand.pojo.Product;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ProductMapper {
    int insert(Product product);

    Product selectById(Integer id);

    List<Product> selectAll(@Param("keyword") String keyword, @Param("categoryId") Integer categoryId);

    void updateStatus(@Param("id") Integer id, @Param("status") Integer status);

    void incrementViewCount(@Param("id") Integer id);

    List<Product> selectByUserId(@Param("userId") Integer userId, @Param("status") Integer status);

    // ========== 管理员专用 ==========

    List<Product> findAll(@Param("keyword") String keyword, @Param("categoryId") Integer categoryId);

    int deleteById(Integer id);

    // ========== 排行榜 ==========

    List<Product> selectOrderByViewCount();

    // ========== 编辑商品 ==========

    int updateProduct(Product product);
}