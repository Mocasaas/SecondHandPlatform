package com.secondhand.controller;

import com.secondhand.pojo.Notice;
import com.secondhand.pojo.User;
import com.secondhand.service.NoticeService;
import com.secondhand.utils.DataInfo;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/notice")
public class NoticeController {

    @Autowired
    private NoticeService noticeService;

    /**
     * 公告列表页（用户端）
     */
    @GetMapping("/list")
    public String list(Model model) {
        List<Notice> notices = noticeService.getPublishedNotices();
        model.addAttribute("notices", notices);
        return "notices";
    }

    /**
     * 公告详情页（用户端）
     */
    @GetMapping("/detail")
    public String detail(@RequestParam("id") Integer id, Model model) {
        Notice notice = noticeService.getNoticeById(id);
        if (notice == null) {
            return "redirect:/";
        }
        // 浏览次数+1
        noticeService.incrementViewCount(id);
        model.addAttribute("notice", notice);
        return "noticeDetail";
    }

    /**
     * 获取公告详情（JSON接口，供管理员编辑使用）
     */
    @GetMapping("/get")
    @ResponseBody
    public DataInfo getNotice(@RequestParam("id") Integer id) {
        Notice notice = noticeService.getNoticeById(id);
        if (notice == null) {
            return DataInfo.fail("公告不存在");
        }
        return DataInfo.ok(notice);
    }

    // ========== 管理员接口 ==========

    /**
     * 管理员公告管理页面
     */
    @GetMapping("/manage")
    public String manage(Model model) {
        List<Notice> notices = noticeService.getAllNotices(null);
        model.addAttribute("notices", notices);
        return "admin/notices";
    }

    /**
     * 新增公告
     */
    @PostMapping("/add")
    @ResponseBody
    public DataInfo addNotice(Notice notice, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
            return DataInfo.fail("无权限");
        }
        boolean success = noticeService.addNotice(notice);
        return success ? DataInfo.ok("添加成功") : DataInfo.fail("添加失败");
    }

    /**
     * 修改公告
     */
    @PostMapping("/update")
    @ResponseBody
    public DataInfo updateNotice(Notice notice, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
            return DataInfo.fail("无权限");
        }
        boolean success = noticeService.updateNotice(notice);
        return success ? DataInfo.ok("修改成功") : DataInfo.fail("修改失败");
    }

    /**
     * 删除公告
     */
    @PostMapping("/delete")
    @ResponseBody
    public DataInfo deleteNotice(@RequestParam("id") Integer id, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() == null || loginUser.getRole() != 1) {
            return DataInfo.fail("无权限");
        }
        boolean success = noticeService.deleteNotice(id);
        return success ? DataInfo.ok("删除成功") : DataInfo.fail("删除失败");
    }

    /**
     * 获取所有公告（JSON接口）
     */
    @GetMapping("/all")
    @ResponseBody
    public DataInfo getAll() {
        List<Notice> notices = noticeService.getPublishedNotices();
        return DataInfo.ok(notices);
    }
}