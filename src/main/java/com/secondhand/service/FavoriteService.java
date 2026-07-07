package com.secondhand.service;

import com.secondhand.pojo.Favorite;

import java.util.List;

public interface FavoriteService {
    boolean toggleFavorite(Integer userId, Integer productId);
    boolean isFavorited(Integer userId, Integer productId);
    List<Favorite> getFavorites(Integer userId);
    int getFavoriteCount(Integer productId);
}