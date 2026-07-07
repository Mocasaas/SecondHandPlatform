package com.secondhand.controller;

import com.github.pagehelper.PageInfo;
import com.secondhand.pojo.Order;
import com.secondhand.pojo.Product;
import com.secondhand.pojo.User;
import com.secondhand.service.OrderService;
import com.secondhand.service.ProductService;
import com.secondhand.service.UserService;
import com.secondhand.utils.DataInfo;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private ProductService productService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private UserService userService;

    /**
     * 管理员后台首页
     */
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
            return "redirect:/";
        }
        return "admin/dashboard";
    }

    // ==================== 商品管理 ====================

    @GetMapping("/products")
    public String products(@RequestParam(defaultValue = "1") Integer pageNum,
                           @RequestParam(defaultValue = "10") Integer pageSize,
                           @RequestParam(required = false) String keyword,
                           @RequestParam(required = false) Integer categoryId,
                           HttpSession session,
                           Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
            return "redirect:/";
        }
        PageInfo<Product> pageInfo = productService.findAllProducts(keyword, categoryId, pageNum, pageSize);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("keyword", keyword);
        model.addAttribute("categoryId", categoryId);
        return "admin/products";
    }

    @PostMapping("/product/delete")
    @ResponseBody
    public DataInfo deleteProduct(@RequestParam("id") Integer id, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
            return DataInfo.fail("无权限");
        }
        productService.deleteProduct(id);
        return DataInfo.ok("删除成功");
    }

    @PostMapping("/product/updateStatus")
    @ResponseBody
    public DataInfo updateProductStatus(@RequestParam("id") Integer id,
                                        @RequestParam("status") Integer status,
                                        HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
            return DataInfo.fail("无权限");
        }
        productService.updateStatus(id, status);
        return DataInfo.ok("操作成功");
    }

    // ==================== 订单管理 ====================

    @GetMapping("/orders")
    public String orders(@RequestParam(defaultValue = "1") Integer pageNum,
                         @RequestParam(defaultValue = "10") Integer pageSize,
                         @RequestParam(required = false) String keyword,
                         HttpSession session,
                         Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
            return "redirect:/";
        }
        PageInfo<Order> pageInfo = orderService.findAllOrders(keyword, pageNum, pageSize);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("keyword", keyword);
        return "admin/orders";
    }

    @PostMapping("/order/updateStatus")
    @ResponseBody
    public DataInfo updateOrderStatus(@RequestParam("id") Integer id,
                                      @RequestParam("status") Integer status,
                                      HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
            return DataInfo.fail("无权限");
        }
        orderService.updateOrderStatus(id, status);
        return DataInfo.ok("操作成功");
    }

    // ==================== 用户管理 ====================

    @GetMapping("/users")
    public String users(@RequestParam(defaultValue = "1") Integer pageNum,
                        @RequestParam(defaultValue = "10") Integer pageSize,
                        @RequestParam(required = false) String keyword,
                        HttpSession session,
                        Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
            return "redirect:/";
        }
        PageInfo<User> pageInfo = userService.findAllUsers(keyword, pageNum, pageSize);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("keyword", keyword);
        return "admin/users";
    }

    @PostMapping("/user/ban")
    @ResponseBody
    public DataInfo banUser(@RequestParam("id") Integer id, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
            return DataInfo.fail("无权限");
        }
        if (id.equals(loginUser.getId())) {
            return DataInfo.fail("不能封禁自己");
        }
        userService.banUser(id);
        return DataInfo.ok("已封禁");
    }

    @PostMapping("/user/unban")
    @ResponseBody
    public DataInfo unbanUser(@RequestParam("id") Integer id, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
            return DataInfo.fail("无权限");
        }
        userService.unbanUser(id);
        return DataInfo.ok("已解封");
    }

    @PostMapping("/user/resetPassword")
    @ResponseBody
    public DataInfo resetPassword(@RequestParam("id") Integer id,
                                  @RequestParam("newPassword") String newPassword,
                                  HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
            return DataInfo.fail("无权限");
        }
        if (newPassword == null || newPassword.length() < 4) {
            return DataInfo.fail("密码至少4位");
        }
        userService.resetPassword(id, newPassword);
        return DataInfo.ok("密码已重置");
    }

    // ========== 🆕 统计数据JSON接口 ==========

    /**
     * 获取商品总数
     */
    @GetMapping("/stat/productCount")
    @ResponseBody
    public DataInfo getProductCount() {
        try {
            // 查询第一页，但只取总数
            PageInfo<Product> pageInfo = productService.findAllProducts(null, null, 1, 1);
            long count = pageInfo.getTotal();
            return DataInfo.ok(count);
        } catch (Exception e) {
            e.printStackTrace();
            return DataInfo.fail("查询失败");
        }
    }

    /**
     * 获取订单总数
     */
    @GetMapping("/stat/orderCount")
    @ResponseBody
    public DataInfo getOrderCount() {
        try {
            PageInfo<Order> pageInfo = orderService.findAllOrders(null, 1, 1);
            long count = pageInfo.getTotal();
            return DataInfo.ok(count);
        } catch (Exception e) {
            e.printStackTrace();
            return DataInfo.fail("查询失败");
        }
    }

    /**
     * 获取用户总数
     */
    @GetMapping("/stat/userCount")
    @ResponseBody
    public DataInfo getUserCount() {
        try {
            PageInfo<User> pageInfo = userService.findAllUsers(null, 1, 1);
            long count = pageInfo.getTotal();
            return DataInfo.ok(count);
        } catch (Exception e) {
            e.printStackTrace();
            return DataInfo.fail("查询失败");
        }
    }

    /**
     * 获取待处理订单数（状态为待发货，即status=1）
     */
    @GetMapping("/stat/pendingOrderCount")
    @ResponseBody
    public DataInfo getPendingOrderCount() {
        try {
            // 查询所有订单，手动统计status=1的个数
            PageInfo<Order> pageInfo = orderService.findAllOrders(null, 1, Integer.MAX_VALUE);
            long count = 0;
            for (Order order : pageInfo.getList()) {
                if (order.getStatus() != null && order.getStatus() == 1) {
                    count++;
                }
            }
            return DataInfo.ok(count);
        } catch (Exception e) {
            e.printStackTrace();
            return DataInfo.fail("查询失败");
        }
    }
}