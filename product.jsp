<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Show All Products</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

    <link rel="stylesheet" href="style.css?v=<%= System.currentTimeMillis() %>">

</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="search bg-primary text-white py-3">
        <form class="d-flex container">
            <input class="form-control me-2" type="search" name="search" placeholder="Search products..." aria-label="Search">
            <button class="btn btn-light" type="submit">Search</button>
        </form>
    </div>

    <div class="container-fluid bg-light py-4">
        <div class="row">
            <!-- Left Sidebar: Categories -->
            <div class="col-md-3">
                <div class="bg-white p-4 rounded shadow-sm">
                    <h3 class="text-center mb-3">Categories</h3>
                    <ul class="list-group">
                        <li class="list-group-item"><a href="product.jsp" class="text-dark text-decoration-none">All</a></li>
                        <li class="list-group-item"><a href="product.jsp?category=Electronics" class="text-dark text-decoration-none">Electronics</a></li>
                        <li class="list-group-item"><a href="product.jsp?category=Laptop" class="text-dark text-decoration-none">Laptop</a></li>
                        <li class="list-group-item"><a href="product.jsp?category=Phone" class="text-dark text-decoration-none">Mobile Phone</a></li>
                        <li class="list-group-item"><a href="product.jsp?category=Fashion" class="text-dark text-decoration-none">Fashion</a></li>
                        <li class="list-group-item"><a href="product.jsp?category=Fashion" class="text-dark text-decoration-none">Clothing</a></li>
                        <li class="list-group-item"><a href="product.jsp?category=Books" class="text-dark text-decoration-none">Books</a></li>
                        <li class="list-group-item"><a href="product.jsp?category=Beauty Product" class="text-dark text-decoration-none">Beauty Products</a></li>
                    </ul>
                </div>
            </div>

            <!-- Right: Product Display -->
            <div class="col-md-9">
                <div class="bg-white p-4 rounded shadow-sm">
                    <h3 class="text-center mb-4">Products</h3>
                    <div class="row g-4">
                        
                      <%
                          // Retrieve database connection
                          conn = (Connection) application.getAttribute("DBConnection");

                          if (conn == null) {
                              out.println("<p class='text-danger text-center'>Database connection failed.</p>");
                              return;
                          }

                          // Get search and category parameters
                          String searchQuery = request.getParameter("search");
                          String category = request.getParameter("category");

                          // Base query - Show all products by default
                          String query = "SELECT * FROM product";
                          PreparedStatement stmt = null;

                          // Modify query based on category or search query
                          if (category != null && !category.isEmpty()) {
                              // Filter by category
                              query += " WHERE category = ?";
                              stmt = conn.prepareStatement(query);
                              stmt.setString(1, category);
                          } else if (searchQuery != null && !searchQuery.isEmpty()) {
                              // Filter by search query
                              query += " WHERE title LIKE ?";
                              stmt = conn.prepareStatement(query);
                              stmt.setString(1, "%" + searchQuery + "%");
                          } else {
                              // Show all products when no category or search query is provided
                              stmt = conn.prepareStatement(query);
                          }

                          // Execute query
                          ResultSet rs = stmt.executeQuery();

                          while (rs.next()) {
                              int productId = rs.getInt("id");
                              String productName = rs.getString("title");
                              String productImage = rs.getString("image");
                              double price = rs.getDouble("price");
                              double discount = rs.getDouble("discount");

                              // Calculate original price based on discount
                              double originalPrice = price * 100 / (100 - discount);
                              // Format the original price to 2 decimal places
                              String formattedOriginalPrice = String.format("%.2f", originalPrice);

                      %>
                        <div class="col-md-4 col-sm-6 d-flex">
                            <div class="card shadow-sm w-100" style="width: 18rem;" >
                                <div class="image-container">
                                    <img src="<%= productImage %>" class="card-img-top" alt="Product Image" style="height: 200px;background-position: center;background-size: cover;background-repeat: no-repeat;">
                                </div>
                                <div class="card-body text-center">
                                    <h5 class="card-title"><%= productName %></h5>
                                    <div class="mb-3">
                                        <span class="h6 me-2">Rs. <%= price %></span>
                                        <span class="text-muted text-decoration-line-through">Rs. <%= formattedOriginalPrice %></span>
                                        <span class="badge bg-danger ms-2"><%= discount %>% OFF</span>
                                    </div>
                                    <a href="productDetails.jsp?productId=<%= productId %>" class="btn btn-primary mt-2">View Details</a>
                                </div>
                            </div>
                        </div>
                        <%
                            }
                            rs.close();
                            stmt.close();
                        %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />

</body>
</html>
