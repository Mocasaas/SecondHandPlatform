package com.secondhand.service;

import com.secondhand.pojo.Comment;

import java.util.List;

public interface CommentService {
    boolean addComment(Comment comment);
    List<Comment> getCommentsByProductId(Integer productId);
    List<Comment> getCommentsByUserId(Integer userId);
    Comment getCommentByOrderId(Integer orderId);
    double getAverageRating(Integer productId);
}