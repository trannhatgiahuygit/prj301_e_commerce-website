<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="model.*" %>

<%
    Order order = (Order) request.getAttribute("order");
    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");
    User currentUser = (User) session.getAttribute("user");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    DecimalFormat moneyFormat = new DecimalFormat("#,###");
    
    if (order == null) {
        response.sendRedirect("order");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng #<%=order.getOrderId()%> - BaloShop</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-content">
        <div class="container">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                <h2>Chi tiết đơn hàng #<%=order.getOrderId()%></h2>
                <a href="order" class="btn">← Quay lại danh sách đơn hàng</a>
            </div>
            
            <!-- Order Info -->
            <div style="background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); padding: 2rem; margin-bottom: 2rem;">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2rem;">
                    <div>
                        <h3 style="margin-bottom: 1rem; color: #333;">Thông tin đơn hàng</h3>
                        <div style="color: #6c757d; line-height: 1.8;">
                            <div><strong>Mã đơn hàng:</strong> #<%=order.getOrderId()%></div>
                            <div><strong>Ngày đặt:</strong> <%=dateFormat.format(order.getOrderDate())%></div>
                            <div><strong>Trạng thái:</strong> 
                                <span class="order-status status-<%=order.getStatus()%>">
                                    <%
                                        String statusText = "";
                                        String status = order.getStatus();
                                        if ("pending".equals(status)) {
                                            statusText = "Chờ xử lý";
                                        } else if ("processing".equals(status)) {
                                            statusText = "Đang xử lý";
                                        } else if ("shipped".equals(status)) {
                                            statusText = "Đã giao";
                                        } else if ("delivered".equals(status)) {
                                            statusText = "Hoàn thành";
                                        } else if ("cancelled".equals(status)) {
                                            statusText = "Đã hủy";
                                        } else {
                                            statusText = status;
                                        }
                                    %>
                                    <%=statusText%>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <div>
                        <h3 style="margin-bottom: 1rem; color: #333;">Thông tin giao hàng</h3>
                        <div style="color: #6c757d; line-height: 1.8;">
                            <div><strong>Người nhận:</strong> <%=currentUser != null ? currentUser.getFullName() : ""%></div>
                            <div><strong>Số điện thoại:</strong> <%=currentUser != null ? currentUser.getPhone() : ""%></div>
                            <div><strong>Địa chỉ:</strong> <%=order.getShippingAddress()%></div>
                        </div>
                    </div>
                    
                    <div>
                        <h3 style="margin-bottom: 1rem; color: #333;">Thanh toán</h3>
                        <div style="color: #6c757d; line-height: 1.8;">
                            <div><strong>Phương thức:</strong> 
                                <%
                                    String paymentText = "";
                                    String paymentMethod = order.getPaymentMethod();
                                    if ("cod".equals(paymentMethod)) {
                                        paymentText = "Thanh toán khi nhận hàng";
                                    } else if ("bank".equals(paymentMethod)) {
                                        paymentText = "Chuyển khoản ngân hàng";
                                    } else if ("momo".equals(paymentMethod)) {
                                        paymentText = "Ví MoMo";
                                    } else if ("zalopay".equals(paymentMethod)) {
                                        paymentText = "ZaloPay";
                                    } else {
                                        paymentText = paymentMethod;
                                    }
                                %>
                                <%=paymentText%>
                            </div>
                            <div><strong>Tổng tiền:</strong> 
                                <span style="color: #e74c3c; font-weight: bold; font-size: 1.1rem;">
                                    <%=moneyFormat.format(order.getTotalAmount())%>₫
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Order Items -->
            <div style="background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); padding: 2rem;">
                <h3 style="margin-bottom: 1.5rem; color: #333;">Sản phẩm đã đặt</h3>
                
                <table class="cart-table">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Đơn giá</th>
                            <th>Số lượng</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (orderItems != null) {
                                for (OrderItem item : orderItems) {
                        %>
                            <tr>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 1rem;">
                                        <img src="<%=request.getContextPath()%>/images/<%=item.getProduct().getImage()%>" 
                                             alt="<%=item.getProduct().getName()%>" 
                                             class="cart-item-image" 
                                             onerror="this.src='<%=request.getContextPath()%>/images/default-balo.jpg'">
                                        <div>
                                            <h4><%=item.getProduct().getName()%></h4>
                                            <a href="product?action=detail&id=<%=item.getProductId()%>" 
                                               style="color: #667eea; text-decoration: none; font-size: 0.9rem;">
                                                Xem sản phẩm
                                            </a>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <%=moneyFormat.format(item.getPrice())%>₫
                                </td>
                                <td><%=item.getQuantity()%></td>
                                <td style="font-weight: bold; color: #e74c3c;">
                                    <%=moneyFormat.format(item.getTotalPrice())%>₫
                                </td>
                            </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
                
                <div style="text-align: right; margin-top: 2rem; padding-top: 1rem; border-top: 1px solid #dee2e6;">
                    <div style="font-size: 1.2rem; font-weight: bold;">
                        Tổng cộng: 
                        <span style="color: #e74c3c;">
                            <%=moneyFormat.format(order.getTotalAmount())%>₫
                        </span>
                    </div>
                </div>
            </div>
            
            <!-- Order Status Timeline -->
            <div style="background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); padding: 2rem; margin-top: 2rem;">
                <h3 style="margin-bottom: 1.5rem; color: #333;">Trạng thái đơn hàng</h3>
                
                <div style="position: relative;">
                    <div style="display: flex; justify-content: space-between; position: relative;">
                        <!-- Timeline line -->
                        <div style="position: absolute; top: 20px; left: 0; right: 0; height: 2px; background: #dee2e6; z-index: 1;"></div>
                        
                        <!-- Status points -->
                        <div style="display: flex; justify-content: space-between; width: 100%; position: relative; z-index: 2;">
                            <div style="text-align: center; background: white; padding: 0 1rem;">
                                <div style="width: 40px; height: 40px; border-radius: 50%; background: #28a745; margin: 0 auto 0.5rem; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold;">✓</div>
                                <div style="font-size: 0.9rem; color: #28a745; font-weight: 500;">Đặt hàng</div>
                            </div>
                            
                            <div style="text-align: center; background: white; padding: 0 1rem;">
                                <%
                                    String confirmBg = "pending".equals(order.getStatus()) ? "#ffc107" : "#28a745";
                                    String confirmIcon = "pending".equals(order.getStatus()) ? "⏳" : "✓";
                                    String confirmColor = "pending".equals(order.getStatus()) ? "#ffc107" : "#28a745";
                                %>
                                <div style="width: 40px; height: 40px; border-radius: 50%; background: <%=confirmBg%>; margin: 0 auto 0.5rem; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold;">
                                    <%=confirmIcon%>
                                </div>
                                <div style="font-size: 0.9rem; color: <%=confirmColor%>; font-weight: 500;">Xác nhận</div>
                            </div>
                            
                            <div style="text-align: center; background: white; padding: 0 1rem;">
                                <%
                                    boolean isShippedOrDelivered = "shipped".equals(order.getStatus()) || "delivered".equals(order.getStatus());
                                    String shippingBg = isShippedOrDelivered ? "#28a745" : "#dee2e6";
                                    String shippingIcon = isShippedOrDelivered ? "✓" : "📦";
                                    String shippingColor = isShippedOrDelivered ? "#28a745" : "#6c757d";
                                %>
                                <div style="width: 40px; height: 40px; border-radius: 50%; background: <%=shippingBg%>; margin: 0 auto 0.5rem; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold;">
                                    <%=shippingIcon%>
                                </div>
                                <div style="font-size: 0.9rem; color: <%=shippingColor%>; font-weight: 500;">Giao hàng</div>
                            </div>
                            
                            <div style="text-align: center; background: white; padding: 0 1rem;">
                                <%
                                    boolean isDelivered = "delivered".equals(order.getStatus());
                                    String deliveredBg = isDelivered ? "#28a745" : "#dee2e6";
                                    String deliveredIcon = isDelivered ? "✓" : "🏠";
                                    String deliveredColor = isDelivered ? "#28a745" : "#6c757d";
                                %>
                                <div style="width: 40px; height: 40px; border-radius: 50%; background: <%=deliveredBg%>; margin: 0 auto 0.5rem; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold;">
                                    <%=deliveredIcon%>
                                </div>
                                <div style="font-size: 0.9rem; color: <%=deliveredColor%>; font-weight: 500;">Hoàn thành</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
    
    <style>
        @media (max-width: 768px) {
            .container > div:nth-child(2) > div {
                grid-template-columns: 1fr !important;
            }
        }
    </style>
</body>
</html>