<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${notice.title}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        body { background: #f5f5f5; }
        .container { max-width: 800px; margin: 20px auto; padding: 0 15px; }
        .detail-box { background: #fff; padding: 40px; border-radius: 8px; box-shadow: 0 2px 12px rgba(0,0,0,0.1); }
        .detail-box h1 { font-size: 24px; margin-bottom: 10px; }
        .detail-box .meta { color: #999; font-size: 14px; border-bottom: 1px solid #f0f0f0; padding-bottom: 15px; margin-bottom: 20px; display: flex; gap: 20px; flex-wrap: wrap; }
        .detail-box .content { line-height: 1.9; font-size: 16px; color: #333; white-space: pre-wrap; }
        .detail-box .back-btn { margin-top: 25px; }
        .detail-box .badge { font-size: 12px; padding: 2px 12px; border-radius: 12px; margin-left: 10px; }
        .detail-box .badge.top { background: #FF5722; color: #fff; }
        .detail-box .badge.hot { background: #FFB800; color: #fff; }
        .detail-box .badge.info { background: #1E9FFF; color: #fff; }
    </style>
</head>
<body>

<div class="container">
    <div class="detail-box">
        <h1>
            ${notice.title}
            <c:if test="${notice.isTop == 1}"><span class="badge top">置顶</span></c:if>
            <c:if test="${notice.type == 'hot'}"><span class="badge hot">热卖</span></c:if>
            <c:if test="${notice.type == 'promotion'}"><span class="badge info">促销</span></c:if>
        </h1>
        <div class="meta">
            <span>📅 <fmt:formatDate value="${notice.createTime}" pattern="yyyy年MM月dd日 HH:mm:ss"/></span>
            <span>👀 ${notice.viewCount} 次浏览</span>
            <c:if test="${not empty notice.type}">
                <span>🏷️ ${notice.type}</span>
            </c:if>
        </div>
        <div class="content">${notice.content}</div>
        <div class="back-btn">
            <a href="${pageContext.request.contextPath}/notice/list" class="layui-btn layui-btn-primary">← 返回公告列表</a>
            <a href="${pageContext.request.contextPath}/" class="layui-btn layui-btn-primary">← 返回首页</a>
        </div>
    </div>
</div>

</body>
</html>