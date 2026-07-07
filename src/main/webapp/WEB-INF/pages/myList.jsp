<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的发布</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        body { background: #f5f5f5; }
        .container { max-width: 1200px; margin: 20px auto; padding: 0 15px; }
        .header-bar { background: #fff; padding: 15px 25px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .filter-bar { background: #fff; padding: 15px 25px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); margin-bottom: 20px; }
        .filter-bar .layui-btn { margin-right: 8px; }
        .filter-bar .active { background: #1E9FFF; color: #fff; border-color: #1E9FFF; }
        .product-grid { display: flex; flex-wrap: wrap; gap: 20px; }
        .product-card { width: calc(25% - 15px); background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 4px rgba(0,0,0,0.08); transition: transform 0.2s; }
        .product-card:hover { transform: translateY(-4px); box-shadow: 0 4px 12px rgba(0,0,0,0.15); }
        .product-card img { width: 100%; height: 180px; object-fit: cover; background: #eee; }
        .product-card .info { padding: 12px; }
        .product-card .title { font-size: 15px; font-weight: bold; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .product-card .price { color: #FF5722; font-size: 20px; font-weight: bold; margin: 8px 0; }
        .product-card .meta { color: #999; font-size: 12px; display: flex; justify-content: space-between; }
        .status-tag { font-size: 12px; padding: 2px 10px; border-radius: 12px; }
        .status-tag.selling { background: #dff0d8; color: #3c763d; }
        .status-tag.sold { background: #fcf8e3; color: #8a6d3b; }
        .status-tag.offline { background: #f2dede; color: #a94442; }
        .pagination-box { margin-top: 30px; text-align: center; }
        .empty-tip { text-align: center; padding: 60px 0; color: #999; font-size: 16px; }
    </style>
</head>
<body>

<div class="container">

    <div class="header-bar">
        <span style="font-size:18px; font-weight:bold;">📦 我的发布</span>
        <div>
            <a href="${pageContext.request.contextPath}/" class="layui-btn layui-btn-sm layui-btn-primary">← 返回首页</a>
            <a href="${pageContext.request.contextPath}/product/toAdd" class="layui-btn layui-btn-sm layui-btn-normal">+ 发布商品</a>
        </div>
    </div>

    <!-- 状态筛选栏 -->
    <div class="filter-bar">
        <span style="margin-right: 15px; color: #999;">状态筛选：</span>
        <a href="?status=" class="layui-btn layui-btn-sm ${empty currentStatus ? 'active' : 'layui-btn-primary'}">全部</a>
        <a href="?status=0" class="layui-btn layui-btn-sm ${currentStatus == 0 ? 'active' : 'layui-btn-primary'}">在售</a>
        <a href="?status=1" class="layui-btn layui-btn-sm ${currentStatus == 1 ? 'active' : 'layui-btn-primary'}">已售出</a>
        <a href="?status=2" class="layui-btn layui-btn-sm ${currentStatus == 2 ? 'active' : 'layui-btn-primary'}">已下架</a>
    </div>

    <div class="product-grid">
        <c:forEach items="${pageInfo.list}" var="p">
            <div class="product-card">
                <a href="${pageContext.request.contextPath}/product/detail?id=${p.id}">
                    <c:if test="${not empty p.image}">
                        <img src="${pageContext.request.contextPath}${p.image}" alt="${p.title}">
                    </c:if>
                    <c:if test="${empty p.image}">
                        <img src="${pageContext.request.contextPath}/lib/layui/images/face/0.gif" alt="暂无图片">
                    </c:if>
                </a>
                <div class="info">
                    <div class="title">${p.title}</div>
                    <div class="price">¥${p.price}</div>
                    <div class="meta">
                        <span>
                            <c:if test="${p.status == 0}"><span class="status-tag selling">● 在售</span></c:if>
                            <c:if test="${p.status == 1}"><span class="status-tag sold">● 已售出</span></c:if>
                            <c:if test="${p.status == 2}"><span class="status-tag offline">● 已下架</span></c:if>
                        </span>
                        <span>👀 ${p.viewCount}</span>
                    </div>
                    <div style="margin-top: 10px; display: flex; gap: 5px; flex-wrap: wrap;">
                        <a href="${pageContext.request.contextPath}/product/detail?id=${p.id}" class="layui-btn layui-btn-xs layui-btn-normal">查看</a>
                        <c:if test="${p.status == 0}">
                            <a href="${pageContext.request.contextPath}/product/edit?id=${p.id}" class="layui-btn layui-btn-xs layui-btn-warm">编辑</a>
                            <button class="layui-btn layui-btn-xs layui-btn-danger" onclick="updateStatus(${p.id}, 2)">下架</button>
                        </c:if>
                        <c:if test="${p.status == 2}">
                            <button class="layui-btn layui-btn-xs layui-btn-warm" onclick="updateStatus(${p.id}, 0)">重新上架</button>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty pageInfo.list}">
            <div class="empty-tip" style="width: 100%;">📭 您还没有发布任何商品，<a href="${pageContext.request.contextPath}/product/toAdd" style="color:#1E9FFF;">去发布</a></div>
        </c:if>
    </div>

    <div class="pagination-box">
        <c:if test="${pageInfo.pages > 1}">
            <a href="?pageNum=1&status=${currentStatus}" class="layui-btn layui-btn-sm">首页</a>
            <a href="?pageNum=${pageInfo.pageNum - 1 < 1 ? 1 : pageInfo.pageNum - 1}&status=${currentStatus}" class="layui-btn layui-btn-sm">上一页</a>
            <span style="margin: 0 10px;">${pageInfo.pageNum} / ${pageInfo.pages}</span>
            <a href="?pageNum=${pageInfo.pageNum + 1 > pageInfo.pages ? pageInfo.pages : pageInfo.pageNum + 1}&status=${currentStatus}" class="layui-btn layui-btn-sm">下一页</a>
            <a href="?pageNum=${pageInfo.pages}&status=${currentStatus}" class="layui-btn layui-btn-sm">末页</a>
        </c:if>
    </div>
</div>

<script src="${pageContext.request.contextPath}/lib/layui/layui.js"></script>
<script>
    layui.use(['layer', 'jquery'], function() {
        var layer = layui.layer;
        var $ = layui.$;

        window.updateStatus = function(id, status) {
            var statusText = status === 0 ? '重新上架' : '下架';
            var confirmMsg = '确认' + statusText + '该商品吗？';
            layer.confirm(confirmMsg, function(index) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/product/updateStatus',
                    type: 'POST',
                    data: { id: id, status: status },
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
                        layer.msg('❌ 网络异常，请重试', {icon: 2});
                    }
                });
                layer.close(index);
            });
        };
    });
</script>

</body>
</html>