<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>二手交易平台 - 首页</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui/css/layui.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: #f5f5f5; font-family: "Microsoft YaHei", sans-serif; }

        /* ===== 顶部导航 ===== */
        .header {
            background: #fff;
            padding: 12px 30px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .logo { font-size: 24px; font-weight: bold; color: #1E9FFF; }
        .logo span { color: #FF5722; }
        .search-box { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
        .search-box input {
            width: 200px;
            height: 36px;
            padding: 0 15px;
            border: 2px solid #e6e6e6;
            border-radius: 20px;
            transition: all 0.3s;
            outline: none;
        }
        .search-box input:focus { border-color: #1E9FFF; width: 240px; }
        .search-box select {
            height: 36px;
            padding: 0 15px;
            border: 2px solid #e6e6e6;
            border-radius: 20px;
            background: #fff;
            outline: none;
        }
        .search-box select:focus { border-color: #1E9FFF; }
        .user-info a { margin-left: 8px; }
        .admin-tag { background: #FF5722; color: #fff; padding: 2px 10px; border-radius: 12px; font-size: 12px; margin-left: 5px; }

        /* ===== 轮播图 ===== */
        .carousel-wrapper { max-width: 1200px; margin: 20px auto 0; padding: 0 15px; }
        .carousel-container {
            position: relative;
            width: 100%;
            height: 350px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            background: #1a1a2e;
        }
        .carousel-slides {
            display: flex;
            width: 100%;
            height: 100%;
            transition: transform 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        }
        .carousel-slide {
            min-width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 60px;
            color: #fff;
            position: relative;
            background-size: cover;
            background-position: center;
        }
        .carousel-slide .slide-content {
            max-width: 600px;
            z-index: 2;
            text-align: center;
        }
        .carousel-slide .slide-content .badge {
            display: inline-block;
            padding: 4px 16px;
            border-radius: 20px;
            font-size: 12px;
            margin-bottom: 12px;
        }
        .carousel-slide .slide-content .badge.hot { background: #FF5722; }
        .carousel-slide .slide-content .badge.info { background: #1E9FFF; }
        .carousel-slide .slide-content .badge.promotion { background: #FFB800; }
        .carousel-slide .slide-content h2 {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 12px;
            text-shadow: 0 2px 8px rgba(0,0,0,0.3);
        }
        .carousel-slide .slide-content p {
            font-size: 16px;
            opacity: 0.9;
            line-height: 1.8;
            text-shadow: 0 1px 4px rgba(0,0,0,0.3);
        }
        .carousel-slide .slide-content .btn-link {
            display: inline-block;
            margin-top: 16px;
            padding: 10px 30px;
            background: rgba(255,255,255,0.2);
            border: 2px solid rgba(255,255,255,0.6);
            border-radius: 30px;
            color: #fff;
            text-decoration: none;
            transition: all 0.3s;
            font-weight: bold;
            backdrop-filter: blur(10px);
        }
        .carousel-slide .slide-content .btn-link:hover {
            background: rgba(255,255,255,0.3);
            transform: scale(1.05);
        }
        .carousel-slide .overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0.2) 100%);
            z-index: 1;
        }
        .carousel-indicators {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 10px;
            z-index: 5;
        }
        .carousel-indicators .dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: rgba(255,255,255,0.4);
            cursor: pointer;
            transition: all 0.3s;
        }
        .carousel-indicators .dot.active {
            background: #fff;
            transform: scale(1.2);
        }
        .carousel-arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            border: none;
            color: #fff;
            font-size: 20px;
            cursor: pointer;
            z-index: 5;
            transition: all 0.3s;
            backdrop-filter: blur(10px);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .carousel-arrow:hover { background: rgba(255,255,255,0.4); }
        .carousel-arrow.prev { left: 20px; }
        .carousel-arrow.next { right: 20px; }

        /* ===== 功能按钮区 ===== */
        .feature-section { max-width: 1200px; margin: 30px auto 0; padding: 0 15px; }
        .feature-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }
        .feature-card {
            background: #fff;
            padding: 30px 20px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            transition: all 0.3s;
            cursor: pointer;
            text-decoration: none;
            color: #333;
            display: block;
        }
        .feature-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        }
        .feature-card .icon { font-size: 40px; margin-bottom: 10px; display: block; }
        .feature-card .name { font-size: 16px; font-weight: bold; }
        .feature-card .desc { font-size: 13px; color: #999; margin-top: 4px; }
        .feature-card:nth-child(1) .icon { color: #1E9FFF; }
        .feature-card:nth-child(2) .icon { color: #FFB800; }
        .feature-card:nth-child(3) .icon { color: #FF5722; }
        .feature-card:nth-child(4) .icon { color: #5FB878; }

        /* ===== 商品列表 ===== */
        .container { max-width: 1200px; margin: 30px auto 20px; padding: 0 15px; }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .section-header h3 {
            font-size: 20px;
            font-weight: bold;
            position: relative;
            padding-left: 15px;
        }
        .section-header h3::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 4px;
            height: 24px;
            background: #1E9FFF;
            border-radius: 2px;
        }
        .section-header .count { color: #999; font-size: 14px; }
        .product-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }
        .product-card {
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            transition: all 0.3s;
        }
        .product-card:hover { transform: translateY(-4px); box-shadow: 0 8px 30px rgba(0,0,0,0.12); }
        .product-card a { color: #333; text-decoration: none; }
        .product-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            background: #eee;
        }
        .product-card .info { padding: 14px 16px; }
        .product-card .title {
            font-size: 15px;
            font-weight: bold;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .product-card .price { color: #FF5722; font-size: 20px; font-weight: bold; margin: 6px 0; }
        .product-card .meta { color: #999; font-size: 12px; display: flex; justify-content: space-between; }
        .pagination-box { margin-top: 30px; text-align: center; }
        .empty-tip { text-align: center; padding: 60px 0; color: #999; font-size: 16px; }
        .empty-tip a { color: #1E9FFF; }

        @media (max-width: 768px) {
            .feature-grid { grid-template-columns: repeat(2, 1fr); }
            .product-grid { grid-template-columns: repeat(2, 1fr); }
            .carousel-container { height: 220px; }
            .carousel-slide { padding: 20px 30px; }
            .carousel-slide .slide-content h2 { font-size: 20px; }
            .carousel-slide .slide-content p { font-size: 13px; }
            .search-box input { width: 140px; }
            .search-box input:focus { width: 160px; }
        }
        @media (max-width: 480px) {
            .feature-grid { grid-template-columns: repeat(2, 1fr); }
            .product-grid { grid-template-columns: 1fr; }
            .carousel-container { height: 180px; }
            .carousel-slide .slide-content h2 { font-size: 16px; }
            .carousel-slide .slide-content p { display: none; }
        }
    </style>
</head>
<body>

<!-- ===== 顶部导航 ===== -->
<div class="header">
    <div class="logo">🛒 二手<span>交易</span>平台</div>

    <div class="search-box">
        <input type="text" id="searchKeyword" placeholder="搜索商品..." value="${keyword}" onkeydown="if(event.keyCode==13) search()">
        <select id="categorySelect" onchange="search()">
            <option value="">全部分类</option>
            <c:forEach items="${categories}" var="c">
                <option value="${c.id}" ${c.id == categoryId ? 'selected' : ''}>${c.name}</option>
            </c:forEach>
        </select>
        <button class="layui-btn layui-btn-sm" onclick="search()">搜索</button>
        <c:if test="${not empty keyword or not empty categoryId}">
            <a href="${pageContext.request.contextPath}/" class="layui-btn layui-btn-sm layui-btn-primary">清除</a>
        </c:if>
    </div>

    <div class="user-info">
        <c:if test="${empty sessionScope.loginUser}">
            <a href="${pageContext.request.contextPath}/user/toLogin" class="layui-btn layui-btn-sm">登录</a>
            <a href="${pageContext.request.contextPath}/user/toRegister" class="layui-btn layui-btn-sm layui-btn-normal">注册</a>
        </c:if>
        <c:if test="${not empty sessionScope.loginUser}">
            <span>欢迎，<b>${sessionScope.loginUser.username}</b>
                <c:if test="${sessionScope.loginUser.role == 1}">
                    <span class="admin-tag">管理员</span>
                </c:if>
            </span>
            <c:if test="${sessionScope.loginUser.role == 1}">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="layui-btn layui-btn-sm layui-btn-danger">管理后台</a>
            </c:if>
            <c:if test="${sessionScope.loginUser.role == 0}">
                <a href="${pageContext.request.contextPath}/user/profile" class="layui-btn layui-btn-sm layui-btn-primary">个人中心</a>
                <a href="${pageContext.request.contextPath}/cart/list" class="layui-btn layui-btn-sm layui-btn-normal">🛒 购物车</a>
                <a href="${pageContext.request.contextPath}/product/toAdd" class="layui-btn layui-btn-sm layui-btn-normal">发布商品</a>
                <a href="${pageContext.request.contextPath}/product/myList" class="layui-btn layui-btn-sm layui-btn-primary">我的发布</a>
                <a href="${pageContext.request.contextPath}/order/myOrders" class="layui-btn layui-btn-sm layui-btn-normal">我的订单</a>
                <a href="${pageContext.request.contextPath}/order/sellerOrders" class="layui-btn layui-btn-sm layui-btn-warm">卖家订单</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/user/logout" class="layui-btn layui-btn-sm layui-btn-danger">退出</a>
        </c:if>
    </div>
</div>

<!-- ===== 轮播图 ===== -->
<div class="carousel-wrapper">
    <div class="carousel-container" id="carousel">
        <div class="carousel-slides" id="carouselSlides">
            <c:forEach items="${carouselNotices}" var="notice" varStatus="status">
                <div class="carousel-slide" style="background: linear-gradient(135deg, ${['#1a1a2e', '#16213e', '#0f3460', '#1a1a2e', '#2d3436'][status.index % 5]}, ${['#16213e', '#0f3460', '#1a1a2e', '#2d3436', '#1a1a2e'][status.index % 5]});">
                    <div class="overlay"></div>
                    <div class="slide-content">
                        <span class="badge ${notice.type == 'hot' ? 'hot' : notice.type == 'promotion' ? 'promotion' : 'info'}">
                                ${notice.type == 'hot' ? '🔥 热卖' : notice.type == 'promotion' ? '🎉 促销' : '📢 公告'}
                        </span>
                        <h2>${notice.title}</h2>
                        <p>${notice.content.length() > 80 ? notice.content.substring(0, 80).concat('...') : notice.content}</p>
                        <a href="${pageContext.request.contextPath}/notice/detail?id=${notice.id}" class="btn-link">查看详情 →</a>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty carouselNotices}">
                <div class="carousel-slide" style="background: linear-gradient(135deg, #1a1a2e, #16213e);">
                    <div class="overlay"></div>
                    <div class="slide-content">
                        <span class="badge info">📢 欢迎</span>
                        <h2>欢迎来到二手交易平台</h2>
                        <p>发布闲置物品，淘到心仪好物，让资源循环利用！</p>
                        <a href="${pageContext.request.contextPath}/product/toAdd" class="btn-link">立即发布 →</a>
                    </div>
                </div>
            </c:if>
        </div>

        <c:if test="${not empty carouselNotices and carouselNotices.size() > 1}">
            <button class="carousel-arrow prev" onclick="changeSlide(-1)">‹</button>
            <button class="carousel-arrow next" onclick="changeSlide(1)">›</button>
            <div class="carousel-indicators" id="carouselIndicators">
                <c:forEach items="${carouselNotices}" var="notice" varStatus="status">
                    <span class="dot ${status.index == 0 ? 'active' : ''}" onclick="goToSlide(${status.index})"></span>
                </c:forEach>
            </div>
        </c:if>
    </div>
</div>

<!-- ===== 功能按钮区 ===== -->
<div class="feature-section">
    <div class="feature-grid">
        <a href="${pageContext.request.contextPath}/?categoryId=" class="feature-card" onclick="event.preventDefault(); showCategoryModal();">
            <span class="icon">📂</span>
            <span class="name">分类</span>
            <span class="desc">按分类浏览商品</span>
        </a>
        <a href="${pageContext.request.contextPath}/notice/list" class="feature-card">
            <span class="icon">📢</span>
            <span class="name">公告</span>
            <span class="desc">查看平台公告</span>
        </a>
        <a href="${pageContext.request.contextPath}/rank" class="feature-card">
            <span class="icon">🏆</span>
            <span class="name">浏览排行榜</span>
            <span class="desc">最受欢迎的商品</span>
        </a>
        <a href="${pageContext.request.contextPath}/product/toAdd" class="feature-card">
            <span class="icon">📤</span>
            <span class="name">发布商品</span>
            <span class="desc">发布您的闲置物品</span>
        </a>
    </div>
</div>

<!-- ===== 商品列表 ===== -->
<div class="container">
    <div class="section-header">
        <h3>🆕 最新发布</h3>
        <span class="count">共 ${pageInfo.total} 件商品</span>
    </div>

    <div class="product-grid">
        <c:forEach items="${pageInfo.list}" var="p">
            <div class="product-card">
                <a href="${pageContext.request.contextPath}/product/detail?id=${p.id}">
                    <c:if test="${not empty p.image}">
                        <img src="${pageContext.request.contextPath}${p.image}" alt="${p.title}">
                    </c:if>
                    <c:if test="${empty p.image}">
                        <img src="${pageContext.request.contextPath}/lib/layui/images/face/0.gif" alt="暂无图片">
                    </c:if>
                    <div class="info">
                        <div class="title">${p.title}</div>
                        <div class="price">¥${p.price}</div>
                        <div class="meta">
                            <span>👀 ${p.viewCount}</span>
                            <span><fmt:formatDate value="${p.createTime}" pattern="yyyy年MM月dd日 HH:mm:ss"/></span>
                        </div>
                    </div>
                </a>
            </div>
        </c:forEach>
        <c:if test="${empty pageInfo.list}">
            <div class="empty-tip" style="grid-column: 1 / -1;">
                <c:if test="${not empty keyword}">
                    🔍 没有找到与 "<b>${keyword}</b>" 相关的商品，<a href="${pageContext.request.contextPath}/">查看全部</a>
                </c:if>
                <c:if test="${empty keyword}">
                    😅 还没有商品，<a href="${pageContext.request.contextPath}/product/toAdd">快来发布吧！</a>
                </c:if>
            </div>
        </c:if>
    </div>

    <c:if test="${pageInfo.pages > 1}">
        <div class="pagination-box">
            <c:if test="${pageInfo.pageNum > 1}">
                <a href="?pageNum=1<c:if test="${not empty keyword}">&keyword=${keyword}</c:if><c:if test="${not empty categoryId}">&categoryId=${categoryId}</c:if>" class="layui-btn layui-btn-sm">首页</a>
                <a href="?pageNum=${pageInfo.pageNum - 1}<c:if test="${not empty keyword}">&keyword=${keyword}</c:if><c:if test="${not empty categoryId}">&categoryId=${categoryId}</c:if>" class="layui-btn layui-btn-sm">上一页</a>
            </c:if>
            <span style="margin: 0 10px;">${pageInfo.pageNum} / ${pageInfo.pages}</span>
            <c:if test="${pageInfo.pageNum < pageInfo.pages}">
                <a href="?pageNum=${pageInfo.pageNum + 1}<c:if test="${not empty keyword}">&keyword=${keyword}</c:if><c:if test="${not empty categoryId}">&categoryId=${categoryId}</c:if>" class="layui-btn layui-btn-sm">下一页</a>
                <a href="?pageNum=${pageInfo.pages}<c:if test="${not empty keyword}">&keyword=${keyword}</c:if><c:if test="${not empty categoryId}">&categoryId=${categoryId}</c:if>" class="layui-btn layui-btn-sm">末页</a>
            </c:if>
        </div>
    </c:if>
</div>

<script src="${pageContext.request.contextPath}/lib/layui/layui.js"></script>
<script>
    var currentSlide = 0;
    var totalSlides = ${not empty carouselNotices ? carouselNotices.size() : 1};

    function goToSlide(index) {
        if (totalSlides <= 1) return;
        if (index < 0) index = totalSlides - 1;
        if (index >= totalSlides) index = 0;
        currentSlide = index;
        var slides = document.getElementById('carouselSlides');
        slides.style.transform = 'translateX(-' + (currentSlide * 100) + '%)';
        var dots = document.querySelectorAll('.carousel-indicators .dot');
        dots.forEach(function(dot, i) {
            dot.classList.toggle('active', i === currentSlide);
        });
    }

    function changeSlide(direction) {
        goToSlide(currentSlide + direction);
    }

    var autoPlayInterval = setInterval(function() {
        if (totalSlides > 1) {
            changeSlide(1);
        }
    }, 5000);

    var carousel = document.getElementById('carousel');
    carousel.addEventListener('mouseenter', function() {
        clearInterval(autoPlayInterval);
    });
    carousel.addEventListener('mouseleave', function() {
        autoPlayInterval = setInterval(function() {
            if (totalSlides > 1) {
                changeSlide(1);
            }
        }, 5000);
    });

    function search() {
        var keyword = document.getElementById('searchKeyword').value.trim();
        var categoryId = document.getElementById('categorySelect').value;
        var url = '${pageContext.request.contextPath}/?';
        var params = [];
        if (keyword) params.push('keyword=' + encodeURIComponent(keyword));
        if (categoryId) params.push('categoryId=' + categoryId);
        if (params.length > 0) {
            window.location.href = url + params.join('&');
        } else {
            window.location.href = '${pageContext.request.contextPath}/';
        }
    }

    function showCategoryModal() {
        layui.use(['layer'], function() {
            var layer = layui.layer;
            var categories = [];
            <c:forEach items="${categories}" var="c">
            categories.push({ id: ${c.id}, name: '${c.name}' });
            </c:forEach>

            var html = '<div style="padding:20px;display:flex;flex-wrap:wrap;gap:12px;justify-content:center;">';
            html += '<a href="${pageContext.request.contextPath}/" style="padding:10px 25px;border:2px solid #1E9FFF;border-radius:25px;color:#1E9FFF;text-decoration:none;font-weight:bold;">全部</a>';
            for (var i = 0; i < categories.length; i++) {
                html += '<a href="${pageContext.request.contextPath}/?categoryId=' + categories[i].id + '" style="padding:10px 25px;border:1px solid #e6e6e6;border-radius:25px;color:#333;text-decoration:none;transition:all 0.3s;" onmouseover="this.style.borderColor=\'#1E9FFF\';this.style.color=\'#1E9FFF\'" onmouseout="this.style.borderColor=\'#e6e6e6\';this.style.color=\'#333\'">' + categories[i].name + '</a>';
            }
            html += '</div>';

            layer.open({
                type: 1,
                title: '📂 所有分类',
                area: ['600px', 'auto'],
                content: html,
                shadeClose: true
            });
        });
    }
</script>

</body>
</html>