package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.AuthUtils;


@WebServlet(name = "UserServlet", urlPatterns = {"/user"})
public class UserServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "";
        try {
            String action = request.getParameter("action");

            if (action == null) {
                action = "login";
            }

            // Handle different actions
            if (action.equals("login")) {
                url = handleLogin(request, response);
            } else if (action.equals("register")) {
                url = handleRegister(request, response);
            } else if (action.equals("logout")) {
                url = handleLogout(request, response);
            } else if (action.equals("profile")) {
                url = handleProfile(request, response);
            } else if (action.equals("deleteAccount")) {
                url = handleDeleteAccount(request, response);
            } else {
                url = "index.jsp";
            }
        } catch (Exception e) {
            e.printStackTrace();
            url = "index.jsp";
            request.setAttribute("errorMessage", "Có lỗi xảy ra trong quá trình xử lý: " + e.getMessage());
        } finally {
            if (url != null && !response.isCommitted()) {
                request.getRequestDispatcher(url).forward(request, response);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    // ==============================================
    // HANDLER METHODS
    // ==============================================
    
    private String handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        // If already logged in, redirect to home
        if (AuthUtils.isLoggedIn(request)) {
            response.sendRedirect(AuthUtils.getHomeURL(request));
            return null;
        }
        
        String username = request.getParameter("username");
        
        if (username == null || username.trim().isEmpty()) {
            // Show login form
            return "login.jsp";
        } else {
            // Process login
            String password = request.getParameter("password");

            if (password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin");
                return "login.jsp";
            }

            User user = userDAO.loginUser(username, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                
                // Use AuthUtils to determine redirect URL
                response.sendRedirect(AuthUtils.getHomeURL(request));
                return null;
            } else {
                request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng");
                return "login.jsp";
            }
        }
    }

    private String handleRegister(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        // If already logged in, redirect to home
        if (AuthUtils.isLoggedIn(request)) {
            response.sendRedirect(AuthUtils.getHomeURL(request));
            return null;
        }
        
        String username = request.getParameter("username");
        
        if (username == null || username.trim().isEmpty()) {
            // Show register form
            return "register.jsp";
        } else {
            // Process register
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String email = request.getParameter("email");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            // Validation
            if (password == null || email == null || fullName == null
                    || password.trim().isEmpty() || email.trim().isEmpty()
                    || fullName.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc");
                return "register.jsp";
            }

            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu xác nhận không khớp");
                return "register.jsp";
            }

            if (userDAO.usernameExists(username)) {
                request.setAttribute("error", "Tên đăng nhập đã tồn tại");
                return "register.jsp";
            }

            if (userDAO.emailExists(email)) {
                request.setAttribute("error", "Email đã được sử dụng");
                return "register.jsp";
            }

            User user = new User(username, password, email, fullName, phone, address);

            if (userDAO.createUser(user)) {
                request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
                return "login.jsp";
            } else {
                request.setAttribute("error", "Có lỗi xảy ra trong quá trình đăng ký");
                return "register.jsp";
            }
        }
    }

    private String handleLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("index.jsp");
        return null;
    }

    private String handleProfile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in
        if (!AuthUtils.isLoggedIn(request)) {
            response.sendRedirect(AuthUtils.getLoginURL());
            return null;
        }

        return "profile.jsp";
    }
    
    private String handleDeleteAccount(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ClassNotFoundException, IOException, ServletException {
        
        // Check if user is logged in
        if (!AuthUtils.isLoggedIn(request)) {
            response.sendRedirect(AuthUtils.getLoginURL());
            return null;
        }
        
        String userId = request.getParameter("id");
        User currentUser = AuthUtils.getCurrentUser(request);
        
        // Security check: user can only delete their own account or admin can delete any account
        if (!AuthUtils.isAdmin(request) && !String.valueOf(currentUser.getUserId()).equals(userId)) {
            request.setAttribute("MESSAGE", "Bạn không có quyền xóa tài khoản này!");
            return "index.jsp";
        }
        
        boolean check = userDAO.delete(userId);
        if (check) {
            HttpSession session = request.getSession();
            session.invalidate();
            response.sendRedirect("login.jsp");
            return null;
        } else {
            request.setAttribute("MESSAGE", "Không thể xóa tài khoản này!");
            return "index.jsp";
        }
    }
}