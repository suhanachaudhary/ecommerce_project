<%@ include file="dbconnect.jsp" %>
<%@ page import="java.sql.*,java.io.*, jakarta.servlet.*, jakarta.servlet.http.*" %>
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
    <title>Add Product</title>
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
    <div class="container addProduct">
        <div class="productHeading"><h4>Add Product</h4></div>

        <form action="AddProductServlet" method="post" enctype="multipart/form-data" >
            <div class="mb-3">
                <label for="title" class="form-label">Enter Title</label>
                <input type="text" class="form-control" id="title" name="title">
              </div>
              <div class="mb-3">
                <label for="desc" class="form-label">Enter Description</label>
                <textarea class="form-control" id="desc" rows="3" name="description"></textarea>
              </div>
              <div class="mb-3">
                <label for="inputState" class="form-label">Category</label>
                <select id="inputState" class="form-select" name="category">
                  <option selected>Choose...</option>
                  <option value="Electronics">Electronics</option>
                  <option value="Laptop">Laptop</option>
                  <option value="Fashion">Fashion</option>
                  <option value="Beauty Product">Beauty Product</option>
                  <option value="Phone">Phone</option>
                  <option value="Books">Books</option>
                </select>
              </div>
              <div class="mb-3">
                <label for="price class="form-label">Enter Price</label>
                <input type="number" class="form-control" id="price" name="price" placeholder="Item Price">
              </div>

              <div class="row">
                <div class="col-md-6">
                    <label for="inpu" class="form-label">Stock</label>
                    <input type="text" class="form-control" name="stock" id="inpu">
                </div>
                <div class="col-md-6">
                    <label for="image" class="form-label">Image</label>
                    <input type="file" class="form-control" name="image" id="image">
                </div>
            </div>
            <br>
            <div class="row m-3">
                <button class="btn btn-primary">Add</button>
            </div>
        </form>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>