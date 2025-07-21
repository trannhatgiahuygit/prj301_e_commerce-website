<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="model.*" %>
<%@ page import="util.AuthUtils" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=request.getAttribute("pageTitle")%> - Admin</title>
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
            max-width: 800px;
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
        
        .card {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        
        .form-group textarea {
            resize: vertical;
            height: 100px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .btn {
            background: #007bff;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
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
        
        .btn-secondary {
            background: #6c757d;
        }
        
        .btn-secondary:hover {
            background: #545b62;
        }
        
        .preview-img {
            max-width: 200px;
            max-height: 200px;
            object-fit: cover;
            border-radius: 4px;
            margin-top: 10px;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .required {
            color: red;
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
        <h1><%=request.getAttribute("pageTitle")%></h1>
        <a href="admin-product">← Quay lại danh sách</a>
    </div>

    <div class="container">
        <%
            String errorMessage = (String)request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
            <div class="alert alert-error"><%=errorMessage%></div>
        <%
            }
        %>

        <div class="card">
            <h2><%=request.getAttribute("formTitle")%></h2>
            
            <form action="admin-product" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="<%=request.getAttribute("formAction")%>">
                <%
                    Product product = (Product)request.getAttribute("product");
                    if (product != null) {
                %>
                    <input type="hidden" name="productId" value="<%=product.getProductId()%>">
                <%
                    }
                %>
                
                <div class="form-group">
                    <label>Tên sản phẩm <span class="required">*</span></label>
                    <input type="text" name="name" value="<%=product != null ? product.getName() : ""%>" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Giá <span class="required">*</span></label>
                        <input type="number" name="price" value="<%=product != null ? String.valueOf((long)product.getPrice()) : ""%>" min="0" step="1000" required>
                    </div>
                    <div class="form-group">
                        <label>Số lượng <span class="required">*</span></label>
                        <input type="number" name="stock" value="<%=product != null ? product.getStock() : ""%>" min="0" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Thương hiệu <span class="required">*</span></label>
                    <input type="text" name="brand" value="<%=product != null ? product.getBrand() : ""%>" required>
                </div>

                <div class="form-group">
                    <label>Danh mục <span class="required">*</span></label>
                    <select name="category" required>
                        <option value="">-- Chọn danh mục --</option>
                        <option value="Balo học sinh" <%=product != null && "Balo học sinh".equals(product.getCategory()) ? "selected" : ""%>>Balo học sinh</option>
                        <option value="Balo laptop" <%=product != null && "Balo laptop".equals(product.getCategory()) ? "selected" : ""%>>Balo laptop</option>
                        <option value="Balo du lịch" <%=product != null && "Balo du lịch".equals(product.getCategory()) ? "selected" : ""%>>Balo du lịch</option>
                        <option value="Balo thể thao" <%=product != null && "Balo thể thao".equals(product.getCategory()) ? "selected" : ""%>>Balo thể thao</option>
                    </select>
                </div>

                <%
                    if (product != null && product.getImage() != null && !product.getImage().isEmpty()) {
                %>
                    <div class="form-group">
                        <label>Hình ảnh hiện tại</label>
                        <img src="<%=request.getContextPath()%>/images/<%=product.getImage()%>" 
                             alt="<%=product.getName()%>" 
                             class="preview-img"
                             onerror="this.src='<%=request.getContextPath()%>/images/default-balo.jpg'">
                    </div>
                <%
                    }
                %>

                <div class="form-group">
                    <label><%=product != null ? "Đổi hình ảnh (để trống nếu không đổi)" : "Hình ảnh"%></label>
                    <input type="file" name="image" accept="image/*" <%=product == null ? "required" : ""%>>
                </div>

                <div class="form-group">
                    <label>Mô tả</label>
                    <textarea name="description" placeholder="Nhập mô tả sản phẩm..."><%=product != null && product.getDescription() != null ? product.getDescription() : ""%></textarea>
                </div>

                <div style="text-align: right; margin-top: 30px;">
                    <a href="admin-product" class="btn btn-secondary">Hủy</a>
                    <button type="submit" class="btn btn-success"><%=product != null ? "Cập nhật" : "Thêm mới"%></button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>