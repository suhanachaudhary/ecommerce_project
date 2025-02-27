<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,java.io.*,jakarta.servlet.*, jakarta.servlet.http.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null || adminSession.getAttribute("admin") == null) {
        response.sendRedirect("admin.jsp");
        return;
    }
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Category</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="category">
        <%
            conn = (Connection) application.getAttribute("DBConnection");
            String id = request.getParameter("id");
            if (conn != null && id != null) {
                String query = "SELECT title, image FROM category WHERE id = ?";
                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setInt(1, Integer.parseInt(id));
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    String categoryName = rs.getString("title");
                    String image=rs.getString("image");
                    
        %>
        <div class="left">
            <div class="card mt-3" style="width: 24rem;">
                <div class="card-header text-center">
                    Edit Category
                </div>
                <div class="card-body">
                    <form id="registrationForm" action="EditCategoryServlet" method="post" enctype="multipart/form-data" >
                        <input type="hidden" name="id" value="<%= id %>">
                        <div class="form-group mb-3">
                            <label for="text">Title</label>
                            <input type="text" class="form-control" id="text" name="title" value="<%=categoryName%>" required />
                        </div>
                        <div class="form-group">
                            <label for="img">Image</label>
                            <input type="file" class="form-control" id="img" name="image"/>

                            <img src="<%= image %>" alt="Category Image" width="80" height="80" class="mt-2">
                        </div><br>
                        <button class="mb-3 form-control btn btn-primary">Update</button>
                    </form>
                </div>
            </div>
        </div>
        <%
                } else {
                    out.println("<p>Category not found!</p>");
                }
                rs.close();
                stmt.close();
            } else {
                out.println("<p>Database connection error or invalid ID!</p>");
            }
        %>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>
