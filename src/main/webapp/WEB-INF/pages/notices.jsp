<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>平台公告</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        body { background: #f5f5f5; }
        .container { max-width: 900px; margin: 20px auto; padding: 0 15px; }
        .header-bar { background: #fff; padding: 15px 25px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .notice-list { background: #fff; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
        .notice-item { padding: 18px 25px; border-bottom: 1px solid #f0f0f0; transition: background 0.2s; }
        .notice-item:hover { background: #f8f8f8; }
        .notice-item:last-child { border-bottom: none; }
        .notice-item .title { font-size: 16px; font-weight: bold; }
        .notice-item .title a { color: #333; text-decoration: none; }
        .notice-item .title a:hover { color: #1E9FFF; }
        .notice-item .title .badge { font-size: 12px; padding: 2px 10px; border-radius: 12px; margin-left: 8px; }
        .notice-item .title .badge.top { background: #FF5722; color: #fff; }
        .notice-item .title .badge.hot { background: #FFB800; color: #fff; }
        .notice-item .title .badge.info { background: #1E9FFF; color: #fff; }
        .notice-item .summary { color: #666; margin-top: 5px; font-size: 14px; }
        .notice-item .meta { color: #999; font-size: 13px; margin-top: 8px; display: flex; gap: 20px; }
        .empty-tip { text-align: center; padding: 40px 0; color: #999; }
    </style>
</head>
<body>

<div class="container">
    <div class="header-bar">
        <span style="font-size:18px; font-weight:bold;">📢 平台公告</span>
        <a href="${pageContext.request.contextPath}/" class="layui-btn layui-btn-sm layui-btn-primary">← 返回首页</a>
    </div>

    <div class="notice-list">
        <c:forEach items="${notices}" var="n">
            <div class="notice-item">
                <div class="title">
                    <a href="${pageContext.request.contextPath}/notice/detail?id=${n.id}">${n.title}</a>
                    <c:if test="${n.isTop == 1}">
                        <span class="badge top">置顶</span>
                    </c:if>
                    <c:if test="${n.type == 'hot'}">
                        <span class="badge hot">热卖</span>
                    </c:if>
                    <c:if test="${n.type == 'promotion'}">
                        <span class="badge info">促销</span>
                    </c:if>
                </div>
                <div class="summary">${n.content.length() > 120 ? n.content.substring(0, 120).concat('...') : n.content}</div>
                <div class="meta">
                    <span>📅 <fmt:formatDate value="${n.createTime}" pattern="yyyy年MM月dd日"/></span>
                    <span>👀 ${n.viewCount} 次浏览</span>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty notices}">
            <div class="empty-tip">📭 暂无公告</div>
        </c:if>
    </div>
</div>

</body>
</html>