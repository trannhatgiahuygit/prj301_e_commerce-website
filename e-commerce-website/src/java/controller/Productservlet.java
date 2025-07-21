package controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import dao.ProductDAO;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Product;
import util.AuthUtils;


@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
@WebServlet(name = "Productservlet", urlPatterns = {"/product", "/admin-product"})
public class Productservlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private static final String IMAGE_UPLOAD_PATH = "C:/Project_Images";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "";
        try {
            String servletPath = request.getServletPath();
            String action = request.getParameter("action");

            if (action == null) {
                action = "list";
            }

            // Admin actions - require authentication and authorization
            if ("/admin-product".equals(servletPath)) {
                // Check if user is logged in
                if (!AuthUtils.isLoggedIn(request)) {
                    response.sendRedirect(AuthUtils.getLoginURL());
                    return;
                }

                // Check if user is admin
                if (!AuthUtils.isAdmin(request)) {
                    request.setAttribute("errorMessage",
                            AuthUtils.getAccessDeniedMessage("chức năng quản trị sản phẩm"));
                    url = "index.jsp";
                } else {
                    // Handle admin actions
                    if (action.equals("list")) {
                        url = handleListProductsForAdmin(request, response);
                    } else if (action.equals("add")) {
                        url = handleAddProduct(request, response);
                    } else if (action.equals("edit")) {
                        url = handleEditProduct(request, response);
                    } else if (action.equals("delete")) {
                        url = handleDeleteProduct(request, response);
                    } else {
                        url = handleListProductsForAdmin(request, response);
                    }
                }
            } else {
                // User actions - no special authorization needed
                if (action.equals("list")) {
                    url = handleListProducts(request, response);
                } else if (action.equals("detail")) {
                    url = handleShowProductDetail(request, response);
                } else if (action.equals("category")) {
                    url = handleListProductsByCategory(request, response);
                } else if (action.equals("search")) {
                    url = handleSearchProducts(request, response);
                } else {
                    url = handleListProducts(request, response);
                }
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
    // ADMIN HANDLERS
    // ==============================================
    private String handleListProductsForAdmin(HttpServletRequest request, HttpServletResponse response) {
        try {
            List<Product> products = productDAO.getAllProducts();
            request.setAttribute("products", products);
            return "admin-product.jsp";
        } catch (Exception ex) {
            Logger.getLogger(Productservlet.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Lỗi khi tải danh sách sản phẩm: " + ex.getMessage());
            return "admin-product.jsp";
        }
    }

    private String handleAddProduct(HttpServletRequest request, HttpServletResponse response) {
        try {
            String method = request.getMethod();

            String name = request.getParameter("name");
            if (name == null || name.trim().isEmpty()) {
                // Show add form
                request.setAttribute("pageTitle", "Thêm sản phẩm");
                request.setAttribute("formTitle", "Thông tin sản phẩm mới");
                request.setAttribute("formAction", "add");
                request.setAttribute("product", null);
                return "admin-add-edit-product.jsp";
            } else {
                // Process add
                String priceStr = request.getParameter("price");
                String stockStr = request.getParameter("stock");
                String description = request.getParameter("description");
                String category = request.getParameter("category");
                String brand = request.getParameter("brand");

                if (priceStr == null || priceStr.trim().isEmpty()
                        || stockStr == null || stockStr.trim().isEmpty()
                        || category == null || category.trim().isEmpty()
                        || brand == null || brand.trim().isEmpty()) {

                    request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc!");
                    request.setAttribute("pageTitle", "Thêm sản phẩm");
                    request.setAttribute("formTitle", "Thông tin sản phẩm mới");
                    request.setAttribute("formAction", "add");
                    return "admin-add-edit-product.jsp";
                }

                double price = Double.parseDouble(priceStr);
                int stock = Integer.parseInt(stockStr);

                // Handle file upload
                String imageName = "default-balo.jpg";
                Part imagePart = request.getPart("image");

                if (imagePart != null && imagePart.getSize() > 0) {
                    String fileName = getFileName(imagePart);
                    if (fileName != null && !fileName.isEmpty()) {
                        imageName = generateImageUrl(fileName);

                        File targetDir = new File(IMAGE_UPLOAD_PATH);
                        if (!targetDir.exists()) {
                            targetDir.mkdirs();
                        }

                        try ( InputStream input = imagePart.getInputStream()) {
                            Files.copy(input,
                                    new File(targetDir, imageName).toPath(),
                                    StandardCopyOption.REPLACE_EXISTING);
                        }
                    }
                }

                Product product = new Product();
                product.setName(name.trim());
                product.setPrice(price);
                product.setStock(stock);
                product.setDescription(description != null ? description.trim() : "");
                product.setCategory(category.trim());
                product.setImage(imageName);
                product.setBrand(brand.trim());
                product.setStatus("active");

                boolean success = productDAO.addProduct(product);

                if (success) {
                    request.getSession().setAttribute("successMessage", "Thêm sản phẩm thành công!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi thêm sản phẩm!");
                }

                response.sendRedirect("admin-product");
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            return "admin-product.jsp";
        }
    }

    private String handleEditProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            // Check xem là hiển thị form hay xử lý submit
            String productIdForUpdate = request.getParameter("productId"); // từ form submit

            if (productIdForUpdate == null) {
                // === HIỂN THỊ FORM EDIT ===
                String idParam = request.getParameter("id"); // từ URL link
                if (idParam == null || idParam.trim().isEmpty()) {
                    request.getSession().setAttribute("errorMessage", "ID sản phẩm không hợp lệ!");
                    response.sendRedirect("admin-product");
                    return null;
                }

                int productId = Integer.parseInt(idParam);
                Product product = productDAO.getProductById(productId);

                if (product != null) {
                    request.setAttribute("product", product);
                    request.setAttribute("pageTitle", "Sửa sản phẩm");
                    request.setAttribute("formTitle", "Cập nhật thông tin sản phẩm");
                    request.setAttribute("formAction", "edit");
                    return "admin-add-edit-product.jsp";
                } else {
                    request.getSession().setAttribute("errorMessage", "Không tìm thấy sản phẩm!");
                    response.sendRedirect("admin-product");
                    return null;
                }

            } else {
                // === XỬ LÝ SUBMIT FORM ===
                int productId = Integer.parseInt(productIdForUpdate);
                String name = request.getParameter("name");
                double price = Double.parseDouble(request.getParameter("price"));
                int stock = Integer.parseInt(request.getParameter("stock"));
                String description = request.getParameter("description");
                String category = request.getParameter("category");
                String brand = request.getParameter("brand");

                Product product = productDAO.getProductById(productId);
                if (product == null) {
                    request.getSession().setAttribute("errorMessage", "Không tìm thấy sản phẩm!");
                    response.sendRedirect("admin-product");
                    return null;
                }

                // Handle file upload
                Part imagePart = request.getPart("image");
                String imageName = product.getImage();

                if (imagePart != null && imagePart.getSize() > 0) {
                    String fileName = getFileName(imagePart);
                    if (fileName != null && !fileName.isEmpty()) {
                        imageName = generateImageUrl(fileName);

                        File targetDir = new File(IMAGE_UPLOAD_PATH);
                        if (!targetDir.exists()) {
                            targetDir.mkdirs();
                        }

                        try ( InputStream input = imagePart.getInputStream()) {
                            Files.copy(input,
                                    new File(targetDir, imageName).toPath(),
                                    StandardCopyOption.REPLACE_EXISTING);
                        }
                    }
                }

                // Update product
                product.setName(name.trim());
                product.setPrice(price);
                product.setStock(stock);
                product.setDescription(description != null ? description.trim() : "");
                product.setCategory(category.trim());
                product.setImage(imageName);
                product.setBrand(brand.trim());

                boolean success = productDAO.updateProduct(product);

                if (success) {
                    request.getSession().setAttribute("successMessage", "Cập nhật sản phẩm thành công!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật sản phẩm!");
                }

                response.sendRedirect("admin-product");
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            response.sendRedirect("admin-product");
            return null;
        }
    }

    private String handleDeleteProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String productIdStr = request.getParameter("productId");

            if (productIdStr == null || productIdStr.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "ID sản phẩm không hợp lệ!");
                response.sendRedirect("admin-product.jsp");
                return null;
            }

            boolean success = productDAO.delete(productIdStr, "inactive");

            if (success) {
                request.getSession().setAttribute("successMessage", "Xóa sản phẩm thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi xóa sản phẩm!");
            }

            response.sendRedirect("admin-product.jsp");
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            response.sendRedirect("admin-product");
            return null;
        }
    }

    // ==============================================
    // USER HANDLERS
    // ==============================================
    private String handleShowProductDetail(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ClassNotFoundException, IOException {
        String productIdStr = request.getParameter("id");

        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            response.sendRedirect("product?action=list");
            return null;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            Product product = productDAO.getProductById(productId);

            if (product != null) {
                request.setAttribute("product", product);
                return "product-detail.jsp";
            } else {
                response.sendRedirect("product?action=list");
                return null;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("product?action=list");
            return null;
        }
    }

    private String handleListProductsByCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ClassNotFoundException {
        String category = request.getParameter("category");

        if (category == null || category.trim().isEmpty()) {
            return handleListProducts(request, response);
        }

        try {
            category = java.net.URLDecoder.decode(category, "UTF-8");
        } catch (Exception e) {
            System.err.println("Error decoding category: " + e.getMessage());
        }

        List<Product> products = productDAO.getProductsByCategory(category);
        request.setAttribute("products", products);
        request.setAttribute("currentCategory", category);
        return "products.jsp";
    }

    private String handleSearchProducts(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ClassNotFoundException {
        String keyword = request.getParameter("keyword");

        if (keyword == null || keyword.trim().isEmpty()) {
            return handleListProducts(request, response);
        }

        List<Product> products = productDAO.searchProducts(keyword);
        request.setAttribute("products", products);
        request.setAttribute("searchKeyword", keyword);
        return "products.jsp";
    }

    private String handleListProducts(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ClassNotFoundException {
        List<Product> products = productDAO.getAllProducts();
        request.setAttribute("products", products);
        return "products.jsp";
    }

    // ==============================================
    // HELPER METHODS
    // ==============================================
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp != null) {
            for (String cd : contentDisp.split(";")) {
                if (cd.trim().startsWith("filename")) {
                    return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return null;
    }

    private String generateImageUrl(String originalFileName) {
        String uuid = UUID.randomUUID().toString();

        String extension = "";
        int dotIndex = originalFileName.lastIndexOf('.');
        if (dotIndex >= 0 && dotIndex < originalFileName.length() - 1) {
            extension = originalFileName.substring(dotIndex);
        }

        return uuid + extension;
    }
}
