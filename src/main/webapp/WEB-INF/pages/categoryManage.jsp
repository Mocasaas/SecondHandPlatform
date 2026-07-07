<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>分类管理 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        body { background: #f5f5f5; }
        .container { max-width: 800px; margin: 40px auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 12px rgba(0,0,0,0.1); }
        .header-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .header-bar h2 { margin: 0; }
        .add-form { display: flex; gap: 10px; margin-bottom: 20px; }
        .add-form input { flex: 1; height: 38px; padding: 0 10px; border: 1px solid #ddd; border-radius: 4px; }
        .add-form input:focus { border-color: #1E9FFF; outline: none; }
        .category-list { border: 1px solid #eee; border-radius: 4px; }
        .category-item { display: flex; justify-content: space-between; align-items: center; padding: 12px 15px; border-bottom: 1px solid #f0f0f0; }
        .category-item:last-child { border-bottom: none; }
        .category-item .name { font-size: 15px; }
        .category-item .actions { display: flex; gap: 8px; }
        .category-item .actions .layui-btn { padding: 0 12px; height: 28px; line-height: 28px; font-size: 12px; }
        .empty-tip { text-align: center; padding: 40px 0; color: #999; }
    </style>
</head>
<body>
<div class="container">
    <div class="header-bar">
        <h2>📁 商品分类管理</h2>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="layui-btn layui-btn-sm layui-btn-primary">← 返回管理后台</a>
    </div>

    <!-- 添加分类 -->
    <div class="add-form">
        <input type="text" id="newCategoryName" placeholder="输入新分类名称" onkeydown="if(event.keyCode==13) addCategory()">
        <button class="layui-btn" onclick="addCategory()">添加分类</button>
    </div>

    <!-- 分类列表 -->
    <div class="category-list" id="categoryList">
        <c:forEach items="${categories}" var="c">
            <div class="category-item" data-id="${c.id}">
                <span class="name">${c.name}</span>
                <div class="actions">
                    <button class="layui-btn layui-btn-xs layui-btn-normal" onclick="editCategory(this, ${c.id}, '${c.name}')">编辑</button>
                    <button class="layui-btn layui-btn-xs layui-btn-danger" onclick="deleteCategory(${c.id})">删除</button>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty categories}">
            <div class="empty-tip">暂无分类，请添加</div>
        </c:if>
    </div>
</div>

<script src="${pageContext.request.contextPath}/lib/layui/layui.js"></script>
<script>
    layui.use(['layer', 'jquery'], function() {
        var layer = layui.layer;
        var $ = layui.$;

        window.addCategory = function() {
            var name = $('#newCategoryName').val().trim();
            if (!name) {
                layer.msg('请输入分类名称', {icon: 0});
                return;
            }
            $.ajax({
                url: '${pageContext.request.contextPath}/category/add',
                type: 'POST',
                data: { name: name },
                dataType: 'json',
                success: function(res) {
                    if (res.code === 0) {
                        layer.msg('✅ 添加成功', {icon: 1});
                        setTimeout(function() { location.reload(); }, 600);
                    } else {
                        layer.msg('❌ ' + res.msg, {icon: 2});
                    }
                }
            });
        };

        window.editCategory = function(btn, id, oldName) {
            layer.prompt({
                title: '修改分类名称',
                value: oldName,
                formType: 0,
                area: ['400px']
            }, function(value, index) {
                value = value.trim();
                if (!value) {
                    layer.msg('分类名称不能为空', {icon: 0});
                    return;
                }
                $.ajax({
                    url: '${pageContext.request.contextPath}/category/update',
                    type: 'POST',
                    data: { id: id, name: value },
                    dataType: 'json',
                    success: function(res) {
                        if (res.code === 0) {
                            layer.msg('✅ 修改成功', {icon: 1});
                            setTimeout(function() { location.reload(); }, 600);
                        } else {
                            layer.msg('❌ ' + res.msg, {icon: 2});
                        }
                    }
                });
                layer.close(index);
            });
        };

        window.deleteCategory = function(id) {
            layer.confirm('确认删除该分类？', function(index) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/category/delete',
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