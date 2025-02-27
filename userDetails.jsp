<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,java.io.*, jakarta.servlet.*, jakarta.servlet.http.*" %>
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
    <title>User Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0o7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <%
        conn = (Connection) application.getAttribute("DBConnection");
        int totalUsers = 0;
        if (conn != null) {
            try (PreparedStatement countStmt = conn.prepareStatement("SELECT COUNT(*) FROM users");
                 ResultSet countRs = countStmt.executeQuery()) {
                if (countRs.next()) {
                    totalUsers = countRs.getInt(1);
                }
            }
        }
    %>

    <button class="btn btn-warning col-12 py-3 px-3">
        <h3>Total Users <span class="badge bg-secondary"><%= totalUsers %></span></h3>
    </button>

    <div class="user_details d-flex justify-content-center align-items-center" style="background-color: #E7F0DC; text-align: center; height: 80px; padding-top: 20px;">
        <h3>User Details</h3>
    </div>

    <table class="table table-striped table-hover table-bordered">
        <thead class="table-dark">
            <tr>
                <th scope="col">Images</th>
                <th scope="col">Full Name</th>
                <th scope="col">Email</th>
                <th scope="col">Contact</th>
                <th scope="col">Address</th>
                <th scope="col">Action</th>
            </tr>
        </thead>
        <tbody>
            <%
            if (conn != null) {
                String query = "SELECT * FROM users";
                try (PreparedStatement stmt = conn.prepareStatement(query);
                     ResultSet rs = stmt.executeQuery()) {
                    
                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String username = rs.getString("username");
                        String contact = rs.getString("contact");
                        String email = rs.getString("email");
                        String address = rs.getString("address");
                        String image = rs.getString("image");
            %>
                <tr>
                    <td class="text-center">
                        <img src="<%= image %>" alt="Profile Image" class="rounded-circle" width="50" height="50">
                    </td>
                    <td><%= username %></td>
                    <td><%= email %></td>
                    <td><%= contact %></td>
                    <td><%= address %></td>
                    <td class="text-center">
                        <a href="deleteUser.jsp?id=<%= id %>" class="btn btn-danger btn-sm">Delete</a>
                    </td>
                </tr>
                <%
                    }
                }
            } else {
                out.println("<tr><td colspan='6' class='text-center text-danger'>Database connection error!</td></tr>");
            }
            %>
        </tbody>
    </table>

    <jsp:include page="footer.jsp" />
    
</body>
</html>
