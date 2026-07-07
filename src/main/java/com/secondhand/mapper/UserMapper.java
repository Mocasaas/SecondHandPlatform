package com.secondhand.mapper;

import com.secondhand.pojo.User;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface UserMapper {
    User selectByUsernameAndPassword(@Param("username") String username, @Param("password") String password);
    User selectByUsername(String username);
    int insert(User user);
    User selectById(Integer id);
    int update(User user);

    // 管理员专用
    List<User> findAll(@Param("keyword") String keyword);
    int updateStatus(@Param("id") Integer id, @Param("status") Integer status);
    int resetPassword(@Param("id") Integer id, @Param("password") String password);
}