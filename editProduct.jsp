<%@ include file="dbconnect.jsp" %>

<%@ page import="java.sql.*, java.io.*,jakarta.servlet.*, jakarta.servlet.http.*" %>
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
    <title>Edit Product</title>
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

    <div class="container editProduct">
        <div class="productHeading text-center mt-3"><h4>Edit Product</h4></div>
        <%
            // Fetch product details based on the ID passed in the query string
            int productId = Integer.parseInt(request.getParameter("id"));
            conn = (Connection) application.getAttribute("DBConnection");

            PreparedStatement pst = conn.prepareStatement("SELECT * FROM product WHERE id = ?");
            pst.setInt(1, productId);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) { 
                String image=rs.getString("image");
        %>
        <form action="EditProductServlet" method="post" enctype="multipart/form-data" >
            <!-- Pass product ID as a hidden input -->
            <input type="hidden" name="id" value="<%= productId %>">

            <div class="mb-3">
                <label for="title" class="form-label">Enter Title</label>
                <input type="text" class="form-control" id="title" name="title" value="<%= rs.getString("title") %>">
            </div>

            <div class="mb-3">
                <label for="desc" class="form-label">Enter Description</label>
                <textarea class="form-control" id="desc" rows="3" name="description"><%= rs.getString("description") %></textarea>
            </div>

            <div class="mb-3">
                <label for="inputState" class="form-label">Category</label>
                <input type="text" id="inputState" class="form-control" value="<%= rs.getString("category") %>" name="category">
            </div>

            <div class="mb-3">
                <label for="price" class="form-label">Enter Price</label>
                <input type="number" class="form-control" id="price" value="<%= rs.getDouble("price") %>" name="price" placeholder="Item Price">
            </div>

            <div class="row">
                <div class="col-md-6">
                    <label for="stock" class="form-label">Stock</label>
                    <input type="text" class="form-control" value="<%= rs.getString("stock") %>" name="stock" id="stock">
                </div>
                <div class="col-md-6">
                    <label for="image" class="form-label">Image</label>
                    <input type="file" class="form-control" name="image" id="image">
                    <img src="<%= image %>" alt="Category Image" width="100" height="100" class="mt-2">
                </div>
            </div>

            <br>
            <div class="row m-3">
                <button class="btn btn-success">Update Product</button>
            </div>
        </form>
        <%
            } else {
                out.println("<div class='alert alert-danger'>Product not found!</div>");
            }
            rs.close();
            pst.close();
        %>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
