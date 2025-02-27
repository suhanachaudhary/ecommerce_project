<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    HttpSession userSession = request.getSession();
    String userId = (String) userSession.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String productId = request.getParameter("productId"); // Get productId from request

    if (productId == null || productId.isEmpty()) {
        out.println("<script>alert('Invalid request. Product ID is missing.'); window.location='buyNow.jsp';</script>");
        return;
    }

    String userName = "", userAddress = "", userState = "", userCity = "", userPin = "", userPhone = "";

    try {
        PreparedStatement userStmt = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
        userStmt.setInt(1, Integer.parseInt(userId));
        ResultSet userRs = userStmt.executeQuery();
        
        if (userRs.next()) {
            userName = userRs.getString("username");
            userAddress = userRs.getString("address");
            userState = userRs.getString("state");
            userCity = userRs.getString("city");
            userPin = userRs.getString("pincode");
            userPhone = userRs.getString("contact");
        }
        
        userRs.close();
        userStmt.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String newAddress = request.getParameter("address");
        String newCity = request.getParameter("city");
        String newState = request.getParameter("state");
        String newPin = request.getParameter("pincode");

        if (newAddress != null && newCity != null && newState != null && newPin != null) {
            try {
                PreparedStatement updateStmt = conn.prepareStatement("UPDATE users SET address = ?, city = ?, state = ?, pincode = ? WHERE id = ?");
                updateStmt.setString(1, newAddress);
                updateStmt.setString(2, newCity);
                updateStmt.setString(3, newState);
                updateStmt.setString(4, newPin);
                updateStmt.setInt(5, Integer.parseInt(userId));
                updateStmt.executeUpdate();
                updateStmt.close();
                
                // Redirect back to buyNow.jsp with productId
                response.sendRedirect("buyNow.jsp?productId=" + productId);
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Address</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="container mt-4">
        <h2 class="text-center mb-4">Change Shipping Address</h2>
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-lg p-4">
                    <form action="changeAddress.jsp?productId=<%= productId %>" method="post">
                        <input type="hidden" name="productId" value="<%= productId %>">

                        <div class="mb-3">
                            <label for="address" class="form-label">New Address</label>
                            <textarea class="form-control" id="address" name="address" rows="2" required><%= userAddress %></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="city" class="form-label">City</label>
                            <input type="text" class="form-control" id="city" name="city" value="<%= userCity %>" required>
                        </div>
                        <div class="mb-3">
                            <label for="state" class="form-label">State</label>
                            <input type="text" class="form-control" id="state" name="state" value="<%= userState %>" required>
                        </div>
                        <div class="mb-3">
                            <label for="pincode" class="form-label">Pincode</label>
                            <input type="text" class="form-control" id="pincode" name="pincode" value="<%= userPin %>" required>
                        </div>

                        <button type="submit" class="btn btn-primary w-100">Update Address</button>
                        <a href="buyNow.jsp?productId=<%= productId %>" class="btn btn-secondary w-100 mt-2">Cancel</a>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
