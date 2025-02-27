<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*,java.io.*,jakarta.servlet.*, jakarta.servlet.http.*" %>
<%@ include file="dbconnect.jsp" %>


<%
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null || adminSession.getAttribute("admin") == null) {
        response.sendRedirect("admin.jsp");
        return;
    }
%>

<html>
<head>
    <title>Set Product Discount</title>
</head>
<body>
    <%
        int productId = Integer.parseInt(request.getParameter("id"));
        double discount = Double.parseDouble(request.getParameter("discount"));

        conn = (Connection) application.getAttribute("DBConnection");
        PreparedStatement pst = conn.prepareStatement("UPDATE product SET discount=? WHERE id=?");

        pst.setDouble(1, discount);
        pst.setInt(2, productId);

        int rows = pst.executeUpdate();

        if (rows > 0) {
            response.sendRedirect("viewProduct.jsp");
        } else {
            out.println("Error: Could not update discount for product ID: " + productId);
        }

        pst.close();
    %>
</body>
</html>
