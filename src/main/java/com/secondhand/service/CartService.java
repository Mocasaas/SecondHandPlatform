package com.secondhand.service;

import com.secondhand.pojo.Cart;

import java.util.List;

public interface CartService {

    boolean addToCart(Integer userId, Integer productId, Integer quantity);

    List<Cart> getCartList(Integer userId);

    boolean updateQuantity(Integer cartId, Integer quantity);

    boolean deleteCartItem(Integer cartId, Integer userId);

    boolean clearCart(Integer userId);

    /**
     * 获取用户选中的购物车项
     */
    List<Cart> getSelectedCarts(Integer userId, List<Integer> cartIds);
}