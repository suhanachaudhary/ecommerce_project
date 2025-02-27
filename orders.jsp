<%@ page import="java.sql.*, java.io.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="dbconnect.jsp" %>

<%
    HttpSession userSession = request.getSession();
    String userId = (String) userSession.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int user_id = Integer.parseInt(userId);

    conn = (Connection) application.getAttribute("DBConnection");
    if (conn == null) {
        out.println("Database connection is not initialized.");
        return;
    }

    // Fetch orders along with product images
    PreparedStatement ps = conn.prepareStatement(
        "SELECT o.order_id, o.price, o.order_date, p.image " + 
        "FROM orders o " + 
        "JOIN product p ON o.product_id = p.id " +
        "WHERE o.userid = ? ORDER BY o.order_date DESC"
    );
    ps.setInt(1, user_id);
    ResultSet rs = ps.executeQuery();

    // Check if orders exist before fetching data
    if (!rs.isBeforeFirst()) {
%>
        <p class="text-center text-danger">You have not placed any orders yet.</p>
<%
    } else {
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Orders</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="container mt-5" style="margin-bottom: 100px;">
        <h1 class="text-center">My Orders</h1>

        <div class="table-responsive">
            <table class="table table-bordered table-striped text-center">
                <thead class="table-dark">
                    <tr>
                        <th>Product Image</th>
                        <th>Order ID</th>
                        <th>Total Amount</th>
                        <th>Order Date</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        while (rs.next()) {
                    %>
                    <tr>
                        <td><img src="<%= rs.getString("image") %>" alt="Product Image" width="100" height="100" class="mt-2"></td>
                        <td><%= rs.getInt("order_id") %></td>
                        <td>₹ <%= rs.getString("price") %></td>
                        <td><%= rs.getString("order_date") %></td>
                        <td>
                            <a href="viewOrder.jsp?order_id=<%= rs.getInt("order_id") %>" class="btn btn-info">View</a>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="text-center mt-3">
        <a href="Home.jsp" class="btn btn-danger">Home</a>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>

<%
    } // End of if condition
    rs.close();
    ps.close();
%>
