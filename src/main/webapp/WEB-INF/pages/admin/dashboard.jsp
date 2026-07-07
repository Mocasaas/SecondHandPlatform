<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理后台 - 二手交易平台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        body { background: #f0f2f5; font-family: "Microsoft YaHei", sans-serif; }
        .header {
            background: linear-gradient(135deg, #1E9FFF, #007BFF);
            color: #fff;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        .header h1 { margin: 0; font-size: 24px; font-weight: bold; }
        .header h1 span { opacity: 0.8; font-size: 14px; font-weight: normal; margin-left: 15px; }
        .header .user-info { display: flex; align-items: center; gap: 15px; }
        .header .user-info a { color: #fff; text-decoration: none; opacity: 0.9; transition: opacity 0.3s; }
        .header .user-info a:hover { opacity: 1; text-decoration: underline; }
        .admin-tag { background: rgba(255,255,255,0.2); padding: 4px 14px; border-radius: 20px; font-size: 13px; }
        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 35px;
        }
        .stat-card {
            background: #fff;
            padding: 25px 20px;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        }
        .stat-card .number { font-size: 36px; font-weight: bold; color: #1E9FFF; }
        .stat-card .label { color: #999; font-size: 14px; margin-top: 5px; }
        .stat-card:nth-child(2) .number { color: #FFB800; }
        .stat-card:nth-child(3) .number { color: #5FB878; }
        .stat-card:nth-child(4) .number { color: #FF5722; }

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 20px;
        }
        .menu-card {
            background: #fff;
            padding: 30px 20px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            transition: all 0.3s;
            cursor: pointer;
            text-decoration: none;
            color: #333;
            display: block;
        }
        .menu-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        }
        .menu-card .icon { font-size: 44px; display: block; margin-bottom: 10px; }
        .menu-card .name { font-size: 16px; font-weight: bold; }
        .menu-card .desc { font-size: 13px; color: #999; margin-top: 4px; }

        .menu-card:nth-child(1) .icon { color: #1E9FFF; }
        .menu-card:nth-child(2) .icon { color: #FFB800; }
        .menu-card:nth-child(3) .icon { color: #5FB878; }
        .menu-card:nth-child(4) .icon { color: #FF5722; }
        .menu-card:nth-child(5) .icon { color: #9B59B6; }

        .footer { text-align: center; color: #999; font-size: 13px; margin-top: 40px; padding: 20px 0; border-top: 1px solid #e6e6e6; }

        @media (max-width: 768px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .menu-grid { grid-template-columns: repeat(2, 1fr); }
            .header { flex-direction: column; gap: 10px; text-align: center; }
        }
        @media (max-width: 480px) {
            .stats-grid { grid-template-columns: 1fr; }
            .menu-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<!-- 顶部栏 -->
<div class="header">
    <h1>📊 管理后台 <span>二手交易平台</span></h1>
    <div class="user-info">
        <span class="admin-tag">🔑 管理员</span>
        <span>欢迎，<b>${sessionScope.loginUser.username}</b></span>
        <a href="${pageContext.request.contextPath}/">← 返回首页</a>
        <a href="${pageContext.request.contextPath}/user/logout">退出登录</a>
    </div>
</div>

<!-- 主要内容 -->
<div class="container">

    <!-- 统计卡片 -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="number" id="totalProducts">-</div>
            <div class="label">📦 商品总数</div>
        </div>
        <div class="stat-card">
            <div class="number" id="totalOrders">-</div>
            <div class="label">📋 订单总数</div>
        </div>
        <div class="stat-card">
            <div class="number" id="totalUsers">-</div>
            <div class="label">👤 用户总数</div>
        </div>
        <div class="stat-card">
            <div class="number" id="pendingOrders">-</div>
            <div class="label">⏳ 待处理订单</div>
        </div>
    </div>

    <!-- 功能入口 -->
    <div class="menu-grid">
        <a href="${pageContext.request.contextPath}/admin/products" class="menu-card">
            <span class="icon">📦</span>
            <span class="name">商品管理</span>
            <span class="desc">查看、搜索、下架、删除所有商品</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/orders" class="menu-card">
            <span class="icon">📋</span>
            <span class="name">订单管理</span>
            <span class="desc">查看所有订单、更新订单状态</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="menu-card">
            <span class="icon">👤</span>
            <span class="name">用户管理</span>
            <span class="desc">封禁/解封用户、重置密码</span>
        </a>
        <a href="${pageContext.request.contextPath}/category/manage" class="menu-card">
            <span class="icon">📁</span>
            <span class="name">分类管理</span>
            <span class="desc">添加、编辑、删除商品分类</span>
        </a>
        <a href="${pageContext.request.contextPath}/notice/manage" class="menu-card">
            <span class="icon">📢</span>
            <span class="name">公告管理</span>
            <span class="desc">发布、编辑、删除平台公告</span>
        </a>
    </div>

    <div class="footer">
        © 二手交易平台 · 管理后台 v1.0
    </div>
</div>

<script src="${pageContext.request.contextPath}/lib/layui/layui.js"></script>
<script>
    layui.use(['jquery'], function() {
        var $ = layui.$;

        function loadStats() {
            // 商品总数
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/stat/productCount',
                type: 'GET',
                dataType: 'json',
                success: function(res) {
                    console.log('商品总数响应:', res);
                    if (res.code === 0) {
                        $('#totalProducts').text(res.data || 0);
                    } else {
                        $('#totalProducts').text('0');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('商品总数请求失败:', status, error);
                    $('#totalProducts').text('错误');
                }
            });

            // 订单总数
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/stat/orderCount',
                type: 'GET',
                dataType: 'json',
                success: function(res) {
                    console.log('订单总数响应:', res);
                    if (res.code === 0) {
                        $('#totalOrders').text(res.data || 0);
                    } else {
                        $('#totalOrders').text('0');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('订单总数请求失败:', status, error);
                    $('#totalOrders').text('错误');
                }
            });

            // 用户总数
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/stat/userCount',
                type: 'GET',
                dataType: 'json',
                success: function(res) {
                    console.log('用户总数响应:', res);
                    if (res.code === 0) {
                        $('#totalUsers').text(res.data || 0);
                    } else {
                        $('#totalUsers').text('0');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('用户总数请求失败:', status, error);
                    $('#totalUsers').text('错误');
                }
            });

            // 待处理订单数
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/stat/pendingOrderCount',
                type: 'GET',
                dataType: 'json',
                success: function(res) {
                    console.log('待处理订单响应:', res);
                    if (res.code === 0) {
                        $('#pendingOrders').text(res.data || 0);
                    } else {
                        $('#pendingOrders').text('0');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('待处理订单请求失败:', status, error);
                    $('#pendingOrders').text('错误');
                }
            });
        }

        // 页面加载后执行
        loadStats();
    });
</script>

</body>
</html>