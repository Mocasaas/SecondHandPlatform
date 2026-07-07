<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单管理 - 管理员</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        body { background: #f5f5f5; }
        .container { max-width: 1200px; margin: 20px auto; padding: 0 15px; }
        .header-bar { background: #fff; padding: 15px 25px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 10px; }
        .search-box { display: flex; gap: 10px; }
        .search-box input { height: 36px; padding: 0 10px; border: 1px solid #ddd; border-radius: 4px; }
        .search-box input:focus { border-color: #1E9FFF; outline: none; }
        .table-wrap { background: #fff; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); padding: 15px; overflow-x: auto; }
        .status-tag { padding: 2px 10px; border-radius: 12px; font-size: 12px; }
        .status-0 { background: #f8d7da; color: #721c24; }
        .status-1 { background: #cce5ff; color: #004085; }
        .status-2 { background: #d1ecf1; color: #0c5460; }
        .status-3 { background: #d4edda; color: #155724; }
        .pagination-box { margin-top: 20px; text-align: center; }
    </style>
</head>
<body>

<div class="container">

    <div class="header-bar">
        <span style="font-size:18px; font-weight:bold;">📋 订单管理</span>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="layui-btn layui-btn-sm layui-btn-primary">← 返回管理后台</a>
    </div>

    <div class="header-bar">
        <form class="search-box" onsubmit="return false;">
            <input type="text" id="keyword" placeholder="搜索订单号..." value="${keyword}">
            <button class="layui-btn layui-btn-sm" onclick="search()">搜索</button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" onclick="resetSearch()">重置</button>
        </form>
        <span style="color:#999;">共 ${pageInfo.total} 笔订单</span>
    </div>

    <div class="table-wrap">
        <table class="layui-table" lay-skin="line">
            <thead>
            <tr>
                <th style="width:50px;">ID</th>
                <th style="width:170px;">订单号</th>
                <th>商品</th>
                <th style="width:90px;">买家</th>
                <th style="width:90px;">金额</th>
                <th style="width:80px;">状态</th>
                <th style="width:150px;">下单时间</th>
                <th style="width:180px;">操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${pageInfo.list}" var="order">
                <tr>
                    <td>${order.id}</td>
                    <td>${order.orderNo}</td>
                    <td>${order.product.title}</td>
                    <td>${order.buyer.username}</td>
                    <td>¥${order.price}</td>
                    <td>
                            <span class="status-tag status-${order.status}">
                                <c:if test="${order.status == 0}">已取消</c:if>
                                <c:if test="${order.status == 1}">待发货</c:if>
                                <c:if test="${order.status == 2}">已发货</c:if>
                                <c:if test="${order.status == 3}">已完成</c:if>
                            </span>
                    </td>
                    <td><fmt:formatDate value="${order.createTime}" pattern="yyyy年MM月dd日 HH:mm:ss"/></td>
                    <td>
                        <select class="layui-btn layui-btn-xs" style="height:30px;padding:0 10px;border:1px solid #ddd;border-radius:4px;" onchange="updateStatus(${order.id}, this.value)">
                            <option value="">修改状态</option>
                            <option value="0" ${order.status == 0 ? 'selected' : ''}>已取消</option>
                            <option value="1" ${order.status == 1 ? 'selected' : ''}>待发货</option>
                            <option value="2" ${order.status == 2 ? 'selected' : ''}>已发货</option>
                            <option value="3" ${order.status == 3 ? 'selected' : ''}>已完成</option>
                        </select>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty pageInfo.list}">
                <tr><td colspan="8" style="text-align:center;color:#999;padding:30px;">暂无订单</td></tr>
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

        window.updateStatus = function(id, status) {
            if (!status) return;
            var statusText = ['已取消', '待发货', '已发货', '已完成'][status];
            layer.confirm('确认将订单状态修改为：' + statusText + '？', function(index) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/order/updateStatus',
                    type: 'POST',
                    data: { id: id, status: status },
                    dataType: 'json',
                    success: function(res) {
                        if (res.code === 0) {
                            layer.msg('✅ 操作成功', {icon: 1});
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