<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品管理 - 管理员</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        body { background: #f5f5f5; }
        .container { max-width: 1200px; margin: 20px auto; padding: 0 15px; }
        .header-bar { background: #fff; padding: 15px 25px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 10px; }
        .search-box { display: flex; gap: 10px; flex-wrap: wrap; }
        .search-box input, .search-box select { height: 36px; padding: 0 10px; border: 1px solid #ddd; border-radius: 4px; }
        .search-box input:focus, .search-box select:focus { border-color: #1E9FFF; outline: none; }
        .table-wrap { background: #fff; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); padding: 15px; overflow-x: auto; }
        .status-tag { padding: 2px 10px; border-radius: 12px; font-size: 12px; }
        .status-0 { background: #dff0d8; color: #3c763d; }
        .status-1 { background: #fcf8e3; color: #8a6d3b; }
        .status-2 { background: #f2dede; color: #a94442; }
        .pagination-box { margin-top: 20px; text-align: center; }
    </style>
</head>
<body>

<div class="container">

    <div class="header-bar">
        <span style="font-size:18px; font-weight:bold;">📦 商品管理</span>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="layui-btn layui-btn-sm layui-btn-primary">← 返回管理后台</a>
    </div>

    <div class="header-bar">
        <form class="search-box" onsubmit="return false;">
            <input type="text" id="keyword" placeholder="搜索商品标题..." value="${keyword}">
            <select id="categoryId">
                <option value="">全部分类</option>
                <c:forEach items="${categories}" var="c">
                    <option value="${c.id}" ${c.id == categoryId ? 'selected' : ''}>${c.name}</option>
                </c:forEach>
            </select>
            <button class="layui-btn layui-btn-sm" onclick="search()">搜索</button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" onclick="resetSearch()">重置</button>
        </form>
        <span style="color:#999;">共 ${pageInfo.total} 件商品</span>
    </div>

    <div class="table-wrap">
        <table class="layui-table" lay-skin="line">
            <thead>
            <tr>
                <th style="width:50px;">ID</th>
                <th style="width:70px;">图片</th>
                <th>标题</th>
                <th style="width:90px;">价格</th>
                <th style="width:110px;">发布者</th>
                <th style="width:80px;">状态</th>
                <th style="width:90px;">浏览量</th>
                <th style="width:150px;">发布时间</th>
                <th style="width:200px;">操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${pageInfo.list}" var="p">
                <tr>
                    <td>${p.id}</td>
                    <td>
                        <c:if test="${not empty p.image}">
                            <img src="${pageContext.request.contextPath}${p.image}" style="width:50px;height:50px;object-fit:cover;border-radius:4px;">
                        </c:if>
                        <c:if test="${empty p.image}">
                            <span style="color:#ccc;">无</span>
                        </c:if>
                    </td>
                    <td>${p.title}</td>
                    <td>¥${p.price}</td>
                    <td>${p.username}</td>
                    <td>
                            <span class="status-tag status-${p.status}">
                                <c:if test="${p.status == 0}">在售</c:if>
                                <c:if test="${p.status == 1}">已售出</c:if>
                                <c:if test="${p.status == 2}">已下架</c:if>
                            </span>
                    </td>
                    <td>${p.viewCount}</td>
                    <td><fmt:formatDate value="${p.createTime}" pattern="yyyy年MM月dd日"/></td>
                    <td>
                        <button class="layui-btn layui-btn-xs layui-btn-normal" onclick="viewDetail(${p.id})">查看</button>
                        <c:if test="${p.status == 0}">
                            <button class="layui-btn layui-btn-xs layui-btn-warm" onclick="updateStatus(${p.id}, 2)">下架</button>
                        </c:if>
                        <c:if test="${p.status == 2}">
                            <button class="layui-btn layui-btn-xs layui-btn-normal" onclick="updateStatus(${p.id}, 0)">上架</button>
                        </c:if>
                        <button class="layui-btn layui-btn-xs layui-btn-danger" onclick="deleteProduct(${p.id})">删除</button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty pageInfo.list}">
                <tr><td colspan="9" style="text-align:center;color:#999;padding:30px;">暂无商品</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <c:if test="${pageInfo.pages > 1}">
        <div class="pagination-box">
            <c:if test="${pageInfo.pageNum > 1}">
                <a href="?pageNum=1&keyword=${keyword}&categoryId=${categoryId}" class="layui-btn layui-btn-sm">首页</a>
                <a href="?pageNum=${pageInfo.pageNum - 1}&keyword=${keyword}&categoryId=${categoryId}" class="layui-btn layui-btn-sm">上一页</a>
            </c:if>
            <span style="margin:0 10px;">${pageInfo.pageNum} / ${pageInfo.pages}</span>
            <c:if test="${pageInfo.pageNum < pageInfo.pages}">
                <a href="?pageNum=${pageInfo.pageNum + 1}&keyword=${keyword}&categoryId=${categoryId}" class="layui-btn layui-btn-sm">下一页</a>
                <a href="?pageNum=${pageInfo.pages}&keyword=${keyword}&categoryId=${categoryId}" class="layui-btn layui-btn-sm">末页</a>
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
            var categoryId = $('#categoryId').val();
            location.href = '?keyword=' + encodeURIComponent(keyword) + '&categoryId=' + categoryId;
        };

        window.resetSearch = function() {
            $('#keyword').val('');
            $('#categoryId').val('');
            location.href = '?';
        };

        window.viewDetail = function(id) {
            window.open('${pageContext.request.contextPath}/product/detail?id=' + id, '_blank');
        };

        window.updateStatus = function(id, status) {
            var text = status === 0 ? '上架' : '下架';
            layer.confirm('确认' + text + '该商品？', function(index) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/product/updateStatus',
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

        window.deleteProduct = function(id) {
            layer.confirm('确认删除该商品？此操作不可恢复！', {icon: 2}, function(index) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/product/delete',
                    type: 'POST',
                    data: { id: id },
                    dataType: 'json',
                    success: function(res) {
                        if (res.code === 0) {
                            layer.msg('✅ 删除成功', {icon: 1});
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