# 🎒 Online Backpack Store

A personal web application project: **Online Backpack Store**, built using **Java Servlets, JSP, and JDBC**, developed for the **PRJ301 - Java Web Development** course.

This project simulates an e-commerce platform where customers can browse, search, and purchase various backpacks. The application follows the **MVC (Model-View-Controller)** design pattern and implements essential e-commerce features such as product catalog, shopping cart, user authentication, and order management.

---

## 🚀 Features

✅ Homepage with featured products and categories  
✅ Product listing with details, images, and prices  
✅ Search and filter products by name, price, and category  
✅ Product detail page  
✅ Shopping cart: add, update, and remove items  
✅ User registration and login  
✅ Place orders and view order history  
✅ Admin panel to manage products and orders

---

## 🛠️ Technologies Used

- **Backend:** Java Servlets, JSP
- **Frontend:** HTML, CSS
- **Database:** SQL Server, accessed via JDBC
- **Architecture:** MVC (Model - View - Controller)

---

## 📂 Project Structure

e-commerce-website/
│
├── Web Pages/
│ ├── META-INF/
│ ├── WEB-INF/
│ │
│ ├── css/
│ │ └── style.css
│ │
│ ├── images/
│ │ └── default-balo.png
│ │
│ ├── includes/
│ │ ├── footer.jsp
│ │ └── header.jsp
│ │
│ ├── admin-add-edit-product.jsp
│ ├── admin-product.jsp
│ ├── cart.jsp
│ ├── checkout.jsp
│ ├── index.jsp
│ ├── login.jsp
│ ├── order-detail.jsp
│ ├── orders.jsp
│ ├── product-detail.jsp
│ ├── products.jsp
│ └── register.jsp
│
├── Remote Files/
│
└── Source Packages/
├── controller/
│ ├── CartServlet.java
│ ├── ImageServlet.java
│ ├── OrderServlet.java
│ ├── ProductServlet.java
│ └── UserServlet.java
│
├── dao/
│ ├── CartDAO.java
│ ├── OrderDAO.java
│ ├── ProductDAO.java
│ └── UserDAO.java
│
├── model/
│ ├── CartItem.java
│ ├── Order.java
│ ├── OrderItem.java
│ ├── Product.java
│ └── User.java
│
└── util/
├── AuthUtils.java
├── DatabaseConnection.java
└── PasswordUtil.java

