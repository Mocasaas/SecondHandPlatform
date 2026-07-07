package com.secondhand.controller;

import com.github.pagehelper.PageInfo;
import com.secondhand.pojo.Category;
import com.secondhand.pojo.Product;
import com.secondhand.pojo.User;
import com.secondhand.service.CategoryService;
import com.secondhand.service.ProductService;
import com.secondhand.service.SellerCommentService;
import com.secondhand.utils.DataInfo;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.List;

@Controller
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private SellerCommentService sellerCommentService;

    // ========== 首页已移至 IndexController ==========

    @GetMapping("/product/toAdd")
    public String toAdd(Model model) {
        List<Category> categories = categoryService.findAll();
        model.addAttribute("categories", categories);
        return "productAdd";
    }

    @PostMapping("/product/add")
    @ResponseBody
    public DataInfo addProduct(Product product,
                               @RequestParam(value = "file", required = false) MultipartFile file,
                               HttpSession session) {
        try {
            User loginUser = (User) session.getAttribute("loginUser");
            if (loginUser == null) {
                return DataInfo.fail("请先登录");
            }

            product.setUserId(loginUser.getId());
            product.setStatus(0);
            product.setViewCount(0);

            if (file != null && !file.isEmpty()) {
                String originalFilename = file.getOriginalFilename();
                String ext = "";
                if (originalFilename != null && originalFilename.contains(".")) {
                    ext = originalFilename.substring(originalFilename.lastIndexOf("."));
                }
                String newFilename = System.currentTimeMillis() + ext;

                String realPath = session.getServletContext().getRealPath("/images/products/");
                File dir = new File(realPath);
                if (!dir.exists()) {
                    dir.mkdirs();
                }
                File destFile = new File(dir, newFilename);
                file.transferTo(destFile);

                product.setImage("/images/products/" + newFilename);
            }

            productService.addProduct(product);
            return DataInfo.ok("发布成功");

        } catch (Exception e) {
            e.printStackTrace();
            return DataInfo.fail("发布失败：" + e.getMessage());
        }
    }

    /**
     * 商品详情页（浏览次数 +1）
     */
    @GetMapping("/product/detail")
    public String detail(@RequestParam("id") Integer id, Model model) {
        Product product = productService.findById(id);
        if (product == null) {
            return "error/404";
        }
        productService.incrementViewCount(id);
        model.addAttribute("product", product);

        // ===== 新增：查询卖家平均评分 =====
        if (product.getUserId() != null) {
            double avgRating = sellerCommentService.getAvgRating(product.getUserId());
            model.addAttribute("sellerAvgRating", avgRating);
        } else {
            model.addAttribute("sellerAvgRating", 0);
        }

        return "detail";
    }

    @PostMapping("/product/updateStatus")
    @ResponseBody
    public DataInfo updateStatus(@RequestParam("id") Integer id,
                                 @RequestParam("status") Integer status,
                                 HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return DataInfo.fail("请先登录");
        }

        Product product = productService.findById(id);
        if (product == null) {
            return DataInfo.fail("商品不存在");
        }
        if (!product.getUserId().equals(loginUser.getId())) {
            return DataInfo.fail("无权操作该商品");
        }

        if (status == 1) {
            return DataInfo.fail("商品售出由系统自动处理，无需手动操作");
        }
        if (status != 0 && status != 2) {
            return DataInfo.fail("状态参数错误");
        }

        productService.updateStatus(id, status);
        return DataInfo.ok(status == 0 ? "已重新上架" : "已下架");
    }

    @GetMapping("/product/myList")
    public String myList(@RequestParam(defaultValue = "1") Integer pageNum,
                         @RequestParam(defaultValue = "10") Integer pageSize,
                         @RequestParam(required = false) Integer status,
                         HttpSession session,
                         Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/user/toLogin";
        }

        PageInfo<Product> pageInfo = productService.findMyProducts(loginUser.getId(), status, pageNum, pageSize);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("currentStatus", status);
        return "myList";
    }

    @GetMapping("/rank")
    public String rank(@RequestParam(defaultValue = "1") Integer pageNum,
                       @RequestParam(defaultValue = "10") Integer pageSize,
                       Model model) {
        PageInfo<Product> pageInfo = productService.findProductsOrderByViewCount(pageNum, pageSize);
        model.addAttribute("pageInfo", pageInfo);
        return "rank";
    }

    @GetMapping("/product/edit")
    public String edit(@RequestParam("id") Integer id, Model model, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/user/toLogin";
        }
        Product product = productService.findById(id);
        if (product == null || !product.getUserId().equals(loginUser.getId())) {
            return "redirect:/product/myList?error=无权编辑该商品";
        }
        List<Category> categories = categoryService.findAll();
        model.addAttribute("categories", categories);
        model.addAttribute("product", product);
        return "productEdit";
    }

    @PostMapping("/product/update")
    @ResponseBody
    public DataInfo updateProduct(Product product,
                                  @RequestParam(value = "file", required = false) MultipartFile file,
                                  HttpSession session) {
        try {
            User loginUser = (User) session.getAttribute("loginUser");
            if (loginUser == null) {
                return DataInfo.fail("请先登录");
            }
            Product old = productService.findById(product.getId());
            if (old == null || !old.getUserId().equals(loginUser.getId())) {
                return DataInfo.fail("无权操作该商品");
            }
            if (file != null && !file.isEmpty()) {
                String originalFilename = file.getOriginalFilename();
                String ext = "";
                if (originalFilename != null && originalFilename.contains(".")) {
                    ext = originalFilename.substring(originalFilename.lastIndexOf("."));
                }
                String newFilename = System.currentTimeMillis() + ext;
                String realPath = session.getServletContext().getRealPath("/images/products/");
                File dir = new File(realPath);
                if (!dir.exists()) {
                    dir.mkdirs();
                }
                File destFile = new File(dir, newFilename);
                file.transferTo(destFile);
                product.setImage("/images/products/" + newFilename);
            } else {
                product.setImage(old.getImage());
            }
            product.setStatus(old.getStatus());
            product.setUserId(old.getUserId());
            product.setViewCount(old.getViewCount());

            productService.updateProduct(product);
            return DataInfo.ok("修改成功");
        } catch (Exception e) {
            e.printStackTrace();
            return DataInfo.fail("修改失败：" + e.getMessage());
        }
    }
}