<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>卖家订单管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        body { background: #f5f5f5; }
        .container { max-width: 1000px; margin: 20px auto; padding: 0 15px; }
        .header-bar { background: #fff; padding: 15px 25px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .order-list { background: #fff; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
        .order-item { padding: 20px 25px; border-bottom: 1px solid #f0f0f0; }
        .order-item:last-child { border-bottom: none; }
        .order-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; font-size: 13px; color: #999; }
        .order-header .order-no { font-weight: bold; color: #333; }
        .order-product { display: flex; gap: 20px; align-items: center; }
        .order-product img { width: 80px; height: 80px; object-fit: cover; border-radius: 4px; background: #eee; }
        .order-product .info { flex: 1; }
        .order-product .info .title { font-size: 15px; font-weight: bold; }
        .order-product .info .price { color: #FF5722; font-weight: bold; }
        .order-product .info .buyer { color: #666; font-size: 13px; }
        .order-product .status { font-weight: bold; padding: 4px 12px; border-radius: 12px; font-size: 13px; }
        .status-0 { background: #f8d7da; color: #721c24; }
        .status-1 { background: #cce5ff; color: #004085; }
        .status-2 { background: #d1ecf1; color: #0c5460; }
        .status-3 { background: #d4edda; color: #155724; }
        .order-actions { margin-top: 10px; display: flex; gap: 10px; }
        .empty-tip { text-align: center; padding: 40px 0; color: #999; }
        .pagination-box { margin-top: 20px; text-align: center; }
    </style>
</head>
<body>

<div class="container">
    <div class="header-bar">
        <span style="font-size:18px; font-weight:bold;">📦 卖家订单管理</span>
        <div>
            <a href="${pageContext.request.contextPath}/" class="layui-btn layui-btn-sm layui-btn-primary">← 返回首页</a>
        </div>
    </div>

    <div class="order-list">
        <c:forEach items="${pageInfo.list}" var="order">
            <div class="order-item">
                <div class="order-header">
                    <span class="order-no">订单号：${order.orderNo}</span>
                    <span>下单时间：<fmt:formatDate value="${order.createTime}" pattern="yyyy年MM月dd日 HH:mm:ss"/></span>
                </div>
                <div class="order-product">
                    <c:if test="${not empty order.product.image}">
                        <img src="${pageContext.request.contextPath}${order.product.image}" alt="">
                    </c:if>
                    <c:if test="${empty order.product.image}">
                        <img src="${pageContext.request.contextPath}/lib/layui/images/face/0.gif" alt="">
                    </c:if>
                    <div class="info">
                        <div class="title">${order.product.title}</div>
                        <div class="price">¥${order.price}</div>
                        <div class="buyer">买家：${order.buyer.username}</div>
                    </div>
                    <div>
                        <span class="status status-${order.status}">
                            <c:if test="${order.status == 0}">已取消</c:if>
                            <c:if test="${order.status == 1}">待发货</c:if>
                            <c:if test="${order.status == 2}">已发货</c:if>
                            <c:if test="${order.status == 3}">已完成</c:if>
                        </span>
                    </div>
                </div>
                <div class="order-actions">
                    <c:if test="${order.status == 1}">
                        <button class="layui-btn layui-btn-sm layui-btn-normal" onclick="shipOrder(${order.id})">🚚 发货</button>
                    </c:if>
                    <c:if test="${order.status == 2 || order.status == 3}">
                        <span style="color:#5FB878; font-size:13px;">✅ 交易进行中</span>
                    </c:if>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty pageInfo.list}">
            <div class="empty-tip">📭 暂无订单，<a href="${pageContext.request.contextPath}/" style="color:#1E9FFF;">去查看商品</a></div>
        </c:if>
    </div>

    <c:if test="${pageInfo.pages > 1}">
        <div class="pagination-box">
            <c:if test="${pageInfo.pageNum > 1}">
                <a href="?pageNum=1" class="layui-btn layui-btn-sm">首页</a>
                <a href="?pageNum=${pageInfo.pageNum - 1}" class="layui-btn layui-btn-sm">上一页</a>
            </c:if>
            <span style="margin:0 10px;">${pageInfo.pageNum} / ${pageInfo.pages}</span>
            <c:if test="${pageInfo.pageNum < pageInfo.pages}">
                <a href="?pageNum=${pageInfo.pageNum + 1}" class="layui-btn layui-btn-sm">下一页</a>
                <a href="?pageNum=${pageInfo.pages}" class="layui-btn layui-btn-sm">末页</a>
            </c:if>
        </div>
    </c:if>
</div>

<script src="${pageContext.request.contextPath}/lib/layui/layui.js"></script>
<script>
    layui.use(['layer', 'jquery'], function() {
        var layer = layui.layer;
        var $ = layui.$;

        window.shipOrder = function(orderId) {
            layer.confirm('确认已发货？', function(index) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/order/ship',
                    type: 'POST',
                    data: { orderId: orderId },
                    dataType: 'json',
                    success: function(res) {
                        if (res.code === 0) {
                            layer.msg('✅ 发货成功', {icon: 1});
                            setTimeout(function() { location.reload(); }, 800);
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