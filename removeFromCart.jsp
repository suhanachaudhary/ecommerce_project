<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    String productId = request.getParameter("productId");

    if (productId == null) {
        out.println("cartId empty");
        return;
    }  
    HttpSession userSession = request.getSession();
    String userId = (String) userSession.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp"); // Redirect if not logged in
        return;
    }
    if (conn != null) {
        try {
            String deleteQuery = "DELETE FROM cart WHERE product_id = ? AND user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(deleteQuery);
            stmt.setInt(1, Integer.parseInt(productId)); // Set the productId
            stmt.setInt(2, Integer.parseInt(userId));     // Set the userId
            stmt.executeUpdate(); // Execute the query
            stmt.close();

            // Redirect back to the cart page after deletion
            response.sendRedirect("cart.jsp");

        } catch (SQLException e) {
            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            e.printStackTrace();
        }
    } else {
        out.println("<div class='alert alert-danger'>Database connection failed.</div>");
    }
    %>
