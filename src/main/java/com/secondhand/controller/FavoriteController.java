package com.secondhand.controller;

import com.secondhand.pojo.Favorite;
import com.secondhand.pojo.User;
import com.secondhand.service.FavoriteService;
import com.secondhand.utils.DataInfo;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/favorite")
public class FavoriteController {

    @Autowired
    private FavoriteService favoriteService;

    /**
     * 我的收藏列表
     */
    @GetMapping("/list")
    public String list(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/user/toLogin";
        }
        List<Favorite> favorites = favoriteService.getFavorites(loginUser.getId());
        model.addAttribute("favorites", favorites);
        return "favorites";
    }

    /**
     * 切换收藏状态
     */
    @PostMapping("/toggle")
    @ResponseBody
    public DataInfo toggle(@RequestParam("productId") Integer productId, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return DataInfo.fail("请先登录");
        }
        boolean favorited = favoriteService.toggleFavorite(loginUser.getId(), productId);
        int count = favoriteService.getFavoriteCount(productId);
        return DataInfo.ok(favorited ? "已收藏" : "已取消收藏", count);
    }

    /**
     * 检查是否已收藏
     */
    @GetMapping("/check")
    @ResponseBody
    public DataInfo check(@RequestParam("productId") Integer productId, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return DataInfo.ok(false);
        }
        boolean favorited = favoriteService.isFavorited(loginUser.getId(), productId);
        int count = favoriteService.getFavoriteCount(productId);
        return DataInfo.ok(favorited ? "已收藏" : "未收藏", count);
    }
}