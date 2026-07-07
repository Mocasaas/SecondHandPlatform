package com.secondhand.mapper;

import com.secondhand.pojo.Cart;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CartMapper {

    Cart selectByUserIdAndProductId(@Param("userId") Integer userId, @Param("productId") Integer productId);

    List<Cart> selectByUserId(Integer userId);

    int insert(Cart cart);

    int updateQuantity(@Param("id") Integer id, @Param("quantity") Integer quantity);

    int deleteById(Integer id);

    int deleteByUserIdAndProductId(@Param("userId") Integer userId, @Param("productId") Integer productId);
}