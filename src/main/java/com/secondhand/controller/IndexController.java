package com.secondhand.controller;

import com.github.pagehelper.PageInfo;
import com.secondhand.pojo.Category;
import com.secondhand.pojo.Notice;
import com.secondhand.pojo.Product;
import com.secondhand.service.CategoryService;
import com.secondhand.service.NoticeService;
import com.secondhand.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class IndexController {

    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private NoticeService noticeService;

    /**
     * 首页：轮播图 + 分类导航 + 新发布商品
     */
    @GetMapping("/")
    public String index(@RequestParam(defaultValue = "1") Integer pageNum,
                        @RequestParam(defaultValue = "8") Integer pageSize,
                        @RequestParam(required = false) String keyword,
                        @RequestParam(required = false) Integer categoryId,
                        Model model) {

        // 1. 新发布商品列表（按创建时间降序）
        PageInfo<Product> pageInfo = productService.findProducts(keyword, categoryId, pageNum, pageSize);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("keyword", keyword);
        model.addAttribute("categoryId", categoryId);

        // 2. 所有分类（用于下拉菜单）
        List<Category> categories = categoryService.findAll();
        model.addAttribute("categories", categories);

        // 3. 轮播图公告（置顶或热卖类型）
        List<Notice> carouselNotices = noticeService.getCarouselNotices();
        model.addAttribute("carouselNotices", carouselNotices);

        // 4. 浏览排行榜（按浏览量排序，取前6）
        PageInfo<Product> rankPage = productService.findProducts(null, null, 1, 6);
        List<Product> rankProducts = rankPage.getList();
        model.addAttribute("rankProducts", rankProducts);

        return "index";
    }
}