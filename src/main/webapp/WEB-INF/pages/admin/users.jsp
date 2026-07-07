<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户管理 - 管理员</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        body { background: #f5f5f5; }
        .container { max-width: 1000px; margin: 20px auto; padding: 0 15px; }
        .header-bar { background: #fff; padding: 15px 25px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 10px; }
        .search-box { display: flex; gap: 10px; }
        .search-box input { height: 36px; padding: 0 10px; border: 1px solid #ddd; border-radius: 4px; }
        .search-box input:focus { border-color: #1E9FFF; outline: none; }
        .table-wrap { background: #fff; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); padding: 15px; overflow-x: auto; }
        .status-tag { padding: 2px 10px; border-radius: 12px; font-size: 12px; }
        .status-normal { background: #dff0d8; color: #3c763d; }
        .status-banned { background: #f2dede; color: #a94442; }
        .pagination-box { margin-top: 20px; text-align: center; }
    </style>
</head>
<body>

<div class="container">

    <div class="header-bar">
        <span style="font-size:18px; font-weight:bold;">👤 用户管理</span>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="layui-btn layui-btn-sm layui-btn-primary">← 返回管理后台</a>
    </div>

    <div class="header-bar">
        <form class="search-box" onsubmit="return false;">
            <input type="text" id="keyword" placeholder="搜索用户名..." value="${keyword}">
            <button class="layui-btn layui-btn-sm" onclick="search()">搜索</button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" onclick="resetSearch()">重置</button>
        </form>
        <span style="color:#999;">共 ${pageInfo.total} 位用户</span>
    </div>

    <div class="table-wrap">
        <table class="layui-table" lay-skin="line">
            <thead>
            <tr>
                <th style="width:50px;">ID</th>
                <th>用户名</th>
                <th style="width:120px;">手机号</th>
                <th style="width:120px;">微信号</th>
                <th style="width:80px;">状态</th>
                <th style="width:140px;">注册时间</th>
                <th style="width:260px;">操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${pageInfo.list}" var="u">
                <tr>
                    <td>${u.id}</td>
                    <td>${u.username}</td>
                    <td>${u.phone}</td>
                    <td>${u.wechat}</td>
                    <td>
                            <span class="status-tag ${u.status == 0 ? 'status-normal' : 'status-banned'}">
                                    ${u.status == 0 ? '正常' : '已封禁'}
                            </span>
                    </td>
                    <td><fmt:formatDate value="${u.createTime}" pattern="yyyy年MM月dd日"/></td>
                    <td>
                        <c:if test="${u.status == 0}">
                            <button class="layui-btn layui-btn-xs layui-btn-danger" onclick="banUser(${u.id})">封禁</button>
                        </c:if>
                        <c:if test="${u.status == 1}">
                            <button class="layui-btn layui-btn-xs layui-btn-normal" onclick="unbanUser(${u.id})">解封</button>
                        </c:if>
                        <button class="layui-btn layui-btn-xs layui-btn-warm" onclick="resetPassword(${u.id})">重置密码</button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty pageInfo.list}">
                <tr><td colspan="7" style="text-align:center;color:#999;padding:30px;">暂无用户</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <c:if test="${pageInfo.pages > 1}">
        <div class="pagination-box">
            <c:if test="${pageInfo.pageNum > 1}">
                <a href="?pageNum=1&keyword=${keyword}" class="layui-btn layui-btn-sm">首页</a>
                <a href="?pageNum=${pageInfo.pageNum - 1}&keyword=${keyword}" class="layui-btn layui-btn-sm">上一页</a>
            </c:if>
            <span style="margin:0 10px;">${pageInfo.pageNum} / ${pageInfo.pages}</span>
            <c:if test="${pageInfo.pageNum < pageInfo.pages}">
                <a href="?pageNum=${pageInfo.pageNum + 1}&keyword=${keyword}" class="layui-btn layui-btn-sm">下一页</a>
                <a href="?pageNum=${pageInfo.pages}&keyword=${keyword}" class="layui-btn layui-btn-sm">末页</a>
            </c:if>
        </div>
    </c:if>
</div>

<script src="${pageContext.request.contextPath}/lib/layui/layui.js"></script>
<script>
    layui.use(['layer', 'jquery'], function() {
        var layer = layui.layer;
        var $ = layui.$;

        window.search = function() {
            var keyword = $('#keyword').val().trim();
            location.href = '?keyword=' + encodeURIComponent(keyword);
        };

        window.resetSearch = function() {
            $('#keyword').val('');
            location.href = '?';
        };

        window.banUser = function(id) {
            layer.confirm('确认封禁该用户？被封禁用户将无法登录和使用任何功能。', {icon: 2}, function(index) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/user/ban',
                    type: 'POST',
                    data: { id: id },
                    dataType: 'json',
                    success: function(res) {
                        if (res.code === 0) {
                            layer.msg('✅ 已封禁', {icon: 1});
                            setTimeout(function() { location.reload(); }, 600);
                        } else {
                            layer.msg('❌ ' + res.msg, {icon: 2});
                        }
                    }
                });
                layer.close(index);
            });
        };

        window.unbanUser = function(id) {
            layer.confirm('确认解封该用户？', function(index) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/user/unban',
                    type: 'POST',
                    data: { id: id },
                    dataType: 'json',
                    success: function(res) {
                        if (res.code === 0) {
                            layer.msg('✅ 已解封', {icon: 1});
                            setTimeout(function() { location.reload(); }, 600);
                        } else {
                            layer.msg('❌ ' + res.msg, {icon: 2});
                        }
                    }
                });
                layer.close(index);
            });
        };

        window.resetPassword = function(id) {
            layer.prompt({
                title: '重置密码',
                formType: 0,
                value: '123456',
                area: ['400px']
            }, function(value, index) {
                if (!value || value.length < 4) {
                    layer.msg('密码至少4位', {icon: 0});
                    return;
                }
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/user/resetPassword',
                    type: 'POST',
                    data: { id: id, newPassword: value },
                    dataType: 'json',
                    success: function(res) {
                        if (res.code === 0) {
                            layer.msg('✅ 密码已重置为：' + value, {icon: 1});
                            setTimeout(function() { location.reload(); }, 600);
                        } else {
                            layer.msg('❌ ' + res.msg, {icon: 2});
                        }
                    }
                });
                layer.close(index);
            });
        };
    });
</script>

</body>
</html>