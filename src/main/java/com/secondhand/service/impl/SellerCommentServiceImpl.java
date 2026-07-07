package com.secondhand.service.impl;

import com.secondhand.mapper.SellerCommentMapper;
import com.secondhand.pojo.SellerComment;
import com.secondhand.service.SellerCommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SellerCommentServiceImpl implements SellerCommentService {

    @Autowired
    private SellerCommentMapper sellerCommentMapper;

    @Override
    public boolean addComment(SellerComment comment) {
        SellerComment exist = sellerCommentMapper.selectByOrderId(comment.getOrderId());
        if (exist != null) {
            return false;
        }
        return sellerCommentMapper.insert(comment) > 0;
    }

    @Override
    public List<SellerComment> getCommentsBySellerId(Integer sellerId) {
        return sellerCommentMapper.selectBySellerId(sellerId);
    }

    @Override
    public List<SellerComment> getCommentsByBuyerId(Integer buyerId) {
        return sellerCommentMapper.selectByBuyerId(buyerId);
    }

    @Override
    public SellerComment getCommentByOrderId(Integer orderId) {
        return sellerCommentMapper.selectByOrderId(orderId);
    }

    @Override
    public double getAvgRating(Integer sellerId) {
        return sellerCommentMapper.avgRatingBySellerId(sellerId);
    }
}