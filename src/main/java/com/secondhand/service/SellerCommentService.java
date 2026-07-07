package com.secondhand.service;

import com.secondhand.pojo.SellerComment;

import java.util.List;

public interface SellerCommentService {
    boolean addComment(SellerComment comment);
    List<SellerComment> getCommentsBySellerId(Integer sellerId);
    List<SellerComment> getCommentsByBuyerId(Integer buyerId);
    SellerComment getCommentByOrderId(Integer orderId);
    double getAvgRating(Integer sellerId);
}