<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - BaloShop</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .login-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
        }
        
        .login-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            overflow: hidden;
            width: 100%;
            max-width: 400px;
            padding: 40px;
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .login-header h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .login-header p {
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
            padding: 15px;
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
        
        .btn-login {
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
        
        .btn-login:hover {
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
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .login-footer {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e1e5e9;
        }
        
        .login-footer p {
            color: #666;
            margin-bottom: 10px;
        }
        
        .login-footer a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        
        .login-footer a:hover {
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
    </style>
</head>
<body>
    <div class="login-container">
        <a href="<%=request.getContextPath()%>/index.jsp" class="back-home">← Về trang chủ</a>
        
        <div class="login-card">
            <div class="login-header">
                <h1>Đăng nhập</h1>
                <p>Chào mừng bạn quay trở lại!</p>
            </div>
            
            <%
                String error = (String) request.getAttribute("error");
                String success = (String) request.getAttribute("success");
                
                if (error != null && !error.trim().isEmpty()) {
            %>
                <div class="alert alert-error">
                    <strong>Lỗi:</strong> <%=error%>
                </div>
            <%
                }
                
                if (success != null && !success.trim().isEmpty()) {
            %>
                <div class="alert alert-success">
                    <%=success%>
                </div>
            <%
                }
            %>
            
            <form action="<%=request.getContextPath()%>/user" method="post">
                <input type="hidden" name="action" value="login">
                
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
                           value="<%=request.getParameter("username") != null ? request.getParameter("username") : ""%>">
                </div>
                
                <div class="form-group">
                    <label for="password" class="form-label">
                        Mật khẩu <span class="required">*</span>
                    </label>
                    <input type="password" 
                           id="password" 
                           name="password" 
                           class="form-input"
                           placeholder="Nhập mật khẩu"
                           required>
                </div>
                
                <button type="submit" class="btn-login">
                    Đăng nhập
                </button>
            </form>
            
            <div class="login-footer">
                <p>Chưa có tài khoản?</p>
                <a href="<%=request.getContextPath()%>/user?action=register">Đăng ký ngay</a>
            </div>
        </div>
    </div>
</body>
</html>