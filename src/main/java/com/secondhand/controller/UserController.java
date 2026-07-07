package com.secondhand.controller;

import com.secondhand.pojo.User;
import com.secondhand.service.SellerCommentService;
import com.secondhand.service.UserService;
import com.secondhand.utils.DataInfo;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private SellerCommentService sellerCommentService;

    @GetMapping("/toLogin")
    public String toLogin() {
        return "login";
    }

    @GetMapping("/toRegister")
    public String toRegister() {
        return "register";
    }

    @PostMapping("/login")
    public String login(String username, String password, HttpSession session, Model model) {
        User user = userService.login(username, password);
        if (user == null) {
            model.addAttribute("error", "用户名或密码错误");
            return "login";
        }
        session.setAttribute("loginUser", user);
        return "redirect:/";
    }

    @PostMapping("/register")
    public String register(User user, Model model) {
        user.setRole(0);
        boolean success = userService.register(user);
        if (!success) {
            model.addAttribute("error", "用户名已被占用，请换一个");
            return "register";
        }
        try {
            String msg = URLEncoder.encode("注册成功，请登录", "UTF-8");
            return "redirect:/user/toLogin?msg=" + msg;
        } catch (UnsupportedEncodingException e) {
            return "redirect:/user/toLogin";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        try {
            String msg = URLEncoder.encode("您已成功退出", "UTF-8");
            return "redirect:/user/toLogin?msg=" + msg;
        } catch (UnsupportedEncodingException e) {
            return "redirect:/user/toLogin";
        }
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/user/toLogin";
        }
        User user = userService.findById(loginUser.getId());
        model.addAttribute("user", user);

        // ===== 新增：查询用户平均评分 =====
        double avgRating = sellerCommentService.getAvgRating(loginUser.getId());
        model.addAttribute("userAvgRating", avgRating);

        return "profile";
    }

    @PostMapping("/updateProfile")
    @ResponseBody
    public DataInfo updateProfile(User user, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return DataInfo.fail("请先登录");
        }
        user.setId(loginUser.getId());
        boolean success = userService.updateUser(user);
        if (success) {
            User updatedUser = userService.findById(loginUser.getId());
            session.setAttribute("loginUser", updatedUser);
            return DataInfo.ok("修改成功");
        } else {
            return DataInfo.fail("修改失败");
        }
    }
}