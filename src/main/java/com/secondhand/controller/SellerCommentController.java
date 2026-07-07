package com.secondhand.controller;

import com.secondhand.pojo.SellerComment;
import com.secondhand.pojo.User;
import com.secondhand.service.SellerCommentService;
import com.secondhand.utils.DataInfo;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/sellerComment")
public class SellerCommentController {

    @Autowired
    private SellerCommentService sellerCommentService;

    /**
     * 评价卖家页面
     */
    @GetMapping("/add")
    public String add(@RequestParam("orderId") Integer orderId,
                      @RequestParam("sellerId") Integer sellerId,
                      Model model, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/user/toLogin";
        }
        // 检查是否已评价
        SellerComment exist = sellerCommentService.getCommentByOrderId(orderId);
        if (exist != null) {
            model.addAttribute("msg", "您已评价过此订单的卖家");
        }
        model.addAttribute("orderId", orderId);
        model.addAttribute("sellerId", sellerId);
        return "sellerCommentAdd";
    }

    /**
     * 提交评价
     */
    @PostMapping("/submit")
    @ResponseBody
    public DataInfo submit(SellerComment comment, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return DataInfo.fail("请先登录");
        }
        comment.setBuyerId(loginUser.getId());
        boolean success = sellerCommentService.addComment(comment);
        return success ? DataInfo.ok("评价成功") : DataInfo.fail("您已评价过该订单");
    }

    /**
     * 卖家收到的评价列表（卖家中心）
     */
    @GetMapping("/myComments")
    public String myComments(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/user/toLogin";
        }
        List<SellerComment> comments = sellerCommentService.getCommentsBySellerId(loginUser.getId());
        double avg = sellerCommentService.getAvgRating(loginUser.getId());
        model.addAttribute("comments", comments);
        model.addAttribute("avgRating", avg);
        return "sellerComments";
    }
}