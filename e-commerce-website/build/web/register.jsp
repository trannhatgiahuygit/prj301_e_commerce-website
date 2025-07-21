<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - BaloShop</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .register-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
        }
        
        .form-container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            padding: 40px;
        }
        
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .register-header h2 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .register-header p {
            color: #666;
            font-size: 16px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }
        
        .form-input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-textarea {
            resize: vertical;
            height: 80px;
            font-family: Arial, sans-serif;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
        
        .btn-register {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s ease;
        }
        
        .btn-register:hover {
            transform: translateY(-2px);
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-size: 14px;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .register-footer {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e1e5e9;
        }
        
        .register-footer p {
            color: #666;
            margin: 0;
        }
        
        .register-footer a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        
        .register-footer a:hover {
            text-decoration: underline;
        }
        
        .back-home {
            position: absolute;
            top: 20px;
            left: 20px;
            color: white;
            text-decoration: none;
            font-weight: 600;
            padding: 10px 15px;
            background: rgba(255,255,255,0.2);
            border-radius: 8px;
            transition: background 0.3s ease;
        }
        
        .back-home:hover {
            background: rgba(255,255,255,0.3);
        }
        
        .required {
            color: #dc3545;
        }
        
        .field-help {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <a href="<%=request.getContextPath()%>/index.jsp" class="back-home">← Về trang chủ</a>
        
        <div class="form-container">
            <div class="register-header">
                <h2>Đăng ký tài khoản</h2>
                <p>Tạo tài khoản mới để bắt đầu mua sắm</p>
            </div>
            
            <%
                String error = (String) request.getAttribute("error");
                if (error != null && !error.trim().isEmpty()) {
            %>
                <div class="alert alert-error">
                    <strong>Lỗi:</strong> <%=error%>
                </div>
            <%
                }
            %>
            
            <form action="<%=request.getContextPath()%>/user" method="post">
                <input type="hidden" name="action" value="register">
                
                <div class="form-group">
                    <label for="username" class="form-label">
                        Tên đăng nhập <span class="required">*</span>
                    </label>
                    <input type="text" 
                           id="username" 
                           name="username" 
                           class="form-input"
                           placeholder="Nhập tên đăng nhập"
                           required 
                           minlength="3"
                           maxlength="50"
                           value="<%=request.getParameter("username") != null ? request.getParameter("username") : ""%>">
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="password" class="form-label">
                            Mật khẩu <span class="required">*</span>
                        </label>
                        <input type="password" 
                               id="password" 
                               name="password" 
                               class="form-input"
                               placeholder="Nhập mật khẩu"
                               required
                               minlength="6">
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword" class="form-label">
                            Xác nhận mật khẩu <span class="required">*</span>
                        </label>
                        <input type="password" 
                               id="confirmPassword" 
                               name="confirmPassword" 
                               class="form-input"
                               placeholder="Nhập lại mật khẩu"
                               required>
                        <div class="field-help">Nhập lại mật khẩu để xác nhận</div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="email" class="form-label">
                        Email <span class="required">*</span>
                    </label>
                    <input type="email" 
                           id="email" 
                           name="email" 
                           class="form-input"
                           placeholder="example@email.com"
                           required 
                           value="<%=request.getParameter("email") != null ? request.getParameter("email") : ""%>">
                </div>
                
                <div class="form-group">
                    <label for="fullName" class="form-label">
                        Họ và tên <span class="required">*</span>
                    </label>
                    <input type="text" 
                           id="fullName" 
                           name="fullName" 
                           class="form-input"
                           placeholder="Nhập họ và tên đầy đủ"
                           required 
                           value="<%=request.getParameter("fullName") != null ? request.getParameter("fullName") : ""%>">
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="phone" class="form-label">Số điện thoại <span class="required">*</span>
                        </label>
                        <input type="tel" 
                               id="phone" 
                               name="phone" 
                               class="form-input"
                               required
                               value="<%=request.getParameter("phone") != null ? request.getParameter("phone") : ""%>">
                    </div>
                    
                    <div class="form-group">
                        <label for="address" class="form-label">Địa chỉ</label>
                        <textarea id="address" 
                                  name="address" 
                                  class="form-input form-textarea"
                                  placeholder="Nhập địa chỉ của bạn"><%=request.getParameter("address") != null ? request.getParameter("address") : ""%></textarea>
                    </div>
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn-register">
                        Đăng ký tài khoản
                    </button>
                </div>
            </form>
            
            <div class="register-footer">
                <p>Đã có tài khoản? <a href="<%=request.getContextPath()%>/user?action=login">Đăng nhập ngay</a></p>
            </div>
        </div>
    </div>
</body>
</html>