<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    // Get the session and check if the user is logged in
    HttpSession userSession = request.getSession();
    String userId = (String) userSession.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return;
    }

    // Get productId and new quantity from the request
    String productId = request.getParameter("productId");
    String quantityStr = request.getParameter("quantity");

    if (productId != null && quantityStr != null) {
        int quantity = Integer.parseInt(quantityStr);

        // Ensure quantity is at least 1
        if (quantity < 1) {
            quantity = 1;
        }

        conn = (Connection) application.getAttribute("DBConnection");
        if (conn != null) {
            try {
                // Update the quantity in the cart table
                String updateQuery = "UPDATE cart SET quantity = ? WHERE product_id = ? AND user_id = ?";
                PreparedStatement stmt = conn.prepareStatement(updateQuery);
                stmt.setInt(1, quantity);
                stmt.setInt(2, Integer.parseInt(productId));
                stmt.setInt(3, Integer.parseInt(userId));

                int rowsAffected = stmt.executeUpdate();
                stmt.close();

                if (rowsAffected > 0) {
                    response.sendRedirect("cart.jsp?success=Quantity updated successfully");
                } else {
                    response.sendRedirect("cart.jsp?error=Failed to update quantity");
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("cart.jsp?error=Database error");
            }
        } else {
            response.sendRedirect("cart.jsp?error=Database connection failed");
        }
    } else {
        response.sendRedirect("cart.jsp?error=Invalid request");
    }
%>
