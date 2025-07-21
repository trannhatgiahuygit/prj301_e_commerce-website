package controller;

import dao.CartDAO;
import dao.ProductDAO;
import model.CartItem;
import model.Product;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.AuthUtils;


@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAO();
    private ProductDAO productDAO = new ProductDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "";
        try {
            String action = request.getParameter("action");

            if (action == null) {
                action = "view";
            }

            // All cart actions require login
            if (!AuthUtils.isLoggedIn(request)) {
                response.sendRedirect(AuthUtils.getLoginURL());
                return;
            }

            // Handle different actions
            if (action.equals("view")) {
                url = handleViewCart(request, response);
            } else if (action.equals("add")) {
                url = handleAddToCart(request, response);
            } else if (action.equals("update")) {
                url = handleUpdateCart(request, response);
            } else if (action.equals("remove")) {
                url = handleRemoveFromCart(request, response);
            } else {
                url = handleViewCart(request, response);
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
    
    private String handleViewCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        User user = AuthUtils.getCurrentUser(request);
        List<CartItem> cartItems = cartDAO.getCartItems(user.getUserId());
        double totalAmount = cartDAO.getCartTotal(user.getUserId());

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
        return "cart.jsp";
    }

    private String handleAddToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");

        if (productIdStr == null || quantityStr == null) {
            response.sendRedirect("product");
            return null;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            int quantity = Integer.parseInt(quantityStr);

            if (quantity <= 0) {
                response.sendRedirect("product?action=detail&id=" + productId);
                return null;
            }

            // Check if product exists and has enough stock
            Product product = productDAO.getProductById(productId);
            if (product == null || product.getStock() < quantity) {
                request.getSession().setAttribute("errorMessage", "Sản phẩm không đủ số lượng trong kho");
                response.sendRedirect("product?action=detail&id=" + productId);
                return null;
            }

            User user = AuthUtils.getCurrentUser(request);
            CartItem cartItem = new CartItem(user.getUserId(), productId, quantity);

            if (cartDAO.addToCart(cartItem)) {
                request.getSession().setAttribute("successMessage", "Đã thêm sản phẩm vào giỏ hàng!");
                response.sendRedirect("cart");
            } else {
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi thêm vào giỏ hàng!");
                response.sendRedirect("product?action=detail&id=" + productId);
            }
            return null;
        } catch (NumberFormatException e) {
            response.sendRedirect("product");
            return null;
        }
    }

    private String handleUpdateCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        String[] cartItemIds = request.getParameterValues("cartItemId");
        String[] quantities = request.getParameterValues("quantity");

        if (cartItemIds != null && quantities != null && cartItemIds.length == quantities.length) {
            boolean hasError = false;
            for (int i = 0; i < cartItemIds.length; i++) {
                try {
                    int cartItemId = Integer.parseInt(cartItemIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);
                    
                    if (quantity < 0) {
                        hasError = true;
                        continue;
                    }
                    
                    cartDAO.updateCartItemQuantity(cartItemId, quantity);
                } catch (NumberFormatException e) {
                    hasError = true;
                }
            }
            
            if (hasError) {
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật giỏ hàng!");
            } else {
                request.getSession().setAttribute("successMessage", "Cập nhật giỏ hàng thành công!");
            }
        }

        response.sendRedirect("cart");
        return null;
    }

    private String handleRemoveFromCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        String cartItemIdStr = request.getParameter("cartItemId");

        if (cartItemIdStr != null) {
            try {
                int cartItemId = Integer.parseInt(cartItemIdStr);
                
                if (cartDAO.removeCartItem(cartItemId)) {
                    request.getSession().setAttribute("successMessage", "Đã xóa sản phẩm khỏi giỏ hàng!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi xóa sản phẩm!");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "ID sản phẩm không hợp lệ!");
            }
        }

        response.sendRedirect("cart");
        return null;
    }
}