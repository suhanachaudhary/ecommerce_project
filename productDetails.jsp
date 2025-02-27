<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Details</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    
    <link rel="stylesheet" href="style.css">

</head>
<body>
    <jsp:include page="navbar.jsp" />

    <%
        String productId = request.getParameter("productId");
        conn = (Connection) application.getAttribute("DBConnection");
        
        if (conn == null) {
            out.println("<p class='text-danger text-center'>Database connection failed.</p>");
            return;
        }

        if (productId == null || productId.isEmpty()) {
            out.println("<p class='text-danger text-center'>No product selected or invalid product ID.</p>");
            return;
        }

        // Query to get the product details based on the productId
        String query = "SELECT * FROM product WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setInt(1, Integer.parseInt(productId));
        ResultSet rs = stmt.executeQuery();
    %>

    <div class="container mt-3">
        <h2 class="text-center mb-5">Product Details</h2>
        <div class="row">
            <%
                if (rs.next()) {
                    String productName = rs.getString("title");
                    String productDescription = rs.getString("description");
                    String category = rs.getString("category");
                    double price = rs.getDouble("price");
                    double discount = rs.getDouble("discount");
                    double originalPrice = price + discount;
                    double discountedPrice = price - (price * (discount / 100));
                    String productImage=rs.getString("image");
            %>

            <!-- Product Images -->
            <div class="col-md-6 mb-4">
                <img src="<%= productImage %>" alt="Product" class="img-fluid rounded mb-3 product-image" id="mainImage" style="width: 34rem;height:460px !important;">
            </div>

            <!-- Product Details -->
            <div class="col-md-6">
                <h3 class="mb-3"><%= productName %></h3>
                <div class="mb-3">
                    <span class="h6 me-2">Product Details</span><br>
                    <div>Status: <button class="btn btn-success btn-sm">Available</button></div>
                    <div>Category: <%= category %></div>
                    <div>Policy: 7 Days Replacement and Return</div>
                </div>
                <div class="mb-3">
                    <span class="h4 me-2">Rs.<%= discountedPrice %></span> 
                    <span class="text-muted"><s>Rs. <%= originalPrice %></s></span>
                </div>
                <div class="mb-3">
                    <i class="bi bi-star-fill text-warning"></i>
                    <i class="bi bi-star-fill text-warning"></i>
                    <i class="bi bi-star-fill text-warning"></i>
                    <i class="bi bi-star-fill text-warning"></i>
                    <i class="bi bi-star-half text-warning"></i>
                    <span class="ms-2">4.5 (120 reviews)</span>
                </div>
                <p class="mb-4"><%= productDescription %></p>

                <a href="addToCart.jsp?productId=<%= productId %>" class="btn btn-primary btn-lg mb-3 me-2">
                        <i class="bi bi-cart-plus"></i> Add to Cart
                </a>
                <a href="buyNow.jsp?productId=<%= productId %>" class="btn btn-success btn-lg mb-3">
                        Buy Now
                </a>
            </div>
            <% 
                } else {
                    out.println("<p class='text-danger text-center'>Product not found.</p>");
                }
                rs.close();
                stmt.close();
            %>
        </div>
    </div>

    <%
        String userIdStr = (String) session.getAttribute("userId");
        Integer userId = (userIdStr != null) ? Integer.parseInt(userIdStr) : null;
    %>

    <div class="container mt-5">
        <h3>Leave a Review</h3>

        <% if (userId != null) { %>
            <form action="submitReview.jsp" method="post">
                <input type="hidden" name="productId" value="<%= productId %>">
                <input type="hidden" name="userId" value="<%= userId %>">

                <div class="mb-3">
                    <label class="form-label">Your Rating:</label>
                    <select name="rating" class="form-select" required>
                        <option value="5">⭐⭐⭐⭐⭐ (5 Stars)</option>
                        <option value="4">⭐⭐⭐⭐ (4 Stars)</option>
                        <option value="3">⭐⭐⭐ (3 Stars)</option>
                        <option value="2">⭐⭐ (2 Stars)</option>
                        <option value="1">⭐ (1 Star)</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Your Review:</label>
                    <textarea name="comment" class="form-control" rows="3" required></textarea>
                </div>

                <button type="submit" class="btn btn-primary">Submit Review</button>
            </form>
        <% } else { %>
            <p class="text-danger">You must be logged in to leave a review.</p>
        <% } %>
    </div>

    <div class="container mt-4">
        <h3>Customer Reviews</h3>
        <div class="row">
            <%
                String reviewQuery = "SELECT r.id, r.rating, r.comment, r.user_id, u.username FROM reviews r JOIN users u ON r.user_id = u.id WHERE r.product_id = ? ORDER BY r.created_at DESC";
                PreparedStatement reviewStmt = conn.prepareStatement(reviewQuery);
                reviewStmt.setInt(1, Integer.parseInt(productId));
                ResultSet reviewRs = reviewStmt.executeQuery();

                boolean hasReviews = false;
                while (reviewRs.next()) {
                    hasReviews = true;
                    int reviewId = reviewRs.getInt("id");
                    int rating = reviewRs.getInt("rating");
                    String comment = reviewRs.getString("comment");
                    int reviewUserId = reviewRs.getInt("user_id");
                    String username = reviewRs.getString("username");
            %>

            <div class="col-md-4 mb-3">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title"><%= username %></h5>
                        <p>
                            <% for (int i = 0; i < rating; i++) { %>
                                <i class="bi bi-star-fill text-warning"></i>
                            <% } %>
                        </p>
                        <p class="card-text"><%= comment %></p>

                        <% if (userId != null && userId.equals(reviewUserId)) { %>
                            <form action="deleteReview.jsp" method="post">
                                <input type="hidden" name="reviewId" value="<%= reviewId %>">
                                <input type="hidden" name="productId" value="<%= productId %>">
                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                            </form>
                        <% } %>
                    </div>
                </div>
            </div>

            <% 
                }
                if (!hasReviews) {
                    out.println("<p class='text-muted'>No reviews yet.</p>");
                }
                reviewRs.close();
                reviewStmt.close();
            %>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
