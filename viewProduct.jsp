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
    <title>View Product Details</title>
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
    <%
        conn = (Connection) application.getAttribute("DBConnection");
        int totalProduct = 0;
        if (conn != null) {
            try (PreparedStatement countStmt = conn.prepareStatement("SELECT COUNT(*) FROM product");
                 ResultSet countRs = countStmt.executeQuery()) {
                if (countRs.next()) {
                    totalProduct = countRs.getInt(1);
                }
            }
        }
    %>

    <button class="btn btn-warning col-12 py-3 px-3">
        <h3>Total Product <span class="badge bg-secondary"><%= totalProduct %></span></h3>
    </button>
    <div class="user_details" style="background-color: #E7F0DC; text-align: center; height: 80px; padding-top: 20px;">
        <h3>View Product</h3>
    </div>

    <table class="table table-striped table-hover table-bordered">
        <thead class="table-dark">
            <tr>
                <th scope="col">Image</th>
                <th scope="col">Title</th>
                <th scope="col">Stock</th>
                <th scope="col">Category</th>
                <th scope="col">Original Price</th>
                <th scope="col">Discount</th>
                <th scope="col">Discount Price</th>
                <th scope="col">Action</th>
            </tr>
        </thead>
        <tbody>
            <%
                try {
                    conn = (Connection) application.getAttribute("DBConnection");
                    if (conn == null) {
                        out.println("<tr><td colspan='8'>Database connection error!</td></tr>");
                    } else {
                        PreparedStatement pst = conn.prepareStatement("SELECT * FROM product");
                        ResultSet rs = pst.executeQuery();

                        while (rs.next()) {
                            double price = rs.getDouble("price");
                            double discount = rs.getDouble("discount");
                            double discountedPrice = price - (price * (discount / 100));
                            String imagePath = rs.getString("image");
            %>
                            <tr>
                                <td class="text-center">
                                    <img src="<%= imagePath %>" alt="productImg" class="" width="50" height="50">
                                </td>
                                <td><%= rs.getString("title") %></td>
                                <td><%= rs.getString("stock") %></td>
                                <td><%= rs.getString("category") %></td>
                                <td><%= price %></td>
                                <td><%= discount %>%</td>
                                <td><%= discountedPrice %></td>
                                <td class="text-center">
                                    <a href="editProduct.jsp?id=<%= rs.getInt("id") %>" class="btn btn-primary">Edit</a>
                                    <a href="deleteProduct.jsp?id=<%= rs.getInt("id") %>" class="btn btn-danger">Delete</a>
                                    <a href="adminDiscount.jsp?id=<%= rs.getInt("id") %>" class="btn btn-primary">Discount</a>
                                </td>
                            </tr>
            <%
                        }
                        rs.close();
                        pst.close();
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </tbody>
    </table>

    <jsp:include page="footer.jsp" />
</body>
</html>
