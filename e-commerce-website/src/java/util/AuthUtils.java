package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.User;


public class AuthUtils {
    
    /**
     * Get current logged in user from session
     * @param request HttpServletRequest
     * @return User object or null if not logged in
     */
    public static User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("user");
        }
        return null;
    }
    
    /**
     * Check if user is logged in
     * @param request HttpServletRequest
     * @return true if user is logged in, false otherwise
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        return AuthUtils.getCurrentUser(request) != null;
    }
    
    /**
     * Check if current user has specific role
     * @param request HttpServletRequest
     * @param role Role to check
     * @return true if user has the role, false otherwise
     */
    public static boolean hasRole(HttpServletRequest request, String role) {
        User user = getCurrentUser(request);
        if (user != null) {
            String userRole = user.getRole();
            return userRole.equalsIgnoreCase(role);
        }
        return false;
    }
    
    /**
     * Check if current user is admin
     * @param request HttpServletRequest
     * @return true if user is admin, false otherwise
     */
    public static boolean isAdmin(HttpServletRequest request) {
        return hasRole(request, "admin");
    }
    
    /**
     * Check if current user is customer
     * @param request HttpServletRequest
     * @return true if user is customer, false otherwise
     */
    public static boolean isCustomer(HttpServletRequest request) {
        return hasRole(request, "customer");
    }
    
    /**
     * Get login URL
     * @return Login URL string
     */
    public static String getLoginURL() {
        return "user?action=login";
    }
    
    /**
     * Get access denied message
     * @param action Action that was denied
     * @return Access denied message
     */
    public static String getAccessDeniedMessage(String action) {
        return "Bạn không có quyền truy cập " + action + ". Vui lòng liên hệ quản trị viên.";
    }
    
    /**
     * Get home URL based on user role
     * @param request HttpServletRequest
     * @return Home URL string
     */
    public static String getHomeURL(HttpServletRequest request) {
        if (isAdmin(request)) {
            return "admin-product";
        }
        return "index.jsp";
    }
}