package com.secondhand.service.impl;

import com.secondhand.mapper.CommentMapper;
import com.secondhand.pojo.Comment;
import com.secondhand.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CommentServiceImpl implements CommentService {

    @Autowired
    private CommentMapper commentMapper;

    @Override
    public boolean addComment(Comment comment) {
        // 检查是否已评价
        Comment exist = commentMapper.selectByOrderId(comment.getOrderId());
        if (exist != null) {
            return false;
        }
        return commentMapper.insert(comment) > 0;
    }

    @Override
    public List<Comment> getCommentsByProductId(Integer productId) {
        return commentMapper.selectByProductId(productId);
    }

    @Override
    public List<Comment> getCommentsByUserId(Integer userId) {
        return commentMapper.selectByUserId(userId);
    }

    @Override
    public Comment getCommentByOrderId(Integer orderId) {
        return commentMapper.selectByOrderId(orderId);
    }

    @Override
    public double getAverageRating(Integer productId) {
        List<Comment> comments = commentMapper.selectByProductId(productId);
        if (comments.isEmpty()) {
            return 0;
        }
        int sum = 0;
        for (Comment c : comments) {
            sum += c.getRating();
        }
        return (double) sum / comments.size();
    }
}