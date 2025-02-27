<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, javax.mail.*, javax.mail.internet.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    String paymentId = request.getParameter("paymentId");
    String orderId = request.getParameter("orderId");

    // Update order status in the database
    String updateQuery = "UPDATE orders SET payment_id = ?, status = 'Paid' WHERE id = ?";
    PreparedStatement stmt = conn.prepareStatement(updateQuery);
    stmt.setString(1, paymentId);
    stmt.setString(2, orderId);
    stmt.executeUpdate();
    stmt.close();

    // Fetch user details
    String userQuery = "SELECT u.email, u.contact FROM users u JOIN orders o ON u.id = o.user_id WHERE o.id = ?";
    PreparedStatement userStmt = conn.prepareStatement(userQuery);
    userStmt.setString(1, orderId);
    ResultSet userRs = userStmt.executeQuery();

    String userEmail = "", userPhone = "";
    if (userRs.next()) {
        userEmail = userRs.getString("email");
        userPhone = userRs.getString("contact");
    }
    userRs.close();
    userStmt.close();

    // Send Confirmation Email
    String host = "smtp.gmail.com";
    String from = "your-email@gmail.com";
    String pass = "your-email-password";
    String subject = "Order Confirmation - Order #" + orderId;
    String messageBody = "Thank you for your purchase! Your order has been placed successfully.\n\nOrder ID: " + orderId + "\nPayment ID: " + paymentId;

    Properties props = System.getProperties();
    props.put("mail.smtp.starttls.enable", "true");
    props.put("mail.smtp.host", host);
    props.put("mail.smtp.user", from);
    props.put("mail.smtp.password", pass);
    props.put("mail.smtp.port", "587");
    props.put("mail.smtp.auth", "true");

    Session session = Session.getDefaultInstance(props);
    MimeMessage message = new MimeMessage(session);
    message.setFrom(new InternetAddress(from));
    message.addRecipient(Message.RecipientType.TO, new InternetAddress(userEmail));
    message.setSubject(subject);
    message.setText(messageBody);

    Transport transport = session.getTransport("smtp");
    transport.connect(host, from, pass);
    transport.sendMessage(message, message.getAllRecipients());
    transport.close();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Order Successful</title>
</head>
<body>
    <h2>Order Placed Successfully!</h2>
    <p>Your order ID: <%= orderId %></p>
    <p>A confirmation email has been sent to <%= userEmail %>.</p>
    <a href="index.jsp">Go to Home</a>
</body>
</html>
