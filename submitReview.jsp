<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    String productId = request.getParameter("productId");
    String userId = request.getParameter("userId");
    String rating = request.getParameter("rating");
    String comment = request.getParameter("comment");

    if (productId != null && userId != null && rating != null && comment != null) {
        try {
            String insertQuery = "INSERT INTO reviews (product_id, user_id, rating, comment) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(insertQuery);
            pstmt.setInt(1, Integer.parseInt(productId));
            pstmt.setInt(2, Integer.parseInt(userId));
            pstmt.setInt(3, Integer.parseInt(rating));
            pstmt.setString(4, comment);

            int rowsInserted = pstmt.executeUpdate();
            pstmt.close();

            if (rowsInserted > 0) {
                response.sendRedirect("productDetails.jsp?productId=" + productId + "&success=1");
            } else {
                response.sendRedirect("productDetails.jsp?productId=" + productId + "&error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("productDetails.jsp?productId=" + productId + "&error=1");
        }
    } else {
        response.sendRedirect("productDetails.jsp?productId=" + productId + "&error=1");
    }
%>
