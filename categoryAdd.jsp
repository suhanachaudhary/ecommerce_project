<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.annotation.*" %>
<%@ page import="jakarta.servlet.http.Part, java.nio.file.*, java.io.File, java.util.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null || adminSession.getAttribute("admin") == null) {
        response.sendRedirect("admin.jsp");
        return;
    }
%>

<%
    try {
        String title = request.getParameter("title");
        

        // Database connection and insertion
        conn = (Connection) application.getAttribute("DBConnection");
        PreparedStatement pst = conn.prepareStatement("insert into category (title,image) VALUES (?, ?)");

        pst.setString(1, title);
        pst.setString(2, "./images/book1.jpeg"); // Save the file path in the database

        int rows = pst.executeUpdate();
        if (rows > 0) {
            response.sendRedirect("category.jsp");
        } else {
            out.println("Unable to add product.");
        }

        pst.close();

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
