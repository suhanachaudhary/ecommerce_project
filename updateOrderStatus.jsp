<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    int orderId = Integer.parseInt(request.getParameter("order_id"));
    String newStatus = request.getParameter("status");

    conn = (Connection) application.getAttribute("DBConnection");

    if (conn != null) {
        // Update the order status in the orders table
        String updateOrderStatusQuery = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        PreparedStatement orderStmt = conn.prepareStatement(updateOrderStatusQuery);
        orderStmt.setString(1, newStatus);
        orderStmt.setInt(2, orderId);

        int rowsUpdated = orderStmt.executeUpdate();

        if (rowsUpdated > 0) {
            // Check if the new status is "Order Received"
            if ("Order Received".equalsIgnoreCase(newStatus)) {
                // Update the payment status to "Completed"
                String updatePaymentStatusQuery = "UPDATE payments SET payment_status = 'Completed' WHERE order_id = ?";
                PreparedStatement paymentStmt = conn.prepareStatement(updatePaymentStatusQuery);
                paymentStmt.setInt(1, orderId);
                paymentStmt.executeUpdate();
                paymentStmt.close();
            }
            orderStmt.close();
            response.sendRedirect("customerOrder.jsp");
        } else {
            out.println("<script>alert('Failed to update order status!'); window.location='orders.jsp';</script>");
        }
    } else {
        out.println("<script>alert('Database connection error!'); window.location='orders.jsp';</script>");
    }
%>
