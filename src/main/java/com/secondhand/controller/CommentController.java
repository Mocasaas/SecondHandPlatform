package com.secondhand.controller;

import com.secondhand.pojo.Comment;
import com.secondhand.pojo.User;
import com.secondhand.service.CommentService;
import com.secondhand.utils.DataInfo;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/comment")
public class CommentController {

    @Autowired
    private CommentService commentService;

    /**
     * 评价页面（订单完成后跳转）
     */
    @GetMapping("/add")
    public String add(@RequestParam("orderId") Integer orderId, Model model, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/user/toLogin";
        }
        // 检查是否已评价
        Comment exist = commentService.getCommentByOrderId(orderId);
        if (exist != null) {
            model.addAttribute("msg", "您已评价过此订单");
        }
        model.addAttribute("orderId", orderId);
        return "commentAdd";
    }

    /**
     * 提交评价
     */
    @PostMapping("/submit")
    @ResponseBody
    public DataInfo submit(Comment comment, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return DataInfo.fail("请先登录");
        }
        comment.setUserId(loginUser.getId());
        boolean success = commentService.addComment(comment);
        return success ? DataInfo.ok("评价成功") : DataInfo.fail("您已评价过该订单");
    }

    /**
     * 商品评价列表
     */
    @GetMapping("/list")
    public String list(@RequestParam("productId") Integer productId, Model model) {
        model.addAttribute("comments", commentService.getCommentsByProductId(productId));
        model.addAttribute("avgRating", commentService.getAverageRating(productId));
        return "commentList";
    }
}