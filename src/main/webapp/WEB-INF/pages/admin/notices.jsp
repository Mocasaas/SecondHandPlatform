<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>公告管理 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        body { background: #f5f5f5; }
        .container { max-width: 1100px; margin: 20px auto; padding: 0 15px; }
        .header-bar { background: #fff; padding: 15px 25px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .toolbar { background: #fff; padding: 15px 25px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); margin-bottom: 20px; display: flex; gap: 15px; flex-wrap: wrap; align-items: center; }
        .table-wrap { background: #fff; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); padding: 15px; overflow-x: auto; }
        .badge { padding: 2px 10px; border-radius: 12px; font-size: 12px; }
        .badge-top { background: #FF5722; color: #fff; }
        .badge-hot { background: #FFB800; color: #fff; }
        .badge-info { background: #1E9FFF; color: #fff; }
        .badge-draft { background: #999; color: #fff; }
        .badge-published { background: #5FB878; color: #fff; }
        .pagination-box { margin-top: 20px; text-align: center; }
        .notice-preview { max-height: 60px; overflow: hidden; text-overflow: ellipsis; }
    </style>
</head>
<body>

<div class="container">
    <div class="header-bar">
        <span style="font-size:18px; font-weight:bold;">📢 公告管理</span>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="layui-btn layui-btn-sm layui-btn-primary">← 返回管理后台</a>
    </div>

    <div class="toolbar">
        <button class="layui-btn layui-btn-sm" onclick="openAddModal()">+ 新增公告</button>
        <span style="color:#999;font-size:13px;">共 ${notices.size()} 条公告</span>
    </div>

    <div class="table-wrap">
        <table class="layui-table" lay-skin="line">
            <thead>
            <tr>
                <th style="width:50px;">ID</th>
                <th style="width:200px;">标题</th>
                <th style="width:80px;">类型</th>
                <th style="width:60px;">置顶</th>
                <th style="width:80px;">状态</th>
                <th style="width:80px;">浏览量</th>
                <th style="width:150px;">创建时间</th>
                <th style="width:220px;">操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${notices}" var="n">
                <tr>
                    <td>${n.id}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/notice/detail?id=${n.id}" target="_blank" style="color:#333;">${n.title}</a>
                    </td>
                    <td>
                            <span class="badge ${n.type == 'hot' ? 'badge-hot' : n.type == 'promotion' ? 'badge-info' : 'badge-info'}">
                                    ${n.type}
                            </span>
                    </td>
                    <td>${n.isTop == 1 ? '✅' : ''}</td>
                    <td>
                            <span class="badge ${n.status == 1 ? 'badge-published' : 'badge-draft'}">
                                    ${n.status == 1 ? '已发布' : '草稿'}
                            </span>
                    </td>
                    <td>${n.viewCount}</td>
                    <td>${n.createTime}</td>
                    <td>
                        <button class="layui-btn layui-btn-xs layui-btn-normal" onclick="editNotice(${n.id})">编辑</button>
                        <button class="layui-btn layui-btn-xs layui-btn-warm" onclick="toggleStatus(${n.id}, ${n.status})">
                                ${n.status == 1 ? '下架' : '发布'}
                        </button>
                        <button class="layui-btn layui-btn-xs layui-btn-danger" onclick="deleteNotice(${n.id})">删除</button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty notices}">
                <tr><td colspan="8" style="text-align:center;color:#999;padding:30px;">暂无公告</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<script src="${pageContext.request.contextPath}/lib/layui/layui.js"></script>
<script>
    layui.use(['layer', 'form', 'jquery'], function() {
        var layer = layui.layer;
        var form = layui.form;
        var $ = layui.$;

        // 打开新增弹窗
        window.openAddModal = function() {
            var html = buildFormHtml(null);
            var index = layer.open({
                type: 1,
                title: '📝 新增公告',
                area: ['650px', '550px'],
                content: html,
                btn: ['发布', '保存草稿', '取消'],
                yes: function() { submitNotice(index, 1); },
                btn2: function() { submitNotice(index, 0); },
                btn3: function() { layer.close(index); }
            });
        };

        // 编辑公告（先获取数据再弹窗）
        window.editNotice = function(id) {
            $.ajax({
                url: '${pageContext.request.contextPath}/notice/get',
                type: 'GET',
                data: { id: id },
                dataType: 'json',
                success: function(res) {
                    if (res.code === 0) {
                        var data = res.data;
                        var html = buildFormHtml(data);
                        var index = layer.open({
                            type: 1,
                            title: '✏️ 编辑公告',
                            area: ['650px', '550px'],
                            content: html,
                            btn: ['保存修改', '取消'],
                            yes: function() { submitNotice(index, data.status, true); },
                            btn2: function() { layer.close(index); }
                        });
                    } else {
                        layer.msg('获取数据失败', {icon: 2});
                    }
                },
                error: function() {
                    layer.msg('网络异常', {icon: 2});
                }
            });
        };

        // 切换发布状态
        window.toggleStatus = function(id, currentStatus) {
            var newStatus = currentStatus == 1 ? 0 : 1;
            var msg = newStatus == 1 ? '确认发布该公告？' : '确认下架该公告？';
            layer.confirm(msg, function(index) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/notice/update',
                    type: 'POST',
                    data: { id: id, status: newStatus },
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

        // 删除公告
        window.deleteNotice = function(id) {
            layer.confirm('确认删除该公告？', function(index) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/notice/delete',
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

        // 构建表单HTML
        function buildFormHtml(data) {
            data = data || {};
            var isEdit = !!data.id;
            return '<form class="layui-form" style="padding:20px;" id="noticeForm">' +
                '<input type="hidden" name="id" value="' + (data.id || '') + '">' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label">标题</label>' +
                '<div class="layui-input-block"><input type="text" name="title" lay-verify="required" value="' + (data.title || '') + '" class="layui-input"></div>' +
                '</div>' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label">类型</label>' +
                '<div class="layui-input-block">' +
                '<select name="type">' +
                '<option value="info" ' + (data.type == 'info' ? 'selected' : '') + '>📢 公告</option>' +
                '<option value="hot" ' + (data.type == 'hot' ? 'selected' : '') + '>🔥 热卖</option>' +
                '<option value="promotion" ' + (data.type == 'promotion' ? 'selected' : '') + '>🎉 促销</option>' +
                '</select>' +
                '</div>' +
                '</div>' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label">置顶</label>' +
                '<div class="layui-input-block">' +
                '<input type="checkbox" name="isTop" value="1" lay-skin="switch" ' + (data.isTop == 1 ? 'checked' : '') + '>' +
                '</div>' +
                '</div>' +
                '<div class="layui-form-item">' +
                '<label class="layui-form-label">内容</label>' +
                '<div class="layui-input-block"><textarea name="content" class="layui-textarea" style="height:200px;">' + (data.content || '') + '</textarea></div>' +
                '</div>' +
                '</form>';
        }

        // 提交公告
        function submitNotice(index, status, isEdit) {
            var formEl = $('#noticeForm');
            var data = {
                id: formEl.find('input[name="id"]').val(),
                title: formEl.find('input[name="title"]').val(),
                type: formEl.find('select[name="type"]').val(),
                isTop: formEl.find('input[name="isTop"]').is(':checked') ? 1 : 0,
                content: formEl.find('textarea[name="content"]').val(),
                status: status
            };

            if (!data.title) {
                layer.msg('请输入标题', {icon: 0});
                return;
            }

            var url = isEdit ? '${pageContext.request.contextPath}/notice/update' : '${pageContext.request.contextPath}/notice/add';

            $.ajax({
                url: url,
                type: 'POST',
                data: data,
                dataType: 'json',
                success: function(res) {
                    if (res.code === 0) {
                        layer.msg('✅ ' + res.msg, {icon: 1});
                        layer.close(index);
                        setTimeout(function() { location.reload(); }, 600);
                    } else {
                        layer.msg('❌ ' + res.msg, {icon: 2});
                    }
                },
                error: function() {
                    layer.msg('网络异常，请重试', {icon: 2});
                }
            });
        }
    });
</script>

</body>
</html>