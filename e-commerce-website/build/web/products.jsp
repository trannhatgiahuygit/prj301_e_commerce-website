<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sản phẩm - BaloShop</title>
        <link rel="stylesheet" href="css/style.css">
        <style>
            .product-card {
                width: 300px;
                border: 1px solid #ddd;
                border-radius: 8px;
                overflow: hidden;
                background: #fff;
                margin-bottom: 20px;
            }

            .product-image {
                width: 100%;
                height: 300px;
                object-fit: cover;
                display: block;
            }
            
            .product-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 20px;
                margin-top: 20px;
            }
        </style>
    </head>
    <body>
        <%@ include file="includes/header.jsp" %>

        <div class="main-content">
            <div class="container">
                <%
                    String categoryParam = (String) request.getAttribute("currentCategory");
                    String keywordParam = (String) request.getAttribute("searchKeyword");
                    List<Product> productList = (List<Product>) request.getAttribute("products");
                %>
                
                <h2 style="margin-bottom: 2rem;">
                    <%
                        if (categoryParam != null && !categoryParam.isEmpty()) {
                            out.print("Danh mục: " + categoryParam);
                        } else if (keywordParam != null && !keywordParam.isEmpty()) {
                            out.print("Kết quả tìm kiếm: \"" + keywordParam + "\"");
                        } else {
                            out.print("Tất cả sản phẩm");
                        }
                    %>
                </h2>

                <%
                    if (productList == null || productList.isEmpty()) {
                %>
                    <div style="text-align: center; padding: 3rem;">
                        <h3>Không tìm thấy sản phẩm nào</h3>
                        <p>Vui lòng thử tìm kiếm với từ khóa khác hoặc xem tất cả sản phẩm.</p>
                        <a href="product" class="btn btn-primary">Xem tất cả sản phẩm</a>
                    </div>
                <%
                    } else {
                %>
                    <div class="product-grid">
                        <%
                            for (Product prod : productList) {
                                String productDesc = prod.getDescription();
                                if (productDesc != null && productDesc.length() > 100) {
                                    productDesc = productDesc.substring(0, 100) + "...";
                                }
                                if (productDesc == null) {
                                    productDesc = "";
                                }
                                
                                User currentUser = (User) session.getAttribute("user");
                        %>
                            <div class="product-card">
                                <img src="<%=request.getContextPath()%>/images/<%=prod.getImage()%>" 
                                     alt="<%=prod.getName()%>"
                                     class="product-image" loading="lazy"
                                     onerror="this.src='<%=request.getContextPath()%>/images/default-balo.jpg'">

                                <div class="product-info">
                                    <h3 class="product-name"><%=prod.getName()%></h3>
                                    <div class="product-price">
                                        <%=String.format("%,.0f", prod.getPrice())%>₫
                                    </div>
                                    <p class="product-description"><%=productDesc%></p>
                                    
                                    <div style="display: flex; gap: 0.5rem; margin-top: 1rem;">
                                        <a href="product?action=detail&id=<%=prod.getProductId()%>" 
                                           class="btn btn-primary" style="flex: 1; text-align: center;">
                                            Xem chi tiết
                                        </a>
                                        <%
                                            if (currentUser != null && prod.getStock() > 0) {
                                        %>
                                            <form action="cart" method="post" style="flex: 1;">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="productId" value="<%=prod.getProductId()%>">
                                                <input type="hidden" name="quantity" value="1">
                                                <button type="submit" class="btn" style="width: 100%;">
                                                    Thêm vào giỏ
                                                </button>
                                            </form>
                                        <%
                                            }
                                        %>
                                    </div>
                                    
                                    <div style="margin-top: 0.5rem; text-align: center;">
                                        <%
                                            if (prod.getStock() > 0) {
                                        %>
                                            <span style="color: #28a745; font-size: 0.9rem;">
                                                Còn <%=prod.getStock()%> sản phẩm
                                            </span>
                                        <%
                                            } else {
                                        %>
                                            <span style="color: #dc3545; font-size: 0.9rem;">
                                                Hết hàng
                                            </span>
                                        <%
                                            }
                                        %>
                                    </div>
                                </div>
                            </div>
                        <%
                            }
                        %>
                    </div>
                <%
                    }
                %>
            </div>
        </div>

        <%@ include file="includes/footer.jsp" %>
    </body>
</html>