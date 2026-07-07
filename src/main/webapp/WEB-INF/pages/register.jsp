<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>注册账号 - 二手交易平台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        .reg-box {
            width: 400px;
            margin: 80px auto;
            background: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.1);
        }
        .reg-box h2 { text-align: center; margin-bottom: 30px; }
        .error { color: #FF5722; text-align: center; margin-bottom: 15px; }
        .reg-box .layui-btn { width: 100%; }
        .login-link { text-align: center; margin-top: 15px; }
        .login-link a { color: #1E9FFF; }
    </style>
</head>
<body style="background: #f0f2f5;">
<div class="reg-box">
    <h2>📝 注册新账号</h2>

    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <!-- 注意：这是一个普通的 form 提交，没有 lay-submit，不会触发 AJAX -->
    <form action="${pageContext.request.contextPath}/user/register" method="post">
        <div class="layui-form-item">
            <input type="text" name="username" placeholder="用户名（必填）" class="layui-input" required>
        </div>
        <div class="layui-form-item">
            <input type="password" name="password" placeholder="密码（必填）" class="layui-input" required>
        </div>
        <div class="layui-form-item">
            <input type="text" name="phone" placeholder="手机号（选填）" class="layui-input">
        </div>
        <div class="layui-form-item">
            <input type="text" name="wechat" placeholder="微信号（选填）" class="layui-input">
        </div>
        <button type="submit" class="layui-btn layui-btn-fluid layui-btn-normal">立 即 注 册</button>
    </form>

    <div class="login-link">
        <a href="${pageContext.request.contextPath}/user/toLogin">已有账号？去登录</a>
    </div>
</div>
</body>
</html>