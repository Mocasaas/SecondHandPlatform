<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>浏览排行榜 - 二手交易平台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        body { background: #f5f5f5; }
        .container { max-width: 1000px; margin: 20px auto; padding: 0 15px; }
        .header-bar { background: #fff; padding: 15px 25px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .rank-list { background: #fff; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); overflow: hidden; }
        .rank-item { display: flex; align-items: center; padding: 15px 25px; border-bottom: 1px solid #f0f0f0; gap: 15px; transition: background 0.2s; }
        .rank-item:hover { background: #f8f8f8; }
        .rank-item:last-child { border-bottom: none; }
        .rank-number { width: 40px; font-size: 20px; font-weight: bold; text-align: center; flex-shrink: 0; }
        .rank-number.gold { color: #FFD700; }
        .rank-number.silver { color: #C0C0C0; }
        .rank-number.bronze { color: #CD7F32; }
        .rank-item img { width: 80px; height: 80px; object-fit: cover; border-radius: 6px; background: #eee; flex-shrink: 0; }
        .rank-item .info { flex: 1; }
        .rank-item .info .title { font-size: 16px; font-weight: bold; }
        .rank-item .info .seller { color: #999; font-size: 13px; }
        .rank-item .info .price { color: #FF5722; font-size: 18px; font-weight: bold; }
        .rank-item .views { color: #999; font-size: 14px; flex-shrink: 0; }
        .empty-tip { text-align: center; padding: 40px 0; color: #999; }
        .pagination-box { margin-top: 20px; text-align: center; }
    </style>
</head>
<body>

<div class="container">
    <div class="header-bar">
        <span style="font-size:18px; font-weight:bold;">🏆 浏览排行榜</span>
        <a href="${pageContext.request.contextPath}/" class="layui-btn layui-btn-sm layui-btn-primary">← 返回首页</a>
    </div>

    <div class="rank-list">
        <c:forEach items="${pageInfo.list}" var="p" varStatus="status">
            <div class="rank-item">
                <div class="rank-number ${status.index == 0 ? 'gold' : status.index == 1 ? 'silver' : status.index == 2 ? 'bronze' : ''}">
                    #${status.index + 1}
                </div>
                <c:if test="${not empty p.image}">
                    <img src="${pageContext.request.contextPath}${p.image}" alt="${p.title}">
                </c:if>
                <c:if test="${empty p.image}">
                    <img src="${pageContext.request.contextPath}/lib/layui/images/face/0.gif" alt="暂无图片">
                </c:if>
                <div class="info">
                    <div class="title"><a href="${pageContext.request.contextPath}/product/detail?id=${p.id}" style="color:#333;">${p.title}</a></div>
                    <div class="seller">发布者：${p.username}</div>
                    <div class="price">¥${p.price}</div>
                </div>
                <div class="views">👀 ${p.viewCount} 次浏览</div>
            </div>
        </c:forEach>
        <c:if test="${empty pageInfo.list}">
            <div class="empty-tip">📭 暂无商品数据</div>
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

</body>
</html>