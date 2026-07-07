package com.secondhand.controller;

import com.secondhand.pojo.Category;
import com.secondhand.pojo.User;
import com.secondhand.service.CategoryService;
import com.secondhand.utils.DataInfo;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/category")
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    @GetMapping("/manage")
    public String manage(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        // 权限校验（双重保险）
        if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
            return "redirect:/";
        }
        List<Category> categories = categoryService.findAll();
        model.addAttribute("categories", categories);
        return "categoryManage";
    }

    @GetMapping("/list")
    @ResponseBody
    public DataInfo list() {
        List<Category> categories = categoryService.findAll();
        return DataInfo.ok(categories);
    }

    @PostMapping("/add")
    @ResponseBody
    public DataInfo add(@RequestParam("name") String name, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
            return DataInfo.fail("无权限");
        }
        if (name == null || name.trim().isEmpty()) {
            return DataInfo.fail("分类名称不能为空");
        }
        Category category = new Category();
        category.setName(name.trim());
        categoryService.addCategory(category);
        return DataInfo.ok("添加成功");
    }

    @PostMapping("/update")
    @ResponseBody
    public DataInfo update(@RequestParam("id") Integer id, @RequestParam("name") String name, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
            return DataInfo.fail("无权限");
        }
        if (name == null || name.trim().isEmpty()) {
            return DataInfo.fail("分类名称不能为空");
        }
        Category category = new Category();
        category.setId(id);
        category.setName(name.trim());
        categoryService.updateCategory(category);
        return DataInfo.ok("修改成功");
    }

    @PostMapping("/delete")
    @ResponseBody
    public DataInfo delete(@RequestParam("id") Integer id, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
            return DataInfo.fail("无权限");
        }
        categoryService.deleteCategory(id);
        return DataInfo.ok("删除成功");
    }
}