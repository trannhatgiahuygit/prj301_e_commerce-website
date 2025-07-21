<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - BaloShop</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-content">
        <div class="container">
            <h2 style="margin-bottom: 2rem;">Giỏ hàng của bạn</h2>
            
            <%
                List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
                Double totalAmount = (Double) request.getAttribute("totalAmount");
                
                if (cartItems == null || cartItems.isEmpty()) {
            %>
                <div style="text-align: center; padding: 3rem; background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                    <h3>Giỏ hàng trống</h3>
                    <p style="margin: 1rem 0;">Hãy thêm sản phẩm vào giỏ hàng để tiếp tục mua sắm.</p>
                    <a href="<%=request.getContextPath()%>/product" class="btn btn-primary">Tiếp tục mua sắm</a>
                </div>
            <%
                } else {
            %>
                <form action="<%=request.getContextPath()%>/cart" method="post">
                    <input type="hidden" name="action" value="update">
                    
                    <table class="cart-table">
                        <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Đơn giá</th>
                                <th>Số lượng</th>
                                <th>Thành tiền</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (CartItem item : cartItems) {
                                    Product product = item.getProduct();
                            %>
                                <tr>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 1rem;">
                                            <img src="<%=request.getContextPath()%>/images/<%=product.getImage()%>" 
                                                 alt="<%=product.getName()%>" 
                                                 class="cart-item-image" 
                                                 onerror="this.src='<%=request.getContextPath()%>/images/default-balo.jpg'">
                                            <div>
                                                <h4><%=product.getName()%></h4>
                                                <a href="<%=request.getContextPath()%>/product?action=detail&id=<%=item.getProductId()%>" 
                                                   style="color: #667eea; text-decoration: none; font-size: 0.9rem;">
                                                    Xem chi tiết
                                                </a>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <%=String.format("%,.0f", product.getPrice())%>₫
                                    </td>
                                    <td>
                                        <input type="hidden" name="cartItemId" value="<%=item.getCartItemId()%>">
                                        <input type="number" name="quantity" value="<%=item.getQuantity()%>" 
                                               min="1" class="quantity-input">
                                    </td>
                                    <td style="font-weight: bold; color: #e74c3c;">
                                        <%=String.format("%,.0f", item.getTotalPrice())%>₫
                                    </td>
                                    <td>
                                        <a href="<%=request.getContextPath()%>/cart?action=remove&cartItemId=<%=item.getCartItemId()%>" 
                                           class="btn btn-danger"
                                           onclick="return confirm('Bạn có muốn xóa sản phẩm này khỏi giỏ hàng?')">
                                            Xóa
                                        </a>
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                    
                    <div style="display: flex; justify-content: space-between; align-items: center; margin: 2rem 0;">
                        <button type="submit" class="btn btn-warning">Cập nhật giỏ hàng</button>
                        <a href="<%=request.getContextPath()%>/product" class="btn">Tiếp tục mua sắm</a>
                    </div>
                </form>
                
                <div class="cart-total">
                    <h3>Tổng cộng</h3>
                    <div class="total-amount">
                        <%=String.format("%,.0f", totalAmount != null ? totalAmount : 0)%>₫
                    </div>
                    <div style="margin-top: 1rem;">
                        <a href="<%=request.getContextPath()%>/order?action=checkout" class="btn btn-primary" style="padding: 1rem 2rem; font-size: 1.1rem;">
                            Tiến hành thanh toán
                        </a>
                    </div>
                </div>
            <%
                }
            %>
        </div>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
    
    <script>
        // Auto-submit on quantity change
        document.querySelectorAll('.quantity-input').forEach(input => {
            input.addEventListener('change', function() {
                if (this.value < 1) {
                    this.value = 1;
                }
            });
        });
    </script>
</body>
</html>