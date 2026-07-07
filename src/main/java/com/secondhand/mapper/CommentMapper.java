package com.secondhand.mapper;

import com.secondhand.pojo.Comment;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CommentMapper {
    int insert(Comment comment);
    List<Comment> selectByProductId(Integer productId);
    List<Comment> selectByUserId(Integer userId);
    Comment selectByOrderId(Integer orderId);
    int deleteByOrderId(Integer orderId);
}