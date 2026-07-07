package com.secondhand.controller;

import com.github.pagehelper.PageInfo;
import com.secondhand.pojo.Order;
import com.secondhand.pojo.Product;
import com.secondhand.pojo.SellerComment;
import com.secondhand.pojo.User;
import com.secondhand.service.OrderService;
import com.secondhand.service.ProductService;
import com.secondhand.service.SellerCommentService;
import com.secondhand.utils.DataInfo;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private ProductService productService;

    @Autowired
    private SellerCommentService sellerCommentService;

    /**
     * 单商品确认页面
     */
    @GetMapping("/confirm")
    public String confirm(@RequestParam("productId") Integer productId, Model model, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/user/toLogin";
        }
        Product product = productService.findById(productId);
        if (product == null) {
            return "redirect:/?error=product_not_found";
        }
        if (product.getStatus() != 0) {
            return "redirect:/?error=product_unavailable";
        }
        if (product.getUserId().equals(loginUser.getId())) {
            return "redirect:/?error=self_product";
        }

        List<Product> products = new ArrayList<>();
        products.add(product);
        model.addAttribute("products", products);
        model.addAttribute("isBatch", false);
        model.addAttribute("totalPrice", product.getPrice());
        return "orderConfirm";
    }

    /**
     * 批量确认页面（从购物车结算）
     */
    @GetMapping("/batchConfirm")
    public String batchConfirm(@RequestParam(value = "productIds", required = false) String productIdsStr,
                               Model model, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/user/toLogin";
        }

        System.out.println("===== batchConfirm 接收到的 productIds: " + productIdsStr);

        if (productIdsStr == null || productIdsStr.trim().isEmpty()) {
            System.out.println("===== productIds 为空，重定向到首页");
            return "redirect:/?error=no_products";
        }

        List<Integer> productIds = new ArrayList<>();
        try {
            for (String idStr : productIdsStr.split(",")) {
                idStr = idStr.trim();
                if (!idStr.isEmpty()) {
                    productIds.add(Integer.parseInt(idStr));
                }
            }
        } catch (NumberFormatException e) {
            System.out.println("===== productIds 解析失败: " + e.getMessage());
            return "redirect:/?error=invalid_params";
        }

        if (productIds.isEmpty()) {
            System.out.println("===== productIds 为空列表，重定向到首页");
            return "redirect:/?error=no_products";
        }

        System.out.println("===== 解析后的 productIds: " + productIds);

        List<Product> products = new ArrayList<>();
        double total = 0;
        for (Integer id : productIds) {
            Product product = productService.findById(id);
            if (product != null && product.getStatus() == 0) {
                if (!product.getUserId().equals(loginUser.getId())) {
                    products.add(product);
                    total += product.getPrice().doubleValue();
                } else {
                    System.out.println("===== 商品 " + id + " 是用户自己发布的，跳过");
                }
            } else {
                System.out.println("===== 商品 " + id + " 不存在或已下架");
            }
        }
        if (products.isEmpty()) {
            System.out.println("===== 没有可购买的商品，重定向到首页");
            return "redirect:/?error=products_unavailable";
        }
        System.out.println("===== 可购买商品数量: " + products.size() + ", 总价: " + total);

        model.addAttribute("products", products);
        model.addAttribute("isBatch", true);
        model.addAttribute("totalPrice", total);
        return "orderConfirm";
    }

    /**
     * 单商品下单
     */
    @PostMapping("/create")
    @ResponseBody
    public DataInfo createOrder(@RequestParam("productId") Integer productId, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return DataInfo.fail("请先登录");
        }
        try {
            Order order = orderService.createOrder(productId, loginUser.getId());
            return DataInfo.ok("下单成功", order);
        } catch (Exception e) {
            return DataInfo.fail(e.getMessage());
        }
    }

    /**
     * 批量下单
     */
    @PostMapping("/batchCreate")
    @ResponseBody
    public DataInfo batchCreateOrder(@RequestParam("productIds") String productIdsStr, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return DataInfo.fail("请先登录");
        }
        try {
            List<Integer> productIds = Arrays.stream(productIdsStr.split(","))
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());
            List<Order> orders = orderService.createBatchOrders(productIds, loginUser.getId());
            return DataInfo.ok("批量下单成功", orders);
        } catch (Exception e) {
            return DataInfo.fail(e.getMessage());
        }
    }

    /**
     * 买家订单列表
     */
    @GetMapping("/myOrders")
    public String myOrders(@RequestParam(defaultValue = "1") Integer pageNum,
                           @RequestParam(defaultValue = "10") Integer pageSize,
                           HttpSession session,
                           Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/user/toLogin";
        }
        PageInfo<Order> pageInfo = orderService.findBuyerOrders(loginUser.getId(), pageNum, pageSize);
        model.addAttribute("pageInfo", pageInfo);
        // 查询该买家的所有卖家评价记录，用于判断是否已评价
        List<SellerComment> sellerComments = sellerCommentService.getCommentsByBuyerId(loginUser.getId());
        model.addAttribute("sellerComments", sellerComments);
        return "myOrders";
    }

    /**
     * 卖家订单列表
     */
    @GetMapping("/sellerOrders")
    public String sellerOrders(@RequestParam(defaultValue = "1") Integer pageNum,
                               @RequestParam(defaultValue = "10") Integer pageSize,
                               HttpSession session,
                               Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/user/toLogin";
        }
        PageInfo<Order> pageInfo = orderService.findSellerOrders(loginUser.getId(), pageNum, pageSize);
        model.addAttribute("pageInfo", pageInfo);
        return "sellerOrders";
    }

    /**
     * 取消订单（买家）
     */
    @PostMapping("/cancel")
    @ResponseBody
    public DataInfo cancelOrder(@RequestParam("orderId") Integer orderId, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return DataInfo.fail("请先登录");
        }
        boolean success = orderService.cancelOrder(orderId, loginUser.getId());
        return success ? DataInfo.ok("已取消") : DataInfo.fail("取消失败，请检查订单状态");
    }

    /**
     * 确认收货（买家）
     */
    @PostMapping("/confirmReceipt")
    @ResponseBody
    public DataInfo confirmReceipt(@RequestParam("orderId") Integer orderId, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return DataInfo.fail("请先登录");
        }
        boolean success = orderService.confirmReceipt(orderId, loginUser.getId());
        return success ? DataInfo.ok("已确认收货") : DataInfo.fail("确认失败");
    }

    /**
     * 卖家发货
     */
    @PostMapping("/ship")
    @ResponseBody
    public DataInfo shipOrder(@RequestParam("orderId") Integer orderId, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return DataInfo.fail("请先登录");
        }
        Order order = orderService.findById(orderId);
        if (order == null) {
            return DataInfo.fail("订单不存在");
        }
        if (!order.getSellerId().equals(loginUser.getId())) {
            return DataInfo.fail("无权操作该订单");
        }
        if (order.getStatus() != 1) {
            return DataInfo.fail("当前状态无法发货，只有待发货的订单才能操作");
        }
        orderService.updateOrderStatus(orderId, 2);
        return DataInfo.ok("发货成功");
    }

    /**
     * 获取卖家总收入
     */
    @GetMapping("/income")
    @ResponseBody
    public DataInfo getIncome(HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return DataInfo.fail("请先登录");
        }
        BigDecimal income = orderService.sumTotalAmountBySellerId(loginUser.getId());
        return DataInfo.ok(income);
    }
}