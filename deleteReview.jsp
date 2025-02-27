<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    String reviewId = request.getParameter("reviewId");
    String userIdStr = (String) session.getAttribute("userId");

    if (reviewId != null && userIdStr != null) {
        int userId = Integer.parseInt(userIdStr);
        conn = (Connection) application.getAttribute("DBConnection");

        if (conn == null) {
            out.println("<p class='text-danger'>Database connection failed.</p>");
            return;
        }

        try {
            String deleteQuery = "DELETE FROM reviews WHERE id = ? AND user_id = ?";
            PreparedStatement deleteStmt = conn.prepareStatement(deleteQuery);
            deleteStmt.setInt(1, Integer.parseInt(reviewId));
            deleteStmt.setInt(2, userId);

            int rowsAffected = deleteStmt.executeUpdate();
            deleteStmt.close();

            if (rowsAffected > 0) {
                String productId = request.getParameter("productId");
                if (productId != null) {
                    response.sendRedirect("productDetails.jsp?productId=" + productId);
                } else {
                    out.println("<p class='text-danger'>Product ID missing, cannot redirect.</p>");
                }
            } else {
                out.println("<p class='text-danger'>Error deleting review or review not found.</p>");
            }
        } catch (SQLException e) {
            out.println("<p class='text-danger'>Error deleting review: " + e.getMessage() + "</p>");
        }
    } else {
        out.println("<p class='text-danger'>Unauthorized action: Review ID or User ID missing.</p>");
    }
%>
