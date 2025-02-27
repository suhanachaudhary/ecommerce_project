<%@ page import="java.sql.*, java.io.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="dbconnect.jsp" %>

<%
    String orderId = request.getParameter("order_id");
    int order_id = 0;
    String totalAmount = "";
    String orderDate = "";

    if (orderId != null && !orderId.trim().isEmpty()) {
        try {
            order_id = Integer.parseInt(orderId);

            PreparedStatement ps = conn.prepareStatement("SELECT * FROM orders WHERE order_id = ?");
            ps.setInt(1, order_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalAmount = rs.getString("price");
                orderDate = rs.getString("order_date");
            }

        } catch (NumberFormatException e) {
            out.println("<p style='color:red;'>Invalid order ID format.</p>");
        } catch (Exception e) {
            e.printStackTrace();
        }
    } else {
        out.println("<p style='color:red;'>Order ID is missing.</p>");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="container thankyou_page mt-5" style="text-align: center;margin: auto;margin-bottom:100px;">
        <h1 class="mt-5">Order Confirmation</h1>
        <h4>Thank you for your order! Your order details are as follows:</h4>
        <p>Within 7 Days your Product will be Delivered In your Address</p>
        <div class="table-responsive">
            <table class="table table-bordered table-striped text-center">
                <thead class="table-dark">
                    <tr>
                        <th>Order ID</th>
                        <th>Total Amount</th>
                        <th>Order Date</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><%= order_id %></td>
                        <td>₹ <%= totalAmount %></td>
                        <td><%= orderDate %></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <p class="text-center">You will receive a confirmation email shortly.</p>
        <div class="thank">
            <a href="Home.jsp" class="btn btn-danger">Home</a>
            <a href="viewOrder.jsp?order_id=<%= order_id %>" class="btn btn-primary">View Order</a>
        </div>
    </div>
    
    <jsp:include page="footer.jsp" />
</body>
</html>
