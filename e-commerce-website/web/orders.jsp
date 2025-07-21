<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="model.*" %>

<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    DecimalFormat moneyFormat = new DecimalFormat("#,###");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi - BaloShop</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-content">
        <div class="container">
            <h2 style="margin-bottom: 2rem;">Đơn hàng của tôi</h2>
            
            <%
                if (orders == null || orders.isEmpty()) {
            %>
                <div style="text-align: center; padding: 3rem; background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                    <h3>Bạn chưa có đơn hàng nào</h3>
                    <p style="margin: 1rem 0;">Hãy bắt đầu mua sắm ngay!</p>
                    <a href="product" class="btn btn-primary">Mua sắm ngay</a>
                </div>
            <%
                } else {
            %>
                <div style="display: grid; gap: 1.5rem;">
                    <%
                        for (Order order : orders) {
                            // Determine status text
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
                            
                            // Determine payment method text
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
                        <div style="background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); padding: 2rem;">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; border-bottom: 1px solid #dee2e6; padding-bottom: 1rem;">
                                <div>
                                    <h3 style="margin-bottom: 0.5rem;">Đơn hàng #<%=order.getOrderId()%></h3>
                                    <div style="color: #6c757d; font-size: 0.9rem;">
                                        Đặt ngày: <%=dateFormat.format(order.getOrderDate())%>
                                    </div>
                                </div>
                                <div style="text-align: right;">
                                    <div style="margin-bottom: 0.5rem;">
                                        <span class="order-status status-<%=order.getStatus()%>">
                                            <%=statusText%>
                                        </span>
                                    </div>
                                    <div style="font-weight: bold; color: #e74c3c; font-size: 1.1rem;">
                                        <%=moneyFormat.format(order.getTotalAmount())%>₫
                                    </div>
                                </div>
                            </div>
                            
                            <div style="margin-bottom: 1rem;">
                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; font-size: 0.9rem; color: #6c757d;">
                                    <div>
                                        <strong>Địa chỉ giao hàng:</strong><br>
                                        <%=order.getShippingAddress()%>
                                    </div>
                                    <div>
                                        <strong>Phương thức thanh toán:</strong><br>
                                        <%=paymentText%>
                                    </div>
                                </div>
                            </div>
                            
                            <div style="text-align: right;">
                                <a href="order?action=detail&id=<%=order.getOrderId()%>" class="btn btn-primary">
                                    Xem chi tiết
                                </a>
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