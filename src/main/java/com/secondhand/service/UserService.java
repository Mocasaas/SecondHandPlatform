package com.secondhand.service;

import com.github.pagehelper.PageInfo;
import com.secondhand.pojo.User;

public interface UserService {
    User login(String username, String password);
    boolean register(User user);
    User findById(Integer id);
    boolean updateUser(User user);

    // 管理员专用
    PageInfo<User> findAllUsers(String keyword, Integer pageNum, Integer pageSize);
    boolean banUser(Integer id);
    boolean unbanUser(Integer id);
    boolean resetPassword(Integer id, String newPassword);
}