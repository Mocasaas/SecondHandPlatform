package com.secondhand.service;

import com.github.pagehelper.PageInfo;
import com.secondhand.pojo.Order;

import java.math.BigDecimal;
import java.util.List;

public interface OrderService {

    Order createOrder(Integer productId, Integer buyerId);

    List<Order> createBatchOrders(List<Integer> productIds, Integer buyerId);

    Order findById(Integer id);

    PageInfo<Order> findBuyerOrders(Integer buyerId, Integer pageNum, Integer pageSize);

    PageInfo<Order> findSellerOrders(Integer sellerId, Integer pageNum, Integer pageSize);

    PageInfo<Order> findAllOrders(String keyword, Integer pageNum, Integer pageSize);

    boolean cancelOrder(Integer orderId, Integer userId);

    boolean confirmReceipt(Integer orderId, Integer userId);

    void updateOrderStatus(Integer orderId, Integer status);

    // ========== 新增：统计卖家总收入 ==========

    BigDecimal sumTotalAmountBySellerId(Integer sellerId);
}