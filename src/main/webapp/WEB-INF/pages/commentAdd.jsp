<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>发表评价</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
  <style>
    body { background: #f5f5f5; }
    .container { max-width: 600px; margin: 40px auto; background: #fff; padding: 40px; border-radius: 8px; box-shadow: 0 2px 12px rgba(0,0,0,0.1); }
    .star-group { display: flex; gap: 10px; font-size: 30px; cursor: pointer; margin: 20px 0; }
    .star-group .star { color: #ddd; transition: color 0.2s; }
    .star-group .star.active { color: #FFB800; }
  </style>
</head>
<body>

<div class="container">
  <h2 style="text-align:center;">⭐ 发表评价</h2>
  <c:if test="${not empty msg}">
    <div style="text-align:center;color:#FF5722;margin-bottom:15px;">${msg}</div>
  </c:if>

  <form id="commentForm">
    <input type="hidden" name="orderId" value="${orderId}">
    <div style="text-align:center;margin:20px 0;">
      <div class="star-group" id="starGroup">
        <span class="star" data-value="1">★</span>
        <span class="star" data-value="2">★</span>
        <span class="star" data-value="3">★</span>
        <span class="star" data-value="4">★</span>
        <span class="star" data-value="5">★</span>
      </div>
      <input type="hidden" name="rating" id="rating" value="5">
    </div>
    <div class="layui-form-item">
      <textarea name="content" class="layui-textarea" placeholder="请输入评价内容（选填）" style="height:150px;"></textarea>
    </div>
    <div style="text-align:center;">
      <button type="button" class="layui-btn layui-btn-normal" id="submitBtn">提交评价</button>
      <a href="${pageContext.request.contextPath}/order/myOrders" class="layui-btn layui-btn-primary">返回订单</a>
    </div>
  </form>
</div>

<script src="${pageContext.request.contextPath}/lib/layui/layui.js"></script>
<script>
  layui.use(['layer', 'jquery'], function() {
    var layer = layui.layer;
    var $ = layui.$;

    // 星星选择
    $('#starGroup .star').on('click', function() {
      var val = $(this).data('value');
      $('#rating').val(val);
      $('#starGroup .star').each(function() {
        $(this).toggleClass('active', $(this).data('value') <= val);
      });
    });
    // 默认5星
    $('#starGroup .star').each(function() {
      $(this).toggleClass('active', $(this).data('value') <= 5);
    });

    $('#submitBtn').click(function() {
      var orderId = $('input[name="orderId"]').val();
      var rating = $('#rating').val();
      var content = $('textarea[name="content"]').val();

      $.ajax({
        url: '${pageContext.request.contextPath}/comment/submit',
        type: 'POST',
        data: { orderId: orderId, rating: rating, content: content },
        dataType: 'json',
        success: function(res) {
          if (res.code === 0) {
            layer.msg('✅ ' + res.msg, {icon: 1});
            setTimeout(function() {
              window.location.href = '${pageContext.request.contextPath}/order/myOrders';
            }, 1200);
          } else {
            layer.msg('❌ ' + res.msg, {icon: 2});
          }
        },
        error: function() {
          layer.msg('网络异常，请重试', {icon: 2});
        }
      });
    });
  });
</script>
</body>
</html>