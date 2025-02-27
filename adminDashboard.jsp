<%@ page import="java.io.*, jakarta.servlet.*, jakarta.servlet.http.*" %>
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
    <title>Admin Dashboard</title>
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
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"
      integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg=="
      crossorigin="anonymous"
      referrerpolicy="no-referrer"
    />

    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>

    <link rel="stylesheet" href="style.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <h4 style="text-align: center;color:#3d3d3d;
    margin-top: 30px;margin-bottom: 50px;">Admin Dashboard</h4>
    <div class="dashboard container" style="text-align: center;">

        <a href="addProduct.jsp">
            <div class="box">
                <i class="fa-solid fa-square-plus" style="color: #008ad8;font-size: 2rem;margin-top: 8px;"></i>
                <h5>Add Product</h5>
                <div class="line"></div>
            </div>
        </a>

        <a href="category.jsp">
            <div class="box">
                <i class="fa-sharp fa-solid fa-arrow-right-to-bracket" style="color: #008ad8;font-size: 2rem;margin-top: 8px;"></i>
                <h5>Category</h5>
                <div class="line"></div>
            </div>
        </a>
        <a href="viewProduct.jsp">
            <div class="box">
                <i class="fa-sharp fa-solid fa-note-sticky" style="color: #ff0000;font-size: 2rem;margin-top: 8px;"></i>
                <h5>View Product</h5>
                <div class="line"></div>
            </div>
        </a>
        <a href="customerOrder.jsp">
            <div class="box">
                <i class="fa-sharp fa-solid fa-box-open" style="color: #FFD43B;font-size: 2rem;margin-top: 8px;"></i>
                <h5>Orders</h5>
                <div class="line"></div>
            </div>
        </a>
        <a href="userDetails.jsp">
            <div class="box">
                <i class="fa-solid fa-user" style="color: #008ad8;font-size: 2rem;margin-top: 8px;"></i>
                <h5>User</h5>
                <div class="line"></div>
            </div>
        </a>
        <a href="addAdmin.jsp">
            <div class="box">
                <i class="fa-solid fa-users" style="color: #008ad8;font-size: 2rem;margin-top: 8px;"></i>
                <h5>Add Admin</h5>
                <div class="line"></div>
            </div>
        </a>
    </div>
    <div id="toast"></div>
    <!-- showToast("Item added to cart"); -->
    <script src="app.js"></script>
    <jsp:include page="footer.jsp" />
</body>
</html>