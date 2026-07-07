package com.secondhand.mapper;

import com.secondhand.pojo.Favorite;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface FavoriteMapper {
    int insert(Favorite favorite);
    int delete(@Param("userId") Integer userId, @Param("productId") Integer productId);
    Favorite selectByUserIdAndProductId(@Param("userId") Integer userId, @Param("productId") Integer productId);
    List<Favorite> selectByUserId(Integer userId);
    int countByProductId(Integer productId);
}