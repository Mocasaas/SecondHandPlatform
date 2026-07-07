package com.secondhand.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.secondhand.mapper.OrderMapper;
import com.secondhand.mapper.ProductMapper;
import com.secondhand.pojo.Order;
import com.secondhand.pojo.Product;
import com.secondhand.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;  // ← 添加这一行
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private ProductMapper productMapper;

    @Override
    @Transactional
    public Order createOrder(Integer productId, Integer buyerId) {
        Product product = productMapper.selectById(productId);
        if (product == null) {
            throw new RuntimeException("商品不存在");
        }
        if (product.getStatus() != 0) {
            throw new RuntimeException("商品已售出或已下架");
        }
        if (product.getUserId().equals(buyerId)) {
            throw new RuntimeException("不能购买自己发布的商品");
        }

        String orderNo = "ORD" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"))
                + String.format("%04d", (int) (Math.random() * 10000));

        Order order = new Order();
        order.setOrderNo(orderNo);
        order.setProductId(productId);
        order.setBuyerId(buyerId);
        order.setSellerId(product.getUserId());
        order.setPrice(product.getPrice());
        order.setStatus(1); // 直接设为待发货

        orderMapper.insert(order);
        productMapper.updateStatus(productId, 1);

        return order;
    }

    @Override
    @Transactional
    public List<Order> createBatchOrders(List<Integer> productIds, Integer buyerId) {
        List<Order> orders = new ArrayList<>();
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));

        for (int i = 0; i < productIds.size(); i++) {
            Integer productId = productIds.get(i);
            Product product = productMapper.selectById(productId);
            if (product == null) {
                throw new RuntimeException("商品不存在: ID=" + productId);
            }
            if (product.getStatus() != 0) {
                throw new RuntimeException("商品已售出或已下架: " + product.getTitle());
            }
            if (product.getUserId().equals(buyerId)) {
                throw new RuntimeException("不能购买自己发布的商品: " + product.getTitle());
            }

            String orderNo = "ORD" + timestamp + String.format("%04d", (int) (Math.random() * 10000) + i);

            Order order = new Order();
            order.setOrderNo(orderNo);
            order.setProductId(productId);
            order.setBuyerId(buyerId);
            order.setSellerId(product.getUserId());
            order.setPrice(product.getPrice());
            order.setStatus(1); // 直接设为待发货

            orderMapper.insert(order);
            productMapper.updateStatus(productId, 1);
            orders.add(order);
        }

        return orders;
    }

    @Override
    public Order findById(Integer id) {
        return orderMapper.selectById(id);
    }

    @Override
    public PageInfo<Order> findBuyerOrders(Integer buyerId, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Order> list = orderMapper.selectByBuyerId(buyerId);
        return new PageInfo<>(list);
    }

    @Override
    public PageInfo<Order> findSellerOrders(Integer sellerId, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Order> list = orderMapper.selectBySellerId(sellerId);
        return new PageInfo<>(list);
    }

    @Override
    public PageInfo<Order> findAllOrders(String keyword, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Order> list = orderMapper.findAll(keyword);
        return new PageInfo<>(list);
    }

    @Override
    @Transactional
    public boolean cancelOrder(Integer orderId, Integer userId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null || !order.getBuyerId().equals(userId)) {
            return false;
        }
        if (order.getStatus() != 1) {
            return false;
        }
        orderMapper.updateStatus(orderId, 0);
        productMapper.updateStatus(order.getProductId(), 0);
        return true;
    }

    @Override
    @Transactional
    public boolean confirmReceipt(Integer orderId, Integer userId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null || !order.getBuyerId().equals(userId)) {
            return false;
        }
        if (order.getStatus() != 2) {
            return false;
        }
        orderMapper.updateStatus(orderId, 3);
        return true;
    }

    @Override
    @Transactional
    public void updateOrderStatus(Integer orderId, Integer status) {
        orderMapper.updateStatus(orderId, status);
    }

    @Override
    public BigDecimal sumTotalAmountBySellerId(Integer sellerId) {
        BigDecimal sum = orderMapper.sumTotalAmountBySellerId(sellerId);
        return sum != null ? sum : BigDecimal.ZERO;
    }
}