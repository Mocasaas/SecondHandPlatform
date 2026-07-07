<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品详情 - 二手交易平台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        body { background: #f5f5f5; }
        .detail-container { max-width: 900px; margin: 40px auto; background: #fff; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.1); overflow: hidden; }
        .detail-header { padding: 30px 40px 20px 40px; border-bottom: 1px solid #f0f0f0; }
        .detail-header h1 { font-size: 24px; margin: 0 0 10px 0; color: #333; }
        .detail-header .price { font-size: 32px; font-weight: bold; color: #FF5722; }
        .detail-body { padding: 30px 40px; display: flex; gap: 40px; }
        .detail-image { flex: 1; max-width: 400px; }
        .detail-image img { width: 100%; border-radius: 8px; background: #f5f5f5; }
        .detail-image .no-image { width: 100%; height: 300px; background: #f0f0f0; display: flex; align-items: center; justify-content: center; color: #999; font-size: 16px; border-radius: 8px; }
        .detail-info { flex: 1; }
        .detail-info .info-item { padding: 10px 0; border-bottom: 1px solid #f5f5f5; display: flex; align-items: center; }
        .detail-info .info-item .label { width: 100px; color: #999; flex-shrink: 0; }
        .detail-info .info-item .value { color: #333; }
        .detail-info .info-item .seller-tag { display: inline-block; background: #e8f5e9; color: #2e7d32; padding: 2px 12px; border-radius: 12px; font-size: 13px; margin-left: 8px; }
        .detail-info .info-item .rating-star { color: #FFB800; font-weight: bold; font-size: 18px; margin-left: 15px; }
        .detail-info .description { padding: 15px 0; line-height: 1.8; color: #555; }
        .detail-footer { padding: 20px 40px 30px 40px; border-top: 1px solid #f0f0f0; display: flex; gap: 15px; flex-wrap: wrap; align-items: center; }
        .detail-footer .layui-btn { min-width: 100px; }
        .status-tag { display: inline-block; padding: 4px 16px; border-radius: 20px; font-size: 14px; font-weight: bold; margin-left: 15px; }
        .status-tag.selling { background: #dff0d8; color: #3c763d; }
        .status-tag.sold { background: #fcf8e3; color: #8a6d3b; }
        .status-tag.offline { background: #f2dede; color: #a94442; }
    </style>
</head>
<body>

<div class="detail-container">

    <div class="detail-header">
        <h1>
            ${product.title}
            <c:if test="${product.status == 0}"><span class="status-tag selling">● 在售</span></c:if>
            <c:if test="${product.status == 1}"><span class="status-tag sold">● 已售出</span></c:if>
            <c:if test="${product.status == 2}"><span class="status-tag offline">● 已下架</span></c:if>
        </h1>
        <span class="price">¥${product.price}</span>
    </div>

    <div class="detail-body">
        <div class="detail-image">
            <c:if test="${not empty product.image}">
                <img src="${pageContext.request.contextPath}${product.image}" alt="${product.title}">
            </c:if>
            <c:if test="${empty product.image}">
                <div class="no-image">📷 暂无图片</div>
            </c:if>
        </div>

        <div class="detail-info">
            <div class="info-item">
                <span class="label">商品编号</span>
                <span class="value">#${product.id}</span>
            </div>
            <div class="info-item">
                <span class="label">发布者</span>
                <span class="value">
                    ${product.username}
                    <span class="seller-tag">📌 卖家</span>
                    <span class="rating-star">
                        ⭐ <fmt:formatNumber value="${sellerAvgRating}" pattern="#.#"/> 分
                    </span>
                </span>
            </div>
            <div class="info-item">
                <span class="label">分类</span>
                <span class="value">${product.categoryName}</span>
            </div>
            <div class="info-item">
                <span class="label">浏览次数</span>
                <span class="value">👀 ${product.viewCount}</span>
            </div>
            <div class="info-item">
                <span class="label">发布时间</span>
                <span class="value"><fmt:formatDate value="${product.createTime}" pattern="yyyy年MM月dd日 HH:mm:ss"/></span>
            </div>
            <div class="description">
                <strong>📝 商品描述</strong>
                <p style="margin-top: 8px;">${product.description}</p>
            </div>
        </div>
    </div>

    <div class="detail-footer">
        <a href="${pageContext.request.contextPath}/" class="layui-btn layui-btn-primary">← 返回首页</a>

        <c:choose>
            <c:when test="${product.status == 1 || product.status == 2}">
                <span style="color:#999;">
                    <c:if test="${product.status == 1}">✅ 该商品已售出</c:if>
                    <c:if test="${product.status == 2}">⛔ 该商品已下架</c:if>
                </span>
            </c:when>
            <c:when test="${product.status == 0}">
                <c:if test="${empty sessionScope.loginUser}">
                    <span style="color:#999;">💡 请先 <a href="${pageContext.request.contextPath}/user/toLogin" style="color:#1E9FFF;">登录</a> 后购买</span>
                </c:if>
                <c:if test="${not empty sessionScope.loginUser}">
                    <c:set var="isOwner" value="${sessionScope.loginUser.id == product.userId}" />
                    <c:if test="${sessionScope.loginUser.role == 1}">
                        <span style="color:#FF5722; line-height:38px; font-weight:bold;">🔑 管理员身份</span>
                        <a href="${pageContext.request.contextPath}/admin/products" class="layui-btn layui-btn-sm layui-btn-danger">进入管理后台</a>
                    </c:if>
                    <c:if test="${isOwner && sessionScope.loginUser.role == 0}">
                        <span style="color:#2e7d32; line-height:38px; font-weight:bold;">👤 这是您发布的商品</span>
                        <c:if test="${product.status == 0}">
                            <button class="layui-btn layui-btn-danger" onclick="updateStatus(${product.id}, 2)">⬇️ 下架商品</button>
                        </c:if>
                        <c:if test="${product.status == 2}">
                            <button class="layui-btn layui-btn-normal" onclick="updateStatus(${product.id}, 0)">🔄 重新上架</button>
                        </c:if>
                    </c:if>
                    <c:if test="${not isOwner && sessionScope.loginUser.role == 0}">
                        <button class="layui-btn layui-btn-normal" onclick="buyNow(${product.id})">🛒 立即购买</button>
                        <button class="layui-btn layui-btn-primary" onclick="addToCart(${product.id})">🛍️ 加入购物车</button>
                        <button class="layui-btn layui-btn-warm" id="favoriteBtn" onclick="toggleFavorite(${product.id})">
                            <span id="favoriteIcon">${isFavorited ? '❤️' : '🤍'}</span>
                            <span id="favoriteText">${isFavorited ? '已收藏' : '收藏'}</span>
                        </button>
                    </c:if>
                </c:if>
            </c:when>
        </c:choose>
    </div>
</div>

<script src="${pageContext.request.contextPath}/lib/layui/layui.js"></script>
<script>
    layui.use(['layer', 'jquery'], function() {
        var layer = layui.layer;
        var $ = layui.$;
        var productId = ${product.id};

        // 更新商品状态（卖家专用）
        window.updateStatus = function(id, status) {
            var statusText = status === 0 ? '重新上架' : '下架';
            layer.confirm('确认' + statusText + '该商品吗？', function(index) {
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
                        layer.msg('网络异常，请重试', {icon: 2});
                    }
                });
                layer.close(index);
            });
        };

        // 立即购买
        window.buyNow = function(id) {
            window.location.href = '${pageContext.request.contextPath}/order/confirm?productId=' + id;
        };

        // 加入购物车
        window.addToCart = function(id) {
            $.ajax({
                url: '${pageContext.request.contextPath}/cart/add',
                type: 'POST',
                data: { productId: id, quantity: 1 },
                dataType: 'json',
                success: function(res) {
                    if (res.code === 0) {
                        layer.msg('✅ ' + res.msg, {icon: 1, time: 1500});
                    } else {
                        layer.msg('❌ ' + res.msg, {icon: 2, time: 2000});
                    }
                },
                error: function() {
                    layer.msg('网络异常，请重试', {icon: 2});
                }
            });
        };

        // 收藏切换
        window.toggleFavorite = function(id) {
            $.ajax({
                url: '${pageContext.request.contextPath}/favorite/toggle',
                type: 'POST',
                data: { productId: id },
                dataType: 'json',
                success: function(res) {
                    if (res.code === 0) {
                        var isFavorited = res.msg === '已收藏';
                        $('#favoriteIcon').text(isFavorited ? '❤️' : '🤍');
                        $('#favoriteText').text(isFavorited ? '已收藏' : '收藏');
                        layer.msg(res.msg, {icon: 1, time: 1000});
                    } else {
                        layer.msg(res.msg, {icon: 2});
                    }
                },
                error: function() {
                    layer.msg('网络异常，请重试', {icon: 2});
                }
            });
        };
    });
</script>

</body>
</html>