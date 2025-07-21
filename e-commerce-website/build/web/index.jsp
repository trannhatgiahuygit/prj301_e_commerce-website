<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.*" %>
<%@ page import="dao.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BaloShop - Cửa hàng balo chất lượng cao</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div style="background: #f8d7da; color: #721c24; padding: 15px; margin: 20px; border-radius: 4px; border: 1px solid #f5c6cb;">
                <%=error%>
            </div>
        <%
            }
        %>
    <%@ include file="includes/header.jsp" %>
    
    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <h2>Chào mừng đến với BaloShop</h2>
            <p>Khám phá bộ sưu tập balo chất lượng cao, thiết kế hiện đại</p>
            <a href="<%=request.getContextPath()%>/product" class="btn btn-primary">Xem sản phẩm</a>
        </div>
    </section>
    
    <!-- Features Section -->
    <section class="features">
        <div class="container">
            <div class="features-grid">
                <div class="feature-item">
                    <div class="feature-icon">🎒</div>
                    <h3 class="feature-title">Sản phẩm chất lượng</h3>
                    <p>Balo được làm từ chất liệu cao cấp, bền bỉ theo thời gian</p>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">🚚</div>
                    <h3 class="feature-title">Giao hàng nhanh</h3>
                    <p>Giao hàng tận nơi trong 24-48h, miễn phí với đơn hàng trên 500k</p>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">💝</div>
                    <h3 class="feature-title">Ưu đãi hấp dẫn</h3>
                    <p>Nhiều chương trình khuyến mãi và ưu đãi đặc biệt</p>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Featured Products -->
    <section class="main-content">
        <div class="container">
            <h2 style="text-align: center; margin-bottom: 2rem;">Sản phẩm nổi bật</h2>
            
            <%
                List<Product> featuredProducts = null;
                try {
                    ProductDAO productDAO = new ProductDAO();
                    featuredProducts = productDAO.getAllProducts();
                    // Giới hạn 3 sản phẩm nổi bật
                    if (featuredProducts != null && featuredProducts.size() > 3) {
                        featuredProducts = featuredProducts.subList(0, 3);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    featuredProducts = new ArrayList<Product>();
                }
            %>
            
            <div class="product-grid">
                <%
                    if (featuredProducts != null && !featuredProducts.isEmpty()) {
                        for (Product product : featuredProducts) {
                            String description = product.getDescription();
                            // Rút gọn mô tả nếu quá dài
                            if (description != null && description.length() > 100) {
                                description = description.substring(0, 100) + "...";
                            }
                            if (description == null) {
                                description = "";
                            }
                %>
                    <div class="product-card">
                        <img src="<%=request.getContextPath()%>/images/<%=product.getImage()%>" 
                             alt="<%=product.getName()%>" 
                             class="product-image" 
                             onerror="this.src='<%=request.getContextPath()%>/images/default-balo.jpg'">
                        <div class="product-info">
                            <h3 class="product-name"><%=product.getName()%></h3>
                            <div class="product-price"><%=String.format("%,.0f", product.getPrice())%>₫</div>
                            <p class="product-description"><%=description%></p>
                            <a href="<%=request.getContextPath()%>/product?action=detail&id=<%=product.getProductId()%>" 
                               class="btn btn-primary">Xem chi tiết</a>
                        </div>
                    </div>
                <%
                        }
                    } else {
                %>
                    <div style="text-align: center; padding: 2rem; grid-column: 1 / -1;">
                        <h3>Chưa có sản phẩm nào</h3>
                        <p>Vui lòng quay lại sau để xem các sản phẩm mới.</p>
                    </div>
                <%
                    }
                %>
            </div>
            
            <%
                if (featuredProducts != null && !featuredProducts.isEmpty()) {
            %>
                <div style="text-align: center; margin-top: 2rem;">
                    <a href="<%=request.getContextPath()%>/product" class="btn btn-primary">Xem tất cả sản phẩm</a>
                </div>
            <%
                }
            %>
        </div>
    </section>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>