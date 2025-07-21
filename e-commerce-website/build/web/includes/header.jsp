<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>

<!-- FontAwesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<!-- CSS Profile Form ĐẸP -->
<style>
    #profileForm {
        display: none;
        position: absolute;
        right: 20px;
        top: 80px;
        background: #ffffff;
        border: 1px solid #ddd;
        border-radius: 10px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        padding: 20px;
        width: 320px;
        z-index: 999;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    #profileForm h3 {
        margin: 0 0 15px 0;
        font-size: 20px;
        text-align: center;
        color: #333;
    }
    #profileForm label {
        display: block;
        font-weight: 600;
        margin: 8px 0 4px;
        font-size: 14px;
        color: #555;
    }
    #profileForm input {
        width: 100%;
        padding: 8px 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 14px;
        background: #f9f9f9;
    }
    #profileForm input:read-only {
        background: #f1f1f1;
    }
    #profileForm .btn-group {
        display: flex;
        justify-content: space-between;
        margin-top: 15px;
    }
    #profileForm .btn-group button {
        flex: 1;
        text-align: center;
        padding: 10px 12px;
        margin: 0 5px;
        border: none;
        border-radius: 5px;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.2s ease;
    }
    #profileForm .btn-close {
        background: #555;
        color: #fff;
    }
    #profileForm .btn-close:hover {
        background: #333;
    }
    #profileForm .btn-delete {
        background: #e74c3c;
        color: #fff;
    }
    #profileForm .btn-delete:hover {
        background: #c0392b;
    }
    #profileForm .message {
        display: block;
        margin-top: 10px;
        color: red;
        font-weight: bold;
        text-align: center;
    }
</style>

<%
    User headerUser = (User) session.getAttribute("user");
    String currentCategory = request.getParameter("category");
    String contextPath = request.getContextPath();
%>

<header class="header">
    <div class="container">
        <div class="header-content">
            <div class="logo">
                <h1><a href="<%=contextPath%>/index.jsp" style="color: white; text-decoration: none;">BaloShop</a></h1>
            </div>

            <nav class="nav">
                <ul>
                    <li><a href="<%=contextPath%>/index.jsp">Trang chủ</a></li>
                    <li><a href="<%=contextPath%>/product">Sản phẩm</a></li>
                    <%
                        if (headerUser != null) {
                    %>
                        <li><a href="<%=contextPath%>/cart">Giỏ hàng</a></li>
                        <li><a href="<%=contextPath%>/order">Đơn hàng</a></li>
                    <%
                        }
                    %>
                </ul>
            </nav>

            <div class="user-info">
                <%
                    if (headerUser != null) {
                %>
                    <span>Xin chào, <%=headerUser.getFullName()%>!</span>
                    <a href="#" id="profileIcon" style="margin-left: 10px; color: white;">
                        <i class="fas fa-user-circle fa-2x"></i>
                    </a>
                    <%
                        if ("admin".equals(headerUser.getRole())) {
                    %>
                        <a href="<%=contextPath%>/admin-product" class="btn">Admin</a>
                    <%
                        }
                    %>
                    <a href="<%=contextPath%>/user?action=logout" class="btn btn-warning">Đăng xuất</a>
                <%
                    } else {
                %>
                    <a href="<%=contextPath%>/user?action=login" class="btn">Đăng nhập</a>
                    <a href="<%=contextPath%>/user?action=register" class="btn btn-primary">Đăng ký</a>
                <%
                    }
                %>
            </div>
        </div>
    </div>
</header>

<!-- Search Bar -->
<div class="search-bar">
    <div class="container">
        <form action="<%=contextPath%>/product" method="get" class="search-form">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" class="search-input" 
                   placeholder="Tìm kiếm balo..." value="<%=request.getParameter("keyword") != null ? request.getParameter("keyword") : ""%>">
            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
        </form>
    </div>
</div>

<!-- Categories -->
<div class="categories">
    <div class="container">
        <div class="category-list">
            <a href="<%=contextPath%>/product" 
               class="category-link <%=currentCategory == null ? "active" : ""%>">Tất cả</a>
            
            <a href="<%=contextPath%>/product?action=category&category=Balo laptop" 
               class="category-link <%="Balo laptop".equals(currentCategory) ? "active" : ""%>">Balo laptop</a>
            
            <a href="<%=contextPath%>/product?action=category&category=Balo học sinh" 
               class="category-link <%="Balo học sinh".equals(currentCategory) ? "active" : ""%>">Balo học sinh</a>
            
            <a href="<%=contextPath%>/product?action=category&category=Balo du lịch" 
               class="category-link <%="Balo du lịch".equals(currentCategory) ? "active" : ""%>">Balo du lịch</a>
            
            
            <a href="<%=contextPath%>/product?action=category&category=Balo thể thao" 
               class="category-link <%="Balo thể thao".equals(currentCategory) ? "active" : ""%>">Balo thể thao</a>
        </div>
    </div>
</div>

<!-- Profile Form -->
<%
    if (headerUser != null) {
        String message = (String) request.getAttribute("MESSAGE");
%>
    <div id="profileForm">
        <h3>Thông tin tài khoản</h3>
        <form method="get" action="<%=contextPath%>/user" onsubmit="return confirm('Bạn có chắc chắn muốn xóa tài khoản không?');">
            <label>Email:</label>
            <input type="text" value="<%=headerUser.getEmail() != null ? headerUser.getEmail() : ""%>" readonly>

            <label>Họ tên:</label>
            <input type="text" value="<%=headerUser.getFullName() != null ? headerUser.getFullName() : ""%>" readonly>

            <label>SĐT:</label>
            <input type="text" value="<%=headerUser.getPhone() != null ? headerUser.getPhone() : ""%>" readonly>

            <label>Địa chỉ:</label>
            <input type="text" value="<%=headerUser.getAddress() != null ? headerUser.getAddress() : ""%>" readonly>

            <label>Role:</label>
            <input type="text" value="<%=headerUser.getRole() != null ? headerUser.getRole() : ""%>" readonly>

            <!-- Hidden input cho action & id -->
            <input type="hidden" name="action" value="deleteAccount">
            <input type="hidden" name="id" value="<%=headerUser.getUserId()%>">

            <div class="btn-group">
                <button type="button" class="btn-close" onclick="document.getElementById('profileForm').style.display = 'none'">Đóng</button>
                <button type="submit" class="btn-delete">Xóa tài khoản</button>
            </div>
            <%
                if (message != null && !message.isEmpty()) {
            %>
                <span class="message"><%=message%></span>
            <%
                }
            %>
        </form>
    </div>

    <script>
        document.getElementById('profileIcon').addEventListener('click', function (event) {
            event.preventDefault();
            var form = document.getElementById('profileForm');
            if (form.style.display === 'none') {
                form.style.display = 'block';
            } else {
                form.style.display = 'none';
            }
        });
    </script>
<%
    }
%>