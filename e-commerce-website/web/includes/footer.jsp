<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String footerContextPath = request.getContextPath();
%>

<footer class="footer">
    <div class="container">
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 2rem; text-align: left; margin-bottom: 2rem;">
            <div>
                <h3 style="margin-bottom: 1rem;">BaloShop</h3>
                <p>Cửa hàng balo chất lượng cao, phục vụ mọi nhu cầu của bạn từ học tập, làm việc đến du lịch.</p>
            </div>
            
            <div>
                <h4 style="margin-bottom: 1rem;">Liên kết nhanh</h4>
                <ul style="list-style: none;">
                    <li><a href="<%=footerContextPath%>/index.jsp" style="color: #ccc; text-decoration: none;">Trang chủ</a></li>
                    <li><a href="<%=footerContextPath%>/product" style="color: #ccc; text-decoration: none;">Sản phẩm</a></li>
                    <li><a href="#" style="color: #ccc; text-decoration: none;">Về chúng tôi</a></li>
                    <li><a href="#" style="color: #ccc; text-decoration: none;">Liên hệ</a></li>
                </ul>
            </div>
            
            <div>
                <h4 style="margin-bottom: 1rem;">Danh mục</h4>
                <ul style="list-style: none;">
                    <li><a href="<%=footerContextPath%>/product?action=category&category=Balo laptop" style="color: #ccc; text-decoration: none;">Balo laptop</a></li>
                    <li><a href="<%=footerContextPath%>/product?action=category&category=Balo học sinh" style="color: #ccc; text-decoration: none;">Balo học sinh</a></li>
                    <li><a href="<%=footerContextPath%>/product?action=category&category=Balo du lịch" style="color: #ccc; text-decoration: none;">Balo du lịch</a></li>
                    <li><a href="<%=footerContextPath%>/product?action=category&category=Balo thể thao" style="color: #ccc; text-decoration: none;">Balo thể thao</a></li>
                </ul>
            </div>
            
            <div>
                <h4 style="margin-bottom: 1rem;">Thông tin liên hệ</h4>
                <p style="color: #ccc;">📧 info@baloshop.com</p>
                <p style="color: #ccc;">📞 0123 456 789</p>
                <p style="color: #ccc;">📍 123 Đường ABC, Quận XYZ, TP.HCM</p>
            </div>
        </div>
        
        <div style="border-top: 1px solid #555; padding-top: 1rem; text-align: center;">
            <p>&copy; 2025 BaloShop. Tất cả quyền được bảo lưu.</p>
        </div>
    </div>
</footer>