package com.secondhand.service.impl;

import com.secondhand.mapper.FavoriteMapper;
import com.secondhand.pojo.Favorite;
import com.secondhand.service.FavoriteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FavoriteServiceImpl implements FavoriteService {

    @Autowired
    private FavoriteMapper favoriteMapper;

    @Override
    public boolean toggleFavorite(Integer userId, Integer productId) {
        Favorite exist = favoriteMapper.selectByUserIdAndProductId(userId, productId);
        if (exist != null) {
            favoriteMapper.delete(userId, productId);
            return false; // 已取消收藏
        } else {
            Favorite favorite = new Favorite();
            favorite.setUserId(userId);
            favorite.setProductId(productId);
            favoriteMapper.insert(favorite);
            return true; // 已收藏
        }
    }

    @Override
    public boolean isFavorited(Integer userId, Integer productId) {
        return favoriteMapper.selectByUserIdAndProductId(userId, productId) != null;
    }

    @Override
    public List<Favorite> getFavorites(Integer userId) {
        return favoriteMapper.selectByUserId(userId);
    }

    @Override
    public int getFavoriteCount(Integer productId) {
        return favoriteMapper.countByProductId(productId);
    }
}