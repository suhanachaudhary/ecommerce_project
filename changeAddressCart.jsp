<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    // Get user ID from session
    HttpSession userSession = request.getSession();
    String userId = (String) userSession.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int user_id = Integer.parseInt(userId);
    String userAddress = "", userCity = "", userState = "", userPin = "";

    try {
        PreparedStatement stmt = conn.prepareStatement("SELECT address, city, state, pincode FROM users WHERE id = ?");
        stmt.setInt(1, user_id);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            userAddress = rs.getString("address");
            userCity = rs.getString("city");
            userState = rs.getString("state");
            userPin = rs.getString("pincode");
        }

        rs.close();
        stmt.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (request.getMethod().equals("POST")) {
        String newAddress = request.getParameter("address");
        String newCity = request.getParameter("city");
        String newState = request.getParameter("state");
        String newPin = request.getParameter("pincode");

        try {
            PreparedStatement updateStmt = conn.prepareStatement(
                "UPDATE users SET address = ?, city = ?, state = ?, pincode = ? WHERE id = ?"
            );
            updateStmt.setString(1, newAddress);
            updateStmt.setString(2, newCity);
            updateStmt.setString(3, newState);
            updateStmt.setString(4, newPin);
            updateStmt.setInt(5, user_id);
            updateStmt.executeUpdate();
            updateStmt.close();

            // Redirect back to checkout.jsp after successful update
            response.sendRedirect("checkout.jsp");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Cart Address</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="container mt-5">
        <h2 class="text-center">Update Shipping Address</h2>
        
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-lg p-4">

                    <form action="updateAddress.jsp" method="post"> <!-- Updated action to a separate JSP file -->
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
                        <a href="checkout.jsp" class="btn btn-secondary w-100 mt-2">Cancel</a>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
