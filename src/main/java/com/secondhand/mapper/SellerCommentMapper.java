package com.secondhand.mapper;

import com.secondhand.pojo.SellerComment;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface SellerCommentMapper {
    int insert(SellerComment comment);
    List<SellerComment> selectBySellerId(Integer sellerId);
    List<SellerComment> selectByBuyerId(Integer buyerId);
    SellerComment selectByOrderId(Integer orderId);
    double avgRatingBySellerId(Integer sellerId);
}