<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    // Get session to check if user is logged in
    HttpSession userSession = request.getSession();
    String userId = (String) userSession.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return;
    }

    // Get productId from request parameter
    String productId = request.getParameter("productId");

    if (productId == null) {
        out.println("<p class='text-danger text-center'>Product ID is missing.</p>");
        return;
    }

    // Database connection
    conn = (Connection) application.getAttribute("DBConnection");

    if (conn == null) {
        out.println("<p class='text-danger text-center'>Database connection failed.</p>");
        return;
    }

    try {
        // Retrieve product details from the database
        String productQuery = "SELECT title, price FROM product WHERE id = ?";
        PreparedStatement productStmt = conn.prepareStatement(productQuery);
        productStmt.setInt(1, Integer.parseInt(productId));
        ResultSet productRs = productStmt.executeQuery();

        if (!productRs.next()) {
            out.println("<p class='text-danger text-center'>Product not found.</p>");
            return;
        }

        String productName = productRs.getString("title");
        double price = productRs.getDouble("price");

        productRs.close();
        productStmt.close();

        // Check if the product is already in the cart for this user
        String checkQuery = "SELECT quantity FROM cart WHERE user_id = ? AND product_id = ?";
        PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
        checkStmt.setInt(1, Integer.parseInt(userId));
        checkStmt.setInt(2, Integer.parseInt(productId));
        ResultSet rs = checkStmt.executeQuery();

        if (rs.next()) {
            // Product already in cart, update quantity
            int currentQuantity = rs.getInt("quantity");
            String updateQuery = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
            updateStmt.setInt(1, currentQuantity + 1);
            updateStmt.setInt(2, Integer.parseInt(userId));
            updateStmt.setInt(3, Integer.parseInt(productId));
            updateStmt.executeUpdate();
            updateStmt.close();
        } else {
            // Product not in cart, insert new record
            String insertQuery = "INSERT INTO cart (user_id, product_id, product_name, price, quantity) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
            insertStmt.setInt(1, Integer.parseInt(userId));
            insertStmt.setInt(2, Integer.parseInt(productId));
            insertStmt.setString(3, productName);
            insertStmt.setDouble(4, price);
            insertStmt.setInt(5, 1);
            insertStmt.executeUpdate();
            insertStmt.close();
        }

        rs.close();
        checkStmt.close();
        response.sendRedirect("cart.jsp");

    } catch (SQLException e) {
        out.println("<p class='text-danger text-center'>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
%>
