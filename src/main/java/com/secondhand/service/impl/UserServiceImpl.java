package com.secondhand.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.secondhand.mapper.UserMapper;
import com.secondhand.pojo.User;
import com.secondhand.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User login(String username, String password) {
        return userMapper.selectByUsernameAndPassword(username, password);
    }

    @Override
    public boolean register(User user) {
        User exist = userMapper.selectByUsername(user.getUsername());
        if (exist != null) {
            return false;
        }
        // 默认状态为正常
        user.setStatus(0);
        userMapper.insert(user);
        return true;
    }

    @Override
    public User findById(Integer id) {
        return userMapper.selectById(id);
    }

    @Override
    public boolean updateUser(User user) {
        return userMapper.update(user) > 0;
    }

    // ========== 管理员专用 ==========

    @Override
    public PageInfo<User> findAllUsers(String keyword, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<User> list = userMapper.findAll(keyword);
        return new PageInfo<>(list);
    }

    @Override
    public boolean banUser(Integer id) {
        return userMapper.updateStatus(id, 1) > 0;
    }

    @Override
    public boolean unbanUser(Integer id) {
        return userMapper.updateStatus(id, 0) > 0;
    }

    @Override
    public boolean resetPassword(Integer id, String newPassword) {
        return userMapper.resetPassword(id, newPassword) > 0;
    }
}