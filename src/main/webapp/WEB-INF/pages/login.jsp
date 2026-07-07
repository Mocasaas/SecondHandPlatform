<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>二手交易平台 - 登录</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        .login-box { width: 400px; margin: 100px auto; background: #fff; padding: 40px; border-radius: 8px; box-shadow: 0 2px 12px rgba(0,0,0,0.1); }
        .login-box h2 { text-align: center; margin-bottom: 30px; }
        .error { color: #FF5722; text-align: center; margin-bottom: 15px; }
        .success { color: #5FB878; text-align: center; margin-bottom: 15px; }
        .register-link { text-align: center; margin-top: 15px; }
        .register-link a { color: #1E9FFF; }
    </style>
</head>
<body style="background: #f0f2f5;">
<div class="login-box">
    <h2>👋 二手交易平台</h2>

    <!-- 显示错误信息（登录失败） -->
    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <!-- 显示成功信息（注册成功） -->
    <c:if test="${not empty param.msg}">
        <div class="success">✅ ${param.msg}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/user/login" method="post">
        <div class="layui-form-item">
            <input type="text" name="username" placeholder="请输入用户名" class="layui-input" required>
        </div>
        <div class="layui-form-item">
            <input type="password" name="password" placeholder="请输入密码" class="layui-input" required>
        </div>
        <button type="submit" class="layui-btn layui-btn-fluid layui-btn-normal">登 录</button>
    </form>

    <div class="register-link">
        <a href="${pageContext.request.contextPath}/user/toRegister">还没有账号？去注册</a>
    </div>
</div>
</body>
</html>