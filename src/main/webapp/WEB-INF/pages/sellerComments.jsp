<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>卖家评价</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        body { background: #f5f5f5; }
        .container { max-width: 800px; margin: 20px auto; padding: 0 15px; }
        .header-bar { background: #fff; padding: 15px 25px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .comment-item { background: #fff; padding: 15px 20px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); margin-bottom: 10px; }
        .comment-item .user { font-weight: bold; }
        .comment-item .rating { color: #FFB800; margin-left: 10px; }
        .comment-item .content { color: #666; margin-top: 5px; }
        .comment-item .time { color: #999; font-size: 12px; margin-top: 3px; }
        .avg-box { background: #fff; padding: 15px 20px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); margin-bottom: 20px; text-align: center; font-size: 18px; }
        .avg-box span { color: #FFB800; font-weight: bold; font-size: 24px; }
        .empty-tip { text-align: center; padding: 40px 0; color: #999; }
    </style>
</head>
<body>

<div class="container">
    <div class="header-bar">
        <span style="font-size:18px; font-weight:bold;">⭐ 卖家评价</span>
        <a href="${pageContext.request.contextPath}/" class="layui-btn layui-btn-sm layui-btn-primary">← 返回首页</a>
    </div>

    <div class="avg-box">
        平均评分：<span>${avgRating}</span> 分 （共 ${comments.size()} 条评价）
    </div>

    <c:forEach items="${comments}" var="c">
        <div class="comment-item">
            <div>
                <span class="user">${c.buyer.username}</span>
                <span class="rating">
                    <c:forEach begin="1" end="${c.rating}">★</c:forEach>
                    <c:forEach begin="${c.rating+1}" end="5">☆</c:forEach>
                </span>
            </div>
            <div class="content">${c.content}</div>
            <div class="time">${c.createTime}</div>
        </div>
    </c:forEach>
    <c:if test="${empty comments}">
        <div class="empty-tip">📭 暂无评价</div>
    </c:if>
</div>

</body>
</html>