<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,java.io.*, jakarta.servlet.*, jakarta.servlet.http.*" %>
<%@ include file="../dbconnect.jsp" %>

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
    <title>Add Category</title>
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
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="category">

      <%
        conn = (Connection) application.getAttribute("DBConnection");
        int totalCategory = 0;
        if (conn != null) {
            try (PreparedStatement countStmt = conn.prepareStatement("SELECT COUNT(*) FROM category");
                 ResultSet countRs = countStmt.executeQuery()) {
                if (countRs.next()) {
                    totalCategory = countRs.getInt(1);
                }
            }
        }
    %>

    <button class="btn btn-warning col-12 py-3 px-3">
        <h3>Total Category <span class="badge bg-secondary"><%= totalCategory %></span></h3>
    </button>

      <div class="left">
        <h3 class="text-center mt-3">Add New Category</h3>

        <div class="card mt-3" style="width: 24rem;border-radius: 2px 2px 2px #E7F0DC !important;">
          <div class="card-header text-center">
            Category Add
          </div>
          <div class="card-body">
            <form id="registrationForm" action="AddCategoryServlet" method="post" enctype="multipart/form-data" >
              <div class="form-group mb-3">
                  <label for="text">
                      Title
                  </label>
                  <input type="text" 
                         class="form-control" 
                         id="text" name="title" 
                         required />
              </div>
              <div class="form-group">
                  <label for="img">
                    Image
                  </label>
                  <input type="file" 
                         class="form-control" 
                         id="img" name="image"/>
              </div><br>
              <button class="mb-3 form-control btn btn-primary">
                  Add
              </button>
          </form>
          </div>
        </div>
      </div>

      <div class="right mt-3" style="width: 33rem;">
        <div class="user_details" style="background-color: #E7F0DC;text-align: center;height: 80px;padding-top: 20px;">
          <h3>Category Details</h3>
      </div>
  
      <table class="table table-striped table-hover table-bordered">
          <thead class="table-dark">
              <tr>
                  <th scope="col">Category Name</th>
                  <th scope="col">Image</th>
                  <th scope="col">Action</th>
              </tr>
          </thead>
          <tbody>
            <%
            conn = (Connection) application.getAttribute("DBConnection");
            if (conn != null) {
                String query = "select * FROM category";
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery();
                
                while (rs.next()) {
                    String categoryName = rs.getString("title");
                    String imagePath = rs.getString("image");
            %>
                  <tr>
                    <td><%= categoryName %></td>
                      <td class="text-center">
                          <img src="<%= imagePath %>" alt="Profile Image" class="" width="80" height="80">
                      </td>
                      <td class="text-center">
                        <a href="editCategory.jsp?id=<%= rs.getInt("id") %>" class="btn btn-primary btn-sm">Edit</a>
                          <a href="deleteCategory.jsp?id=<%= rs.getInt("id") %>" class="btn btn-danger btn-sm">Delete</a>
                      </td>
                  </tr>
            
              <%
                }
                rs.close();
                stmt.close();
            } else {
                out.println("<tr><td colspan='3'>Database connection error!</td></tr>");
            }
        %>
          </tbody>
      </table>
  
      </div>

    </div>
    <jsp:include page="footer.jsp" /> 
</body>
</html>