package com.secondhand.mapper;

import com.secondhand.pojo.Order;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;

public interface OrderMapper {
    int insert(Order order);
    Order selectById(Integer id);
    List<Order> selectByBuyerId(Integer buyerId);
    List<Order> selectBySellerId(Integer sellerId);
    void updateStatus(@Param("id") Integer id, @Param("status") Integer status);

    // 管理员专用
    List<Order> findAll(@Param("keyword") String keyword);

    // ========== 新增：统计卖家总收入 ==========
    BigDecimal sumTotalAmountBySellerId(@Param("sellerId") Integer sellerId);
}