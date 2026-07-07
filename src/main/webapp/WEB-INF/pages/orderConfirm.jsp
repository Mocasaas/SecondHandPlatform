<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>确认订单</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
  <style>
    body { background: #f5f5f5; }
    .confirm-box { max-width: 800px; margin: 40px auto; background: #fff; padding: 30px 40px; border-radius: 8px; box-shadow: 0 2px 12px rgba(0,0,0,0.1); }
    .confirm-box h2 { margin-bottom: 20px; }
    .product-item { display: flex; gap: 20px; padding: 15px 0; border-bottom: 1px solid #f0f0f0; align-items: center; }
    .product-item:last-child { border-bottom: none; }
    .product-item img { width: 80px; height: 80px; object-fit: cover; border-radius: 6px; background: #eee; }
    .product-item .detail { flex: 1; }
    .product-item .detail .title { font-size: 15px; font-weight: bold; }
    .product-item .detail .seller { color: #999; font-size: 13px; }
    .product-item .detail .price { color: #FF5722; font-size: 18px; font-weight: bold; }
    .total-row { display: flex; justify-content: flex-end; padding: 20px 0; font-size: 18px; border-top: 2px solid #f0f0f0; margin-top: 10px; }
    .total-row span { color: #FF5722; font-size: 28px; font-weight: bold; margin-left: 10px; }
    .btn-group { display: flex; gap: 15px; justify-content: center; padding-top: 20px; }
    .btn-group .layui-btn { min-width: 120px; }
    .empty-tip { text-align: center; padding: 30px 0; color: #999; }
  </style>
</head>
<body>

<div class="confirm-box">
  <h2>📋 确认订单</h2>

  <c:if test="${empty products}">
    <div class="empty-tip">😅 没有可购买的商品</div>
  </c:if>

  <c:if test="${not empty products}">
    <c:forEach items="${products}" var="p">
      <div class="product-item">
        <c:if test="${not empty p.image}">
          <img src="${pageContext.request.contextPath}${p.image}" alt="${p.title}">
        </c:if>
        <c:if test="${empty p.image}">
          <img src="${pageContext.request.contextPath}/lib/layui/images/face/0.gif" alt="暂无图片">
        </c:if>
        <div class="detail">
          <div class="title">${p.title}</div>
          <div class="seller">发布者：${p.username}</div>
          <div class="price">¥${p.price}</div>
        </div>
      </div>
    </c:forEach>

    <div class="total-row">
      共 <span id="productCount">${products.size()}</span> 件商品，实付款：<span id="totalAmount">¥${totalPrice}</span>
    </div>

    <div class="btn-group">
      <button class="layui-btn layui-btn-normal layui-btn-lg" id="submitOrder">✅ 确认下单</button>
      <a href="${pageContext.request.contextPath}/product/detail?id=${products[0].id}" class="layui-btn layui-btn-lg layui-btn-primary" id="backBtn">← 返回</a>
    </div>
  </c:if>
</div>

<script src="${pageContext.request.contextPath}/lib/layui/layui.js"></script>
<script>
  layui.use(['layer', 'jquery'], function() {
    var layer = layui.layer;
    var $ = layui.$;

    var productIds = [];
    <c:forEach items="${products}" var="p" varStatus="status">
    productIds.push(${p.id});
    </c:forEach>

    var isBatch = ${isBatch};

    $('#submitOrder').click(function() {
      var confirmMsg = isBatch ? '确认购买选中的 ' + productIds.length + ' 件商品？' : '确认购买该商品？';
      layer.confirm(confirmMsg, function(index) {
        var url = isBatch ? '${pageContext.request.contextPath}/order/batchCreate' : '${pageContext.request.contextPath}/order/create';
        var data = isBatch ? { productIds: productIds.join(',') } : { productId: productIds[0] };

        $.ajax({
          url: url,
          type: 'POST',
          data: data,
          dataType: 'json',
          success: function(res) {
            if (res.code === 0) {
              layer.msg('✅ 下单成功！', {icon: 1});
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
        layer.close(index);
      });
    });
  });
</script>

</body>
</html>