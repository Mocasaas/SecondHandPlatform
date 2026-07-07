package com.secondhand.service;

import com.github.pagehelper.PageInfo;
import com.secondhand.pojo.Product;

public interface ProductService {
    void addProduct(Product product);

    PageInfo<Product> findProducts(String keyword, Integer categoryId, Integer pageNum, Integer pageSize);

    Product findById(Integer id);

    void updateStatus(Integer id, Integer status);

    void incrementViewCount(Integer id);

    PageInfo<Product> findMyProducts(Integer userId, Integer status, Integer pageNum, Integer pageSize);

    // ========== 管理员专用 ==========

    PageInfo<Product> findAllProducts(String keyword, Integer categoryId, Integer pageNum, Integer pageSize);

    void deleteProduct(Integer id);

    // ========== 排行榜 ==========

    PageInfo<Product> findProductsOrderByViewCount(Integer pageNum, Integer pageSize);

    // ========== 编辑商品 ==========

    void updateProduct(Product product);
}