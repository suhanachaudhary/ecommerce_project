<%@ page import="java.sql.*, java.io.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="dbconnect.jsp" %>


<%
    String orderId = request.getParameter("order_id");
    int order_id = 0;
    int productId = 0;
    String totalAmount = "";
    String orderDate = "";
    String status = "";
    String productImage = "";

    if (orderId == null || orderId.trim().isEmpty()) {
        response.sendRedirect("orders.jsp?error=missing");
        return;
    }

    try {
        order_id = Integer.parseInt(orderId);

        PreparedStatement ps = conn.prepareStatement("SELECT * FROM orders WHERE order_id = ?");
        ps.setInt(1, order_id);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            totalAmount = rs.getString("price");
            orderDate = rs.getString("order_date");
            status = rs.getString("order_status");
            productId = rs.getInt("product_id");
        } else {
            response.sendRedirect("orders.jsp?error=notfound");
            return;
        }


        rs.close();
        ps.close();

        // Fetch product image
        PreparedStatement ps1 = conn.prepareStatement("SELECT image FROM product WHERE id = ?");
        ps1.setInt(1, productId);
        ResultSet rs1 = ps1.executeQuery();

        if (rs1.next()) {
            productImage = rs1.getString("image");
        }

        rs1.close();
        ps1.close();


    } catch (NumberFormatException e) {
        response.sendRedirect("orders.jsp?error=invalid");
        return;
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>View Order</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="container mt-5" style="text-align: center; margin: auto; margin-bottom: 100px;">
        <h1 class="mt-5">Order Details</h1>
        <h4>Your order details are shown below:</h4>

        <div class="table-responsive">
            <table class="table table-bordered table-striped text-center">
                <thead class="table-dark">
                    <tr>
                        <td>Product Image</td>
                        <th>Order ID</th>
                        <th>Total Amount</th>
                        <th>Order Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><img src="<%= productImage %>" alt="Product Image" width="100" height="100" class="mt-2"></td>
                        <td><%= order_id %></td>
                        <td>₹ <%= totalAmount %></td>
                        <td><%= orderDate %></td>
                        <% if (status != null && !status.isEmpty()) { %>
                            <td><%= status %></td>
                            <% } else { %>
                                <td>Pending</td> 
                        <% } %>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="thank mt-3">
            <a href="Home.jsp" class="btn btn-danger">Home</a>
            <a href="orders.jsp" class="btn btn-primary">View All Orders</a>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
