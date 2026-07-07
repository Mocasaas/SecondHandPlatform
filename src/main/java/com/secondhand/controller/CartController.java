package com.secondhand.controller;

import com.secondhand.pojo.Cart;
import com.secondhand.pojo.User;
import com.secondhand.service.CartService;
import com.secondhand.utils.DataInfo;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @GetMapping("/list")
    public String list(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/user/toLogin";
        }
        List<Cart> cartList = cartService.getCartList(loginUser.getId());
        double total = 0;
        for (Cart cart : cartList) {
            if (cart.getProduct() != null && cart.getProduct().getStatus() == 0) {
                total += cart.getProduct().getPrice().doubleValue() * cart.getQuantity();
            }
        }
        model.addAttribute("cartList", cartList);
        model.addAttribute("total", total);
        return "cart";
    }

    @PostMapping("/add")
    @ResponseBody
    public DataInfo add(@RequestParam("productId") Integer productId,
                        @RequestParam(defaultValue = "1") Integer quantity,
                        HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return DataInfo.fail("请先登录");
        }
        if (quantity <= 0) {
            quantity = 1;
        }
        boolean success = cartService.addToCart(loginUser.getId(), productId, quantity);
        if (success) {
            return DataInfo.ok("已加入购物车");
        } else {
            return DataInfo.fail("加入购物车失败，商品可能已下架或不能购买自己的商品");
        }
    }

    @PostMapping("/update")
    @ResponseBody
    public DataInfo update(@RequestParam("cartId") Integer cartId,
                           @RequestParam("quantity") Integer quantity,
                           HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return DataInfo.fail("请先登录");
        }
        if (quantity <= 0) {
            return DataInfo.fail("数量必须大于0");
        }
        boolean success = cartService.updateQuantity(cartId, quantity);
        return success ? DataInfo.ok("更新成功") : DataInfo.fail("更新失败");
    }

    // ========== 删除购物车商品（已加固） ==========
    @PostMapping("/delete")
    @ResponseBody
    public DataInfo delete(@RequestParam("cartId") Integer cartId,
                           HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return DataInfo.fail("请先登录");
        }
        if (cartId == null || cartId <= 0) {
            return DataInfo.fail("参数错误");
        }
        boolean success = cartService.deleteCartItem(cartId, loginUser.getId());
        return success ? DataInfo.ok("已删除") : DataInfo.fail("删除失败");
    }

    /**
     * 结算购物车 - 返回商品ID列表
     */
    @PostMapping("/checkout")
    @ResponseBody
    public DataInfo checkout(@RequestParam("cartIds") String cartIdsStr,
                             HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return DataInfo.fail("请先登录");
        }

        if (cartIdsStr == null || cartIdsStr.trim().isEmpty()) {
            return DataInfo.fail("请选择要结算的商品");
        }

        List<Integer> cartIds = new ArrayList<>();
        try {
            for (String idStr : cartIdsStr.split(",")) {
                idStr = idStr.trim();
                if (!idStr.isEmpty()) {
                    cartIds.add(Integer.parseInt(idStr));
                }
            }
        } catch (NumberFormatException e) {
            return DataInfo.fail("参数格式错误");
        }

        if (cartIds.isEmpty()) {
            return DataInfo.fail("请选择要结算的商品");
        }

        List<Cart> selectedCarts = cartService.getSelectedCarts(loginUser.getId(), cartIds);
        if (selectedCarts == null || selectedCarts.isEmpty()) {
            return DataInfo.fail("所选商品已不可购买");
        }

        List<Integer> productIds = new ArrayList<>();
        for (Cart cart : selectedCarts) {
            if (cart.getProductId() != null) {
                productIds.add(cart.getProductId());
            }
        }

        if (productIds.isEmpty()) {
            return DataInfo.fail("所选商品无效");
        }

        String productIdsStr = productIds.stream().map(String::valueOf).collect(Collectors.joining(","));
        return DataInfo.ok("成功", productIdsStr);
    }
}