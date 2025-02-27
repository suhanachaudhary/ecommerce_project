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
    <title>Customer Orders</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <%
        conn = (Connection) application.getAttribute("DBConnection");
        int totalOrders = 0;
        
        if (conn != null) {
            String countQuery = "SELECT COUNT(*) FROM orders";
            PreparedStatement countStmt = conn.prepareStatement(countQuery);
            ResultSet countRs = countStmt.executeQuery();
            if (countRs.next()) {
                totalOrders = countRs.getInt(1);
            }
            countRs.close();
            countStmt.close();
        }
    %>

    <button class="btn btn-warning col-12 py-3 px-3">
        <h3>Total Orders <span class="badge bg-secondary"><%= totalOrders %></span></h3>
    </button>

    <div class="user_details" style="background-color: #E7F0DC;text-align: center;height: 80px;padding-top: 20px;">
        <h3>Customer Orders</h3>
    </div>

    <table class="table table-striped table-hover table-bordered">
        <thead class="table-dark">
            <tr>
                <th scope="col">Order Date</th>
                <th scope="col">Order Id</th>
                <th scope="col">User ID</th>
                <th scope="col">Product Name</th>
                <th scope="col">Quantity</th>
                <th scope="col">Total Price</th>
                <th scope="col">Payment Type</th>
                <th scope="col">Payment Status</th>
                <th scope="col">Order Status</th>
                <th scope="col">Action</th>
            </tr>
        </thead>
        <tbody>
            <%
            if (conn != null) {
                String query = "SELECT o.order_id,o.order_status, o.userid, o.product_name, o.quantity, o.total_price, o.order_date, p.payment_method, p.payment_status FROM orders o JOIN payments p ON o.order_id = p.order_id";
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    int orderId = rs.getInt("order_id");
                    int userId = rs.getInt("userid");
                    String productName = rs.getString("product_name");
                    int quantity = rs.getInt("quantity");
                    double totalPrice = rs.getDouble("total_price");
                    String orderDate = rs.getString("order_date");
                    String paymentType = rs.getString("payment_method");
                    String status = rs.getString("payment_status");
                    String orderstatus = rs.getString("order_status");
            %>
                <tr>
                    <td><%= orderDate %></td>
                    <td><%= orderId %></td>
                    <td><%= userId %></td>
                    <td><%= productName %></td>
                    <td><%= quantity %></td>
                    <td>Rs. <%= totalPrice %></td>
                    <td><%= paymentType %></td>
                    <td><%= status %></td>
                    <td><%= orderstatus %></td>
                    <td>
                        <form action="updateOrderStatus.jsp" method="post">
                            <input type="hidden" name="order_id" value="<%= orderId %>">
                            <select name="status" class="form-select">
                                <option selected><%= orderstatus %></option>
                                <option value="Order Packed">Order Packed</option>
                                <option value="Order Processing">Order Processing</option>
                                <option value="Out for Delivery">Out for Delivery</option>
                                <option value="Order Received">Order Received</option>
                            </select>
                            <button type="submit" class="btn btn-success mt-2">Update</button>
                        </form>
                    </td>
                </tr>
            <%
                }
                rs.close();
                stmt.close();
            } else {
                out.println("<tr><td colspan='9' class='text-center'>Database connection error!</td></tr>");
            }
            %>
        </tbody>
    </table>

    <jsp:include page="footer.jsp" />
</body>
</html>
