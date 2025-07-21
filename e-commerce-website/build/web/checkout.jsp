<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - BaloShop</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-content">
        <div class="container">
            <h2 style="margin-bottom: 2rem;">Thanh toán đơn hàng</h2>
            
            <%
                String error = (String) request.getAttribute("error");
                if (error != null && !error.trim().isEmpty()) {
            %>
                <div class="alert alert-error"><%=error%></div>
            <%
                }
                
                List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
                Double totalAmount = (Double) request.getAttribute("totalAmount");
                User checkoutUser = (User) session.getAttribute("user");
                
                if (totalAmount == null) totalAmount = 0.0;
                double shippingFee = totalAmount >= 500000 ? 0 : 30000;
                double finalTotal = totalAmount + shippingFee;
            %>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 3rem;">
                <!-- Order Form -->
                <div>
                    <div style="background: white; padding: 2rem; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                        <h3 style="margin-bottom: 1.5rem;">Thông tin giao hàng</h3>
                        
                        <form action="<%=request.getContextPath()%>/order" method="post">
                            <input type="hidden" name="action" value="place">
                            
                            <div class="form-group">
                                <label for="customerName" class="form-label">Họ và tên:</label>
                                <input type="text" id="customerName" class="form-input" 
                                       value="<%=checkoutUser != null && checkoutUser.getFullName() != null ? checkoutUser.getFullName() : ""%>" readonly>
                            </div>
                            
                            <div class="form-group">
                                <label for="customerEmail" class="form-label">Email:</label>
                                <input type="email" id="customerEmail" class="form-input" 
                                       value="<%=checkoutUser != null && checkoutUser.getEmail() != null ? checkoutUser.getEmail() : ""%>" readonly>
                            </div>
                            
                            <div class="form-group">
                                <label for="customerPhone" class="form-label">Số điện thoại:</label>
                                <input type="tel" id="customerPhone" class="form-input" 
                                       value="<%=checkoutUser != null && checkoutUser.getPhone() != null ? checkoutUser.getPhone() : ""%>" readonly>
                            </div>
                            
                            <div class="form-group">
                                <label for="shippingAddress" class="form-label">Địa chỉ giao hàng: <span style="color: red;">*</span></label>
                                <textarea id="shippingAddress" name="shippingAddress" class="form-input form-textarea" 
                                          required placeholder="Nhập địa chỉ giao hàng chi tiết..."><%=checkoutUser != null && checkoutUser.getAddress() != null ? checkoutUser.getAddress() : ""%></textarea>
                            </div>
                            
                            <div class="form-group">
                                <label for="paymentMethod" class="form-label">Phương thức thanh toán: <span style="color: red;">*</span></label>
                                <select id="paymentMethod" name="paymentMethod" class="form-input" required>
                                    <option value="">Chọn phương thức thanh toán</option>
                                    <option value="cod">Thanh toán khi nhận hàng (COD)</option>
                                    <option value="bank">Chuyển khoản ngân hàng</option>
                                    <option value="momo">Ví MoMo</option>
                                    <option value="zalopay">ZaloPay</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="note" class="form-label">Ghi chú:</label>
                                <textarea id="note" name="note" class="form-input form-textarea" 
                                          placeholder="Ghi chú đặc biệt cho đơn hàng..."></textarea>
                            </div>
                            
                            <button type="submit" class="btn btn-primary" style="width: 100%; padding: 1rem; font-size: 1.1rem;">
                                Đặt hàng
                            </button>
                        </form>
                    </div>
                </div>
                
                <!-- Order Summary -->
                <div>
                    <div style="background: white; padding: 2rem; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                        <h3 style="margin-bottom: 1.5rem;">Đơn hàng của bạn</h3>
                        
                        <div style="border-bottom: 1px solid #dee2e6; padding-bottom: 1rem; margin-bottom: 1rem;">
                            <%
                                if (cartItems != null && !cartItems.isEmpty()) {
                                    for (CartItem item : cartItems) {
                                        Product product = item.getProduct();
                            %>
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                                    <div style="display: flex; align-items: center; gap: 1rem;">
                                        <img src="<%=request.getContextPath()%>/images/<%=product.getImage()%>" 
                                             alt="<%=product.getName()%>" 
                                             style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px;"
                                             onerror="this.src='<%=request.getContextPath()%>/images/default-balo.jpg'">
                                        <div>
                                            <div style="font-weight: 500;"><%=product.getName()%></div>
                                            <div style="color: #6c757d; font-size: 0.9rem;">Số lượng: <%=item.getQuantity()%></div>
                                        </div>
                                    </div>
                                    <div style="font-weight: bold; color: #e74c3c;">
                                        <%=String.format("%,.0f", item.getTotalPrice())%>₫
                                    </div>
                                </div>
                            <%
                                    }
                                } else {
                            %>
                                <div style="text-align: center; color: #6c757d;">
                                    Giỏ hàng trống
                                </div>
                            <%
                                }
                            %>
                        </div>
                        
                        <div style="margin-bottom: 1rem;">
                            <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                                <span>Tạm tính:</span>
                                <span><%=String.format("%,.0f", totalAmount)%>₫</span>
                            </div>
                            <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                                <span>Phí vận chuyển:</span>
                                <span>
                                    <%
                                        if (totalAmount >= 500000) {
                                    %>
                                        <span style="color: #28a745;">Miễn phí</span>
                                    <%
                                        } else {
                                    %>
                                        <%=String.format("%,.0f", shippingFee)%>₫
                                    <%
                                        }
                                    %>
                                </span>
                            </div>
                        </div>
                        
                        <div style="border-top: 1px solid #dee2e6; padding-top: 1rem;">
                            <div style="display: flex; justify-content: space-between; font-size: 1.2rem; font-weight: bold;">
                                <span>Tổng cộng:</span>
                                <span style="color: #e74c3c;">
                                    <%=String.format("%,.0f", finalTotal)%>₫
                                </span>
                            </div>
                        </div>
                        
                        <%
                            if (totalAmount < 500000) {
                                double needMore = 500000 - totalAmount;
                        %>
                            <div class="shipping-note">
                                Mua thêm <%=String.format("%,.0f", needMore)%> VND để được miễn phí vận chuyển!
                            </div>
                        <%
                            }
                        %>
                    </div>
                    
                    <div class="policy-section">
                        <h4>Chính sách</h4>
                        <ul>
                            <li>✓ Đổi trả trong 7 ngày</li>
                            <li>✓ Bảo hành 12 tháng</li>
                            <li>✓ Giao hàng 2-3 ngày</li>
                            <li>✓ Hỗ trợ 24/7</li>
                        </ul>
                    </div>
                    
                    <!-- Thông tin thanh toán -->
                    <div class="payment-info">
                        <h4>Thông tin thanh toán</h4>
                        <div class="payment-details">
                            <p><strong>COD:</strong> Thanh toán khi nhận hàng</p>
                            <p><strong>Chuyển khoản:</strong> BIDV - 6513796446</p>
                            <p><strong>MoMo:</strong> 0354254718</p>
                            <p><strong>ZaloPay:</strong> 0354254718</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div style="text-align: center; margin-top: 2rem;">
                <a href="<%=request.getContextPath()%>/cart" class="btn">← Quay lại giỏ hàng</a>
            </div>
        </div>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
    
    <style>
        @media (max-width: 768px) {
            .container > div:first-child {
                grid-template-columns: 1fr !important;
                gap: 2rem !important;
            }
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            display: block;
            font-weight: bold;
            margin-bottom: 0.5rem;
            color: #333;
        }
        
        .form-input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 2px rgba(0,123,255,0.25);
        }
        
        .form-textarea {
            resize: vertical;
            height: 80px;
            font-family: Arial, sans-serif;
        }
        
        .alert {
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 4px;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .required-field {
            color: red;
            font-weight: bold;
        }
        
        .payment-info {
            background: #e7f3ff;
            padding: 1.5rem;
            border-radius: 10px;
            margin-top: 1rem;
            border-left: 4px solid #007bff;
        }
        
        .payment-info h4 {
            margin-bottom: 1rem;
            color: #0056b3;
        }
        
        .payment-details {
            font-size: 0.9rem;
            color: #495057;
        }
        
        .payment-details p {
            margin-bottom: 0.5rem;
        }
        
        .shipping-note {
            background: #fff3cd;
            color: #856404;
            padding: 1rem;
            border-radius: 5px;
            margin-top: 1rem;
            font-size: 0.9rem;
        }
        
        .policy-section {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 10px;
            margin-top: 1rem;
        }
        
        .policy-section h4 {
            margin-bottom: 1rem;
            color: #333;
        }
        
        .policy-section ul {
            list-style: none;
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .policy-section li {
            margin-bottom: 0.5rem;
        }
    </style>
</body>
</html>