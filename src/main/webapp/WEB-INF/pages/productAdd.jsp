<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>发布商品</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        body { background: #f5f5f5; }
        .form-box { max-width: 600px; margin: 40px auto; background: #fff; padding: 40px; border-radius: 8px; box-shadow: 0 2px 12px rgba(0,0,0,0.1); }
        .form-box h2 { text-align: center; margin-bottom: 30px; }
        .form-box .layui-form-label { width: 100px; }
        .form-box .layui-input-block { margin-left: 130px; }
    </style>
</head>
<body>
<div class="form-box">
    <h2>📝 发布商品</h2>
    <form class="layui-form" id="productForm">
        <div class="layui-form-item">
            <label class="layui-form-label">标题</label>
            <div class="layui-input-block">
                <input type="text" name="title" lay-verify="required" placeholder="请输入商品标题" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">分类</label>
            <div class="layui-input-block">
                <select name="categoryId" lay-verify="required">
                    <option value="">请选择分类</option>
                    <c:forEach items="${categories}" var="c">
                        <option value="${c.id}">${c.name}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">价格(元)</label>
            <div class="layui-input-block">
                <input type="text" name="price" lay-verify="required|number" placeholder="0.00" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">图片</label>
            <div class="layui-input-block">
                <input type="file" name="file" id="fileInput" accept="image/*">
                <div id="preview" style="margin-top:10px;"></div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">描述</label>
            <div class="layui-input-block">
                <textarea name="description" class="layui-textarea" style="height:120px;"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block" style="margin-left:130px;">
                <button type="button" class="layui-btn layui-btn-normal" lay-submit lay-filter="submitBtn">立即发布</button>
                <a href="${pageContext.request.contextPath}/" class="layui-btn layui-btn-primary">返回首页</a>
            </div>
        </div>
    </form>
</div>

<script src="${pageContext.request.contextPath}/lib/layui/layui.js"></script>
<script>
    layui.use(['form', 'layer', 'jquery'], function() {
        var form = layui.form;
        var layer = layui.layer;
        var $ = layui.$;

        // 图片预览
        $('#fileInput').change(function() {
            var file = this.files[0];
            if (file) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    $('#preview').html('<img src="' + e.target.result + '" style="max-width:200px;max-height:200px;border-radius:4px;">');
                };
                reader.readAsDataURL(file);
            }
        });

        form.on('submit(submitBtn)', function(data) {
            var formData = new FormData();
            formData.append('title', data.field.title);
            formData.append('categoryId', data.field.categoryId);
            formData.append('price', data.field.price);
            formData.append('description', data.field.description || '');
            var file = $('#fileInput')[0].files[0];
            if (file) formData.append('file', file);

            $.ajax({
                url: '${pageContext.request.contextPath}/product/add',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                dataType: 'json',
                success: function(res) {
                    if (res.code === 0) {
                        layer.msg('✅ ' + res.msg, {icon: 1});
                        setTimeout(function() {
                            window.location.href = '${pageContext.request.contextPath}/';
                        }, 1200);
                    } else {
                        layer.msg('❌ ' + res.msg, {icon: 2});
                    }
                },
                error: function() {
                    layer.msg('网络异常，请重试', {icon: 2});
                }
            });
            return false;
        });
    });
</script>
</body>
</html>