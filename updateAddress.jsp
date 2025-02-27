<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    // Get user ID from session
    HttpSession userSession = request.getSession();
    String userId = (String) userSession.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int user_id = Integer.parseInt(userId);
    String newAddress = request.getParameter("address");
    String newCity = request.getParameter("city");
    String newState = request.getParameter("state");
    String newPin = request.getParameter("pincode");

    try {
        // Update the user address in the database
        PreparedStatement updateStmt = conn.prepareStatement(
            "UPDATE users SET address = ?, city = ?, state = ?, pincode = ? WHERE id = ?"
        );
        updateStmt.setString(1, newAddress);
        updateStmt.setString(2, newCity);
        updateStmt.setString(3, newState);
        updateStmt.setString(4, newPin);
        updateStmt.setInt(5, user_id);
        updateStmt.executeUpdate();
        updateStmt.close();

        // Redirect back to checkout page after update
        response.sendRedirect("checkout.jsp");
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
