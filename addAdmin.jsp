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
    <title>Admin Page</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
      crossorigin="anonymous"
    />
    <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
      crossorigin="anonymous"
    ></script>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <%
        conn = (Connection) application.getAttribute("DBConnection");
        int totalAdmin = 0;
        if (conn != null) {
            try (PreparedStatement countStmt = conn.prepareStatement("SELECT COUNT(*) FROM admins");
                 ResultSet countRs = countStmt.executeQuery()) {
                if (countRs.next()) {
                    totalAdmin = countRs.getInt(1);
                }
            }
        }
    %>

    <button class="btn btn-warning col-12 py-3 px-3">
        <h3>Total Admin <span class="badge bg-secondary"><%= totalAdmin %></span></h3>
    </button>

    <div class="container align-item-center d-flex justify-content-center">
    <div class="card col-6 py-3 px-3 mt-3">
        <h4 class="text-center">Add New Admin</h4>
        <form action="addNewAdmin.jsp" class="adminform" method="post">
            <div class="mb-3">
                <label for="formG" class="form-label">Email Address</label>
                <input type="email" class="form-control" id="formG" name="email" required>
            </div>
            <div class="mb-3">
                <label for="formGr" class="form-label">Password</label>
                <input type="password" class="form-control" id="formGr" name="password" required>
            </div>
            <div class="mb-3">
                <button class="form-control btn btn-primary">Add</button>
            </div>
        </form>
    </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>