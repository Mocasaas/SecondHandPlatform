package com.secondhand.service.impl;

import com.secondhand.mapper.CartMapper;
import com.secondhand.mapper.ProductMapper;
import com.secondhand.pojo.Cart;
import com.secondhand.pojo.Product;
import com.secondhand.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class CartServiceImpl implements CartService {

    @Autowired
    private CartMapper cartMapper;

    @Autowired
    private ProductMapper productMapper;

    @Override
    @Transactional
    public boolean addToCart(Integer userId, Integer productId, Integer quantity) {
        Product product = productMapper.selectById(productId);
        if (product == null || product.getStatus() != 0) {
            return false;
        }
        if (product.getUserId().equals(userId)) {
            return false;
        }

        Cart exist = cartMapper.selectByUserIdAndProductId(userId, productId);
        if (exist != null) {
            int newQuantity = exist.getQuantity() + quantity;
            cartMapper.updateQuantity(exist.getId(), newQuantity);
        } else {
            Cart cart = new Cart();
            cart.setUserId(userId);
            cart.setProductId(productId);
            cart.setQuantity(quantity);
            cartMapper.insert(cart);
        }
        return true;
    }

    @Override
    public List<Cart> getCartList(Integer userId) {
        return cartMapper.selectByUserId(userId);
    }

    @Override
    public boolean updateQuantity(Integer cartId, Integer quantity) {
        if (quantity <= 0) {
            return false;
        }
        return cartMapper.updateQuantity(cartId, quantity) > 0;
    }

    @Override
    public boolean deleteCartItem(Integer cartId, Integer userId) {
        List<Cart> cartList = cartMapper.selectByUserId(userId);
        for (Cart cart : cartList) {
            if (cart.getId().equals(cartId)) {
                return cartMapper.deleteById(cartId) > 0;
            }
        }
        return false;
    }

    @Override
    public boolean clearCart(Integer userId) {
        List<Cart> cartList = cartMapper.selectByUserId(userId);
        for (Cart cart : cartList) {
            cartMapper.deleteById(cart.getId());
        }
        return true;
    }

    @Override
    public List<Cart> getSelectedCarts(Integer userId, List<Integer> cartIds) {
        List<Cart> allCarts = cartMapper.selectByUserId(userId);
        List<Cart> selected = new ArrayList<>();
        for (Cart cart : allCarts) {
            if (cartIds.contains(cart.getId())) {
                selected.add(cart);
            }
        }
        return selected;
    }
}