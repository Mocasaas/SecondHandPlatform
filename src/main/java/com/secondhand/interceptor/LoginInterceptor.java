package com.secondhand.interceptor;

import com.secondhand.pojo.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // 放行不需要登录的路径
        if (path.equals("/") || path.equals("/index.jsp")) {
            return true;
        }
        if (path.startsWith("/user/toLogin") || path.startsWith("/user/login") ||
                path.startsWith("/user/toRegister") || path.startsWith("/user/register")) {
            return true;
        }
        if (path.startsWith("/lib/") || path.startsWith("/images/")) {
            return true;
        }
        if (path.startsWith("/product/detail")) {
            return true;
        }
        // 分类列表接口（首页下拉需要）
        if (path.startsWith("/category/list")) {
            return true;
        }
        // 公告相关（用户端查看不需要登录）
        if (path.startsWith("/notice/list") || path.startsWith("/notice/detail")) {
            return true;
        }

        // 检查是否登录
        if (loginUser == null) {
            response.sendRedirect(contextPath + "/user/toLogin");
            return false;
        }

        // ========== 检查用户是否被封禁 ==========
        if (loginUser.getStatus() != null && loginUser.getStatus() == 1) {
            session.invalidate();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write("<script>alert('您的账号已被封禁，请联系管理员');window.location.href='" + contextPath + "/user/toLogin';</script>");
            return false;
        }

        // ========== 管理员专用路径 ==========
        if (path.startsWith("/admin/") || path.startsWith("/category/manage") ||
                path.startsWith("/category/add") || path.startsWith("/category/update") ||
                path.startsWith("/category/delete") || path.startsWith("/notice/manage") ||
                path.startsWith("/notice/add") || path.startsWith("/notice/update") ||
                path.startsWith("/notice/delete") || path.startsWith("/notice/get")) {

            if (loginUser.getRole() == null || loginUser.getRole() != 1) {
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().write("<script>alert('您没有管理员权限，无法访问该功能');window.location.href='" + contextPath + "/';</script>");
                return false;
            }
        }

        // ========== 普通用户功能：管理员不能访问 ==========
        if (path.startsWith("/product/toAdd") || path.startsWith("/product/add") ||
                path.startsWith("/product/myList") || path.startsWith("/order/myOrders") ||
                path.startsWith("/order/sellerOrders") || path.startsWith("/order/confirm") ||
                path.startsWith("/order/create") || path.startsWith("/order/cancel") ||
                path.startsWith("/order/confirmReceipt") || path.startsWith("/order/ship") ||
                path.startsWith("/cart/") || path.startsWith("/favorite/") ||
                path.startsWith("/sellerComment/")) {

            if (loginUser.getRole() != null && loginUser.getRole() == 1) {
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().write("<script>alert('管理员不能使用此功能');window.location.href='" + contextPath + "/';</script>");
                return false;
            }
        }

        return true;
    }
}