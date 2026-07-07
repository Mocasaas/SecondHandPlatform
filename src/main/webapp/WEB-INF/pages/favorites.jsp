<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的收藏</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        body { background: #f5f5f5; }
        .container { max-width: 1200px; margin: 20px auto; padding: 0 15px; }
        .header-bar { background: #fff; padding: 15px 25px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .product-grid { display: flex; flex-wrap: wrap; gap: 20px; }
        .product-card { width: calc(25% - 15px); background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 4px rgba(0,0,0,0.08); transition: transform 0.2s; }
        .product-card:hover { transform: translateY(-4px); box-shadow: 0 4px 12px rgba(0,0,0,0.15); }
        .product-card img { width: 100%; height: 180px; object-fit: cover; background: #eee; }
        .product-card .info { padding: 12px; }
        .product-card .title { font-size: 15px; font-weight: bold; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .product-card .price { color: #FF5722; font-size: 20px; font-weight: bold; margin: 8px 0; }
        .product-card .meta { color: #999; font-size: 12px; display: flex; justify-content: space-between; }
        .empty-tip { text-align: center; padding: 60px 0; color: #999; font-size: 16px; }
        .empty-tip a { color: #1E9FFF; }
    </style>
</head>
<body>

<div class="container">
    <div class="header-bar">
        <span style="font-size:18px; font-weight:bold;">❤️ 我的收藏</span>
        <a href="${pageContext.request.contextPath}/" class="layui-btn layui-btn-sm layui-btn-primary">← 返回首页</a>
    </div>

    <div class="product-grid">
        <c:forEach items="${favorites}" var="f">
            <div class="product-card">
                <a href="${pageContext.request.contextPath}/product/detail?id=${f.product.id}">
                    <c:if test="${not empty f.product.image}">
                        <img src="${pageContext.request.contextPath}${f.product.image}" alt="${f.product.title}">
                    </c:if>
                    <c:if test="${empty f.product.image}">
                        <img src="${pageContext.request.contextPath}/lib/layui/images/face/0.gif" alt="暂无图片">
                    </c:if>
                    <div class="info">
                        <div class="title">${f.product.title}</div>
                        <div class="price">¥${f.product.price}</div>
                        <div class="meta">
                            <span>❤️ 已收藏</span>
                            <span><fmt:formatDate value="${f.createTime}" pattern="yyyy年MM月dd日"/></span>
                        </div>
                    </div>
                </a>
            </div>
        </c:forEach>
        <c:if test="${empty favorites}">
            <div class="empty-tip" style="width:100%;">📭 还没有收藏的商品，<a href="${pageContext.request.contextPath}/">去逛逛</a></div>
        </c:if>
    </div>
</div>

</body>
</html>