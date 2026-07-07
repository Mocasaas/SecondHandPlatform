package com.secondhand.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.secondhand.mapper.ProductMapper;
import com.secondhand.pojo.Product;
import com.secondhand.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductMapper productMapper;

    @Override
    public void addProduct(Product product) {
        productMapper.insert(product);
    }

    @Override
    public PageInfo<Product> findProducts(String keyword, Integer categoryId, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Product> list = productMapper.selectAll(keyword, categoryId);
        return new PageInfo<>(list);
    }

    @Override
    public Product findById(Integer id) {
        return productMapper.selectById(id);
    }

    @Override
    public void updateStatus(Integer id, Integer status) {
        productMapper.updateStatus(id, status);
    }

    @Override
    public void incrementViewCount(Integer id) {
        productMapper.incrementViewCount(id);
    }

    @Override
    public PageInfo<Product> findMyProducts(Integer userId, Integer status, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Product> list = productMapper.selectByUserId(userId, status);
        return new PageInfo<>(list);
    }

    // ========== 管理员专用 ==========

    @Override
    public PageInfo<Product> findAllProducts(String keyword, Integer categoryId, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Product> list = productMapper.findAll(keyword, categoryId);
        return new PageInfo<>(list);
    }

    @Override
    public void deleteProduct(Integer id) {
        productMapper.deleteById(id);
    }

    // ========== 排行榜 ==========

    @Override
    public PageInfo<Product> findProductsOrderByViewCount(Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Product> list = productMapper.selectOrderByViewCount();
        return new PageInfo<>(list);
    }

    // ========== 编辑商品 ==========

    @Override
    public void updateProduct(Product product) {
        productMapper.updateProduct(product);
    }
}