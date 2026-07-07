<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的购物车</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        body { background: #f5f5f5; }
        .container { max-width: 1000px; margin: 20px auto; padding: 0 15px; }
        .header-bar { background: #fff; padding: 15px 25px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .cart-list { background: #fff; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
        .cart-item { display: flex; align-items: center; padding: 15px 20px; border-bottom: 1px solid #f0f0f0; gap: 15px; }
        .cart-item:last-child { border-bottom: none; }
        .cart-item .checkbox { flex-shrink: 0; }
        .cart-item img { width: 80px; height: 80px; object-fit: cover; border-radius: 4px; background: #eee; flex-shrink: 0; }
        .cart-item .info { flex: 1; }
        .cart-item .info .title { font-size: 16px; font-weight: bold; }
        .cart-item .info .price { color: #FF5722; font-size: 18px; font-weight: bold; margin-top: 5px; }
        .cart-item .info .seller { color: #999; font-size: 13px; }
        .cart-item .quantity-box { display: flex; align-items: center; gap: 8px; }
        .cart-item .quantity-box button { width: 30px; height: 30px; border: 1px solid #ddd; border-radius: 4px; background: #fff; cursor: pointer; font-size: 16px; }
        .cart-item .quantity-box button:hover { background: #f0f0f0; }
        .cart-item .quantity-box input { width: 50px; height: 30px; text-align: center; border: 1px solid #ddd; border-radius: 4px; }
        .cart-item .subtotal { font-size: 16px; font-weight: bold; color: #FF5722; width: 100px; text-align: right; flex-shrink: 0; }
        .cart-item .actions { flex-shrink: 0; }
        .cart-footer { background: #fff; padding: 15px 20px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); margin-top: 20px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px; }
        .cart-footer .total { font-size: 20px; }
        .cart-footer .total span { color: #FF5722; font-size: 28px; font-weight: bold; }
        .empty-tip { text-align: center; padding: 60px 0; color: #999; }
        .empty-tip a { color: #1E9FFF; }
        .status-offline { color: #999; font-size: 12px; background: #f0f0f0; padding: 2px 8px; border-radius: 4px; }
    </style>
</head>
<body>

<div class="container">

    <div class="header-bar">
        <span style="font-size:18px; font-weight:bold;">🛒 我的购物车</span>
        <a href="${pageContext.request.contextPath}/" class="layui-btn layui-btn-sm layui-btn-primary">← 继续购物</a>
    </div>

    <div class="cart-list" id="cartList">
        <c:forEach items="${cartList}" var="cart">
            <div class="cart-item" data-id="${cart.id}" data-product-id="${cart.productId}">
                <div class="checkbox">
                    <input type="checkbox" class="item-checkbox" ${cart.product.status != 0 ? 'disabled' : ''}>
                </div>
                <img src="${pageContext.request.contextPath}${cart.product.image}" alt="${cart.product.title}">
                <div class="info">
                    <div class="title">${cart.product.title}</div>
                    <div class="seller">发布者：${cart.product.username}</div>
                    <div class="price">¥${cart.product.price}</div>
                    <c:if test="${cart.product.status != 0}">
                        <span class="status-offline">该商品已下架或售出</span>
                    </c:if>
                </div>
                <div class="quantity-box">
                    <button onclick="changeQuantity(this, -1)">-</button>
                    <input type="text" class="quantity-input" value="${cart.quantity}" readonly>
                    <button onclick="changeQuantity(this, 1)">+</button>
                </div>
                <div class="subtotal">¥<span class="item-subtotal">${cart.product.price * cart.quantity}</span></div>
                <div class="actions">
                    <button class="layui-btn layui-btn-xs layui-btn-danger" onclick="deleteCartItem(${cart.id}, this)">删除</button>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty cartList}">
            <div class="empty-tip">🛒 购物车是空的，<a href="${pageContext.request.contextPath}/">去逛逛吧</a></div>
        </c:if>
    </div>

    <c:if test="${not empty cartList}">
        <div class="cart-footer">
            <div>
                <button class="layui-btn layui-btn-sm" onclick="selectAll()">全选</button>
                <button class="layui-btn layui-btn-sm layui-btn-primary" onclick="unselectAll()">取消全选</button>
                <button class="layui-btn layui-btn-sm layui-btn-danger" onclick="deleteSelected()">删除选中</button>
            </div>
            <div class="total">
                合计：¥<span id="totalAmount">${total}</span>
            </div>
            <div>
                <button class="layui-btn layui-btn-normal layui-btn-lg" onclick="checkout()">结算</button>
            </div>
        </div>
    </c:if>

</div>

<script src="${pageContext.request.contextPath}/lib/layui/layui.js"></script>
<script>
    layui.use(['layer', 'jquery'], function() {
        var layer = layui.layer;
        var $ = layui.$;

        // ========== 修改数量 ==========
        window.changeQuantity = function(btn, delta) {
            var item = $(btn).closest('.cart-item');
            var cartId = item.data('id');
            var input = item.find('.quantity-input');
            var current = parseInt(input.val()) || 1;
            var newQuantity = Math.max(1, current + delta);
            if (newQuantity === current) return;

            $.ajax({
                url: '${pageContext.request.contextPath}/cart/update',
                type: 'POST',
                data: { cartId: cartId, quantity: newQuantity },
                dataType: 'json',
                success: function(res) {
                    if (res.code === 0) {
                        input.val(newQuantity);
                        updateSubtotal(item);
                        updateTotal();
                    } else {
                        layer.msg(res.msg, {icon: 2});
                    }
                }
            });
        };

        // ========== 删除单个商品（已修复） ==========
        window.deleteCartItem = function(cartId, btn) {
            if (!cartId) {
                layer.msg('参数错误', {icon: 2});
                return;
            }
            layer.confirm('确认删除该商品？', {icon: 0}, function(index) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/cart/delete',
                    type: 'POST',
                    data: { cartId: cartId },
                    dataType: 'json',
                    success: function(res) {
                        if (res.code === 0) {
                            layer.msg('✅ 已删除', {icon: 1});
                            // 直接移除该行，不刷新整个页面
                            var item = $(btn).closest('.cart-item');
                            item.remove();
                            updateTotal();
                            // 如果购物车为空，刷新页面显示空状态
                            if ($('.cart-item').length === 0) {
                                location.reload();
                            }
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
        };

        // ========== 更新小计 ==========
        function updateSubtotal(item) {
            var price = parseFloat(item.find('.price').text().replace('¥', ''));
            var quantity = parseInt(item.find('.quantity-input').val()) || 1;
            var subtotal = price * quantity;
            item.find('.item-subtotal').text(subtotal.toFixed(2));
        }

        // ========== 更新总价 ==========
        function updateTotal() {
            var total = 0;
            $('.cart-item').each(function() {
                var checkbox = $(this).find('.item-checkbox');
                if (checkbox.is(':checked') && !checkbox.is(':disabled')) {
                    var subtotal = parseFloat($(this).find('.item-subtotal').text()) || 0;
                    total += subtotal;
                }
            });
            $('#totalAmount').text(total.toFixed(2));
        }

        // ========== 全选 ==========
        window.selectAll = function() {
            $('.item-checkbox:not(:disabled)').prop('checked', true);
            updateTotal();
        };

        // ========== 取消全选 ==========
        window.unselectAll = function() {
            $('.item-checkbox').prop('checked', false);
            updateTotal();
        };

        // ========== 删除选中 ==========
        window.deleteSelected = function() {
            var ids = [];
            $('.item-checkbox:checked').each(function() {
                var item = $(this).closest('.cart-item');
                ids.push(item.data('id'));
            });
            if (ids.length === 0) {
                layer.msg('请先选择商品', {icon: 0});
                return;
            }
            layer.confirm('确认删除选中的 ' + ids.length + ' 件商品？', function(index) {
                var done = 0;
                var total = ids.length;
                ids.forEach(function(id) {
                    $.ajax({
                        url: '${pageContext.request.contextPath}/cart/delete',
                        type: 'POST',
                        data: { cartId: id },
                        dataType: 'json',
                        success: function() {
                            done++;
                            if (done >= total) {
                                location.reload();
                            }
                        },
                        error: function() {
                            done++;
                            if (done >= total) {
                                location.reload();
                            }
                        }
                    });
                });
                layer.close(index);
            });
        };

        // ========== 复选框变化时更新总价 ==========
        $(document).on('change', '.item-checkbox', function() {
            updateTotal();
        });

        // ========== 结算 ==========
        window.checkout = function() {
            var ids = [];
            $('.item-checkbox:checked').each(function() {
                var item = $(this).closest('.cart-item');
                var id = item.data('id');
                if (id && !isNaN(id) && id > 0) {
                    ids.push(id);
                }
            });
            if (ids.length === 0) {
                layer.msg('请先选择要购买的商品', {icon: 0});
                return;
            }
            var cartIds = ids.join(',');
            $.ajax({
                url: '${pageContext.request.contextPath}/cart/checkout',
                type: 'POST',
                data: { cartIds: cartIds },
                dataType: 'json',
                success: function(res) {
                    if (res.code === 0) {
                        var productIds = res.data || res.msg;
                        if (!productIds || productIds.length === 0) {
                            layer.msg('所选商品无效，请重新选择', {icon: 2});
                            return;
                        }
                        layer.msg('✅ 准备结算', {icon: 1});
                        setTimeout(function() {
                            window.location.href = '${pageContext.request.contextPath}/order/batchConfirm?productIds=' + encodeURIComponent(productIds);
                        }, 800);
                    } else {
                        layer.msg('❌ ' + res.msg, {icon: 2});
                    }
                },
                error: function() {
                    layer.msg('网络异常，请重试', {icon: 2});
                }
            });
        };
    });
</script>

</body>
</html>