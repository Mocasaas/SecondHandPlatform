<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>个人中心 - 二手交易平台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        body { background: #f5f5f5; }
        .profile-container { max-width: 800px; margin: 30px auto; background: #fff; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.1); overflow: hidden; }
        .profile-header { background: linear-gradient(135deg, #1E9FFF, #5FB878); color: #fff; padding: 40px; text-align: center; }
        .profile-header .avatar { width: 100px; height: 100px; border-radius: 50%; border: 4px solid rgba(255,255,255,0.8); object-fit: cover; background: #fff; margin-bottom: 15px; }
        .profile-header .username { font-size: 22px; font-weight: bold; }
        .profile-header .role-tag { display: inline-block; padding: 2px 15px; border-radius: 20px; font-size: 13px; margin-top: 5px; background: rgba(255,255,255,0.2); }
        .profile-body { padding: 30px 40px; }
        .profile-body .info-grid { display: flex; flex-wrap: wrap; gap: 20px; }
        .profile-body .info-item { flex: 1; min-width: 200px; padding: 15px; background: #f8f8f8; border-radius: 8px; }
        .profile-body .info-item .label { color: #999; font-size: 13px; }
        .profile-body .info-item .value { font-size: 16px; font-weight: bold; color: #333; margin-top: 5px; }
        .profile-body .info-item .value.income { color: #FF5722; font-size: 24px; }
        .profile-body .info-item .value.rating { color: #FFB800; font-size: 20px; }
        .profile-body .form-section { margin-top: 30px; border-top: 1px solid #f0f0f0; padding-top: 25px; }
        .profile-body .form-section .layui-input-block { margin-left: 0; }
        .profile-body .form-section .layui-form-item { display: flex; align-items: center; gap: 15px; }
        .profile-body .form-section .layui-form-item label { width: 80px; color: #666; flex-shrink: 0; }
        .profile-body .form-section .layui-form-item input { flex: 1; max-width: 300px; }
        .action-buttons { display: flex; gap: 15px; flex-wrap: wrap; margin-top: 25px; padding-top: 20px; border-top: 1px solid #f0f0f0; }
        .action-buttons .layui-btn { min-width: 120px; }
        .unread-badge { background: #FF5722; color: #fff; border-radius: 50%; padding: 2px 8px; font-size: 12px; margin-left: 5px; }
    </style>
</head>
<body>

<div class="profile-container">

    <div class="profile-header">
        <c:if test="${not empty user.avatar}">
            <img src="${pageContext.request.contextPath}${user.avatar}" alt="头像" class="avatar">
        </c:if>
        <c:if test="${empty user.avatar}">
            <img src="${pageContext.request.contextPath}/lib/layui/images/face/0.gif" alt="默认头像" class="avatar">
        </c:if>
        <div class="username">${user.username}</div>
        <div class="role-tag">
            <c:if test="${user.role == 1}">🔑 管理员</c:if>
            <c:if test="${user.role == 0}">👤 普通用户</c:if>
        </div>
        <div style="margin-top:10px;font-size:14px;opacity:0.8;">
            <c:if test="${user.status == 0}">✅ 账号状态：正常</c:if>
            <c:if test="${user.status == 1}">⛔ 账号状态：已封禁</c:if>
        </div>
    </div>

    <div class="profile-body">
        <div class="info-grid">
            <div class="info-item">
                <div class="label">📱 手机号</div>
                <div class="value">${user.phone}</div>
            </div>
            <div class="info-item">
                <div class="label">💬 微信号</div>
                <div class="value">${user.wechat}</div>
            </div>
            <div class="info-item">
                <div class="label">📅 注册时间</div>
                <div class="value"><fmt:formatDate value="${user.createTime}" pattern="yyyy年MM月dd日 HH:mm:ss"/></div>
            </div>
            <div class="info-item">
                <div class="label">💰 总收入</div>
                <div class="value income" id="totalIncome">加载中...</div>
            </div>
            <div class="info-item">
                <div class="label">⭐ 卖家评分</div>
                <div class="value rating">
                    <c:if test="${userAvgRating > 0}">
                        ⭐ <fmt:formatNumber value="${userAvgRating}" pattern="#.#"/> 分
                    </c:if>
                    <c:if test="${userAvgRating == 0}">
                        暂无评分
                    </c:if>
                </div>
            </div>
        </div>

        <div class="form-section">
            <h4 style="margin-bottom:15px;">✏️ 修改个人信息</h4>
            <form class="layui-form" id="profileForm">
                <div class="layui-form-item">
                    <label>手机号</label>
                    <input type="text" name="phone" value="${user.phone}" placeholder="请输入手机号" class="layui-input">
                </div>
                <div class="layui-form-item">
                    <label>微信号</label>
                    <input type="text" name="wechat" value="${user.wechat}" placeholder="请输入微信号" class="layui-input">
                </div>
                <div class="layui-form-item" style="margin-top:15px;">
                    <label></label>
                    <button type="button" class="layui-btn layui-btn-normal" id="saveBtn">保存修改</button>
                </div>
            </form>
        </div>

        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/favorite/list" class="layui-btn layui-btn-normal">
                ❤️ 我的收藏
            </a>
            <a href="${pageContext.request.contextPath}/product/myList" class="layui-btn layui-btn-primary">
                📦 我的发布
            </a>
            <a href="${pageContext.request.contextPath}/order/myOrders" class="layui-btn layui-btn-primary">
                📋 我的订单
            </a>
            <c:if test="${user.role == 1}">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="layui-btn layui-btn-danger">
                    📊 管理后台
                </a>
            </c:if>
            <a href="${pageContext.request.contextPath}/" class="layui-btn layui-btn-primary">
                🏠 返回首页
            </a>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/lib/layui/layui.js"></script>
<script>
    layui.use(['layer', 'jquery'], function() {
        var layer = layui.layer;
        var $ = layui.$;

        // 保存资料
        $('#saveBtn').click(function() {
            var phone = $('input[name="phone"]').val();
            var wechat = $('input[name="wechat"]').val();

            $.ajax({
                url: '${pageContext.request.contextPath}/user/updateProfile',
                type: 'POST',
                data: { phone: phone, wechat: wechat },
                dataType: 'json',
                success: function(res) {
                    if (res.code === 0) {
                        layer.msg('✅ ' + res.msg, {icon: 1});
                        setTimeout(function() { location.reload(); }, 800);
                    } else {
                        layer.msg('❌ ' + res.msg, {icon: 2});
                    }
                },
                error: function() {
                    layer.msg('网络异常，请重试', {icon: 2});
                }
            });
        });

        // 加载总收入
        $.ajax({
            url: '${pageContext.request.contextPath}/order/income',
            type: 'GET',
            dataType: 'json',
            success: function(res) {
                if (res.code === 0) {
                    $('#totalIncome').text('¥ ' + res.data.toFixed(2));
                } else {
                    $('#totalIncome').text('¥ 0.00');
                }
            },
            error: function() {
                $('#totalIncome').text('加载失败');
            }
        });
    });
</script>

</body>
</html>