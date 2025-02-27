<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="dbconnect.jsp" %>


<html>
<head>
    <title>Set Product Discount</title>
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

    <link rel="stylesheet" href="style.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="container d-flex justify-content-center">
    <div class="card col-6 px-3 py-3 mt-3 mb-5">

    <h2 class="text-center">Set Discount for Products</h2>
    <%
        int productId = Integer.parseInt(request.getParameter("id"));
    %>

    <form action="setDiscount.jsp" method="post">
        <input type="hidden" name="id" value="<%= productId %>"><br><br>

        <div class="form-group">
            <label for="dis">
                Discount
            </label>
            <input type="text" 
                   class="form-control" 
                   id="dis" name="discount" 
                   placeholder="10-20%"
                required />
        </div><br>
        <button class="mb-3 form-control btn btn-primary">
            Set Discount
        </button>

    </form>
    </div>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>
