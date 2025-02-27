<%@ page import="java.sql.*, java.io.*,jakarta.servlet.*, jakarta.servlet.http.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null || adminSession.getAttribute("admin") == null) {
        response.sendRedirect("admin.jsp");
        return;
    }
%>

<%
    conn = (Connection) application.getAttribute("DBConnection");

    if (conn == null) {
        out.println("Database connection error!");
        return;
    }

    String id = request.getParameter("id");

    // Validate if 'id' is provided
    if (id == null || id.trim().isEmpty()) {
        out.println("Error: Invalid request - ID is missing.");
        return;
    }

    try {
        // Prepare DELETE query
        String query = "DELETE FROM users WHERE id=?";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setInt(1, Integer.parseInt(id));  
        int rowsAffected = stmt.executeUpdate();
        stmt.close();

        if (rowsAffected > 0) {
            response.sendRedirect("userDetails.jsp");
        } else {
            out.println("Error: Category not found.");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
