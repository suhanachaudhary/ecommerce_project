<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    HttpSession userSession = request.getSession();
    String userId = (String) userSession.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userIDInt = Integer.parseInt(userId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="container mt-4">
        <h2 class="text-center mb-4">Shopping Cart</h2>

        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Product Image</th>
                    <th>Product Name</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total Price</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <%
                boolean isCartEmpty = true;
                try {
                    String query = "SELECT cart.id, cart.product_id, product.title,product.image, product.price, cart.quantity " +
                                   "FROM cart " +
                                   "JOIN product ON cart.product_id = product.id " +
                                   "WHERE cart.user_id = ?";
                    PreparedStatement stmt = conn.prepareStatement(query);
                    stmt.setInt(1, userIDInt);
                    ResultSet rs = stmt.executeQuery();

                    while (rs.next()) {
                        isCartEmpty = false;
                        int productId = rs.getInt("product_id");
                        int quantity = rs.getInt("quantity");
                        int totalPrice = rs.getInt("price") * quantity;
                        String productImage=rs.getString("image");
            %>
                        <tr>
                            <td><img src="<%= productImage %>" alt="Product Image" width="100" height="100" class="mt-2"></td>
                            <td><%= rs.getString("title") %></td>
                            <td>Rs. <%= rs.getInt("price") %></td>
                            <td>
                                <form action="updateCart.jsp" method="post" class="d-inline">
                                    <input type="hidden" name="productId" value="<%= productId %>">
                                    <input type="number" name="quantity" value="<%= quantity %>" min="1">
                                    <button type="submit" class="btn btn-sm btn-success">Update</button>
                                </form>
                            </td>
                            <td>Rs. <%= totalPrice %> </td>
                            <td><a href="removeFromCart.jsp?productId=<%= productId %>" class="btn btn-sm btn-danger">Remove</a></td>
                        </tr>
            <%
                    }
                    rs.close();
                    stmt.close();

                    if (isCartEmpty) {
                        out.println("<tr><td colspan='6' class='text-center text-danger'>Your cart is empty.</td></tr>");
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                    e.printStackTrace();
                }
            %>
            </tbody>
        </table>

        <div class="text-center">
            <a href="product.jsp" class="btn btn-secondary">Continue Shopping</a>
            <% if (!isCartEmpty) { %>
                <a href="checkout.jsp" class="btn btn-success">Proceed to Checkout</a>
            <% } %>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
