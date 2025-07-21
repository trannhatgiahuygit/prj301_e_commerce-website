<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.*" %>
<%@ page import="dao.*" %>
<%@ page import="util.AuthUtils" %>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Quản lý sản phẩm</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            background: #333;
            color: white;
            padding: 15px 20px;
            margin-bottom: 20px;
        }
        
        .header h1 {
            display: inline-block;
            margin-right: 20px;
        }
        
        .header a {
            color: white;
            text-decoration: none;
            margin-left: 15px;
            padding: 8px 12px;
            border-radius: 4px;
            background: rgba(255,255,255,0.2);
        }
        
        .header a:hover {
            background: rgba(255,255,255,0.3);
        }
        
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border-left: 4px solid #007bff;
        }
        
        .stat-card h3 {
            font-size: 24px;
            margin-bottom: 5px;
        }
        
        .stat-card p {
            color: #666;
            font-size: 14px;
        }
        
        .actions {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .btn {
            background: #007bff;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
            cursor: pointer;
        }
        
        .btn:hover {
            background: #0056b3;
        }
        
        .btn-success {
            background: #28a745;
        }
        
        .btn-success:hover {
            background: #1e7e34;
        }
        
        .btn-danger {
            background: #dc3545;
        }
        
        .btn-danger:hover {
            background: #c82333;
        }
        
        .btn-warning {
            background: #ffc107;
            color: #000;
        }
        
        .btn-warning:hover {
            background: #e0a800;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        table {
            width: 100%;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border-collapse: collapse;
        }
        
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        th {
            background: #f8f9fa;
            font-weight: bold;
        }
        
        tr:hover {
            background: #f8f9fa;
        }
        
        .product-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 4px;
        }
        
        .stock-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .stock-in {
            background: #d4edda;
            color: #155724;
        }
        
        .stock-out {
            background: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    

    <%
        // Security check - only admin can access this page
        if (!AuthUtils.isLoggedIn(request)) {
            response.sendRedirect(AuthUtils.getLoginURL());
            return;
        }

        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("error", AuthUtils.getAccessDeniedMessage("trang quản trị sản phẩm"));
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }
    %>
    <div class="header">
        <h1>Admin - Quản lý sản phẩm</h1>
        <a href="<%=request.getContextPath()%>/admin-product">Sản phẩm</a>
        <a href="<%=request.getContextPath()%>/index.jsp">Trang chủ</a>
        <a href="<%=request.getContextPath()%>/user?action=logout">Đăng xuất</a>
    </div>

    <div class="container">
        <%
            try {
                ProductDAO dao = new ProductDAO();
                List<Product> products = dao.getAllProducts();
                int total = products.size();
                double avg = products.stream().mapToDouble(Product::getPrice).average().orElse(0);
                long inStock = products.stream().filter(p -> p.getStock() > 0).count();
                long outStock = total - inStock;
                request.setAttribute("allProducts", products);
                request.setAttribute("totalProducts", total);
                request.setAttribute("avgPrice", avg);
                request.setAttribute("inStock", inStock);
                request.setAttribute("outStock", outStock);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi khi tải dữ liệu: " + e.getMessage());
            }
        %>

        <!-- Thống kê -->
        <div class="stats">
            <div class="stat-card">
                <h3><%=request.getAttribute("totalProducts")%></h3>
                <p>Tổng sản phẩm</p>
            </div>
            <div class="stat-card">
                <h3><%=request.getAttribute("inStock")%></h3>
                <p>Còn hàng</p>
            </div>
            <div class="stat-card">
                <h3><%=request.getAttribute("outStock")%></h3>
                <p>Hết hàng</p>
            </div>
            <div class="stat-card">
                <h3><%=String.format("%.0f", (Double)request.getAttribute("avgPrice"))%>₫</h3>
                <p>Giá trung bình</p>
            </div>
        </div>

        <!-- Nút thêm -->
        <div class="actions">
            <a href="<%=request.getContextPath()%>/admin-product?action=add" class="btn btn-success">+ Thêm sản phẩm mới</a>
        </div>

        <!-- Thông báo -->
        <%
            String successMessage = (String)session.getAttribute("successMessage");
            String errorMessage = (String)session.getAttribute("errorMessage");
            String pageErrorMessage = (String)request.getAttribute("errorMessage");
            
            if (successMessage != null) {
        %>
            <div class="alert alert-success"><%=successMessage%></div>
        <%
                session.removeAttribute("successMessage");
            }
            
            if (errorMessage != null) {
        %>
            <div class="alert alert-error"><%=errorMessage%></div>
        <%
                session.removeAttribute("errorMessage");
            }
            
            if (pageErrorMessage != null) {
        %>
            <div class="alert alert-error"><%=pageErrorMessage%></div>
        <%
            }
        %>

        <!-- Bảng sản phẩm -->
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Hình ảnh</th>
                    <th>Tên sản phẩm</th>
                    <th>Giá</th>
                    <th>Kho</th>
                    <th>Danh mục</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Product> allProducts = (List<Product>)request.getAttribute("allProducts");
                    if (allProducts != null) {
                        for (Product product : allProducts) {
                            String productName = product.getName();
                            // Escape single quotes để tránh lỗi JavaScript
                            if (productName != null) {
                                productName = productName.replace("'", "\\'");
                            }
                %>
                    <tr>
                        <td><%=product.getProductId()%></td>
                        <td>
                            <img src="<%=request.getContextPath()%>/images/<%=product.getImage()%>" 
                                 alt="<%=product.getName()%>" 
                                 class="product-img"
                                 onerror="this.src='<%=request.getContextPath()%>/images/default-balo.jpg'">
                        </td>
                        <td><%=product.getName()%></td>
                        <td><%=String.format("%,.0f", product.getPrice())%>₫</td>
                        <td>
                            <span class="stock-badge <%=product.getStock() > 0 ? "stock-in" : "stock-out"%>">
                                <%=product.getStock()%>
                            </span>
                        </td>
                        <td><%=product.getCategory()%></td>
                        <td>
                            <a href="<%=request.getContextPath()%>/admin-product?action=edit&id=<%=product.getProductId()%>" class="btn btn-warning">Sửa</a>
                            <a href="javascript:void(0)" onclick="deleteProduct(<%=product.getProductId()%>, '<%=productName%>')" class="btn btn-danger">Xóa</a>
                        </td>
                    </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>

    <!-- Form xóa ẩn -->
    <form id="deleteForm" action="<%=request.getContextPath()%>/admin-product" method="post" style="display: none;">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="productId" id="deleteProductId">
    </form>

    <script>
        function deleteProduct(id, name) {
            if (confirm('Bạn có chắc muốn xóa sản phẩm "' + name + '" không?')) {
                document.getElementById('deleteProductId').value = id;
                document.getElementById('deleteForm').submit();
            }
        }
    </script>
</body>
</html>