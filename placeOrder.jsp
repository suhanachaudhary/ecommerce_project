<%@ page import="java.sql.*, java.util.Date, java.text.SimpleDateFormat, jakarta.servlet.http.*, java.util.Properties, jakarta.mail.*, jakarta.mail.internet.*" %>
<%@ include file="dbconnect.jsp" %>
<%@ page import="mypackage.ConfigReader" %>

<%
    PreparedStatement orderStmt = null;
    PreparedStatement paymentStmt = null;
    PreparedStatement userStmt = null;
    ResultSet rs = null;
    ResultSet userRs = null;

    try {
        conn = (Connection) application.getAttribute("DBConnection");
        if (conn == null) {
            out.println("<p style='color:red;'>Database connection is not available.</p>");
            return;
        }

        // Get user ID from session
        HttpSession sessionObj = request.getSession();
        Object userIdObj = sessionObj.getAttribute("userId");

        if (userIdObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userid = Integer.parseInt(userIdObj.toString());

        // Get product details from request
        String productIdStr = request.getParameter("product_id");
        String productName = request.getParameter("product_name");
        String quantityStr = request.getParameter("quantity");
        String priceStr = request.getParameter("price");
        String paymentMethod = request.getParameter("payment_method");

        if (productIdStr == null || quantityStr == null || priceStr == null || paymentMethod == null || productName == null) {
            out.println("<p style='color:red;'>Error: Missing required parameters.</p>");
            return;
        }

        // Convert values
        int product_id = Integer.parseInt(productIdStr);
        int quantity = Integer.parseInt(quantityStr)+1;
        double price = Double.parseDouble(priceStr);
        double total_price = quantity * price;
        // Get current date and time
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String order_date = formatter.format(new java.util.Date());

        // Insert order into 'orders' table
        String orderQuery = "INSERT INTO orders(userid, product_id, product_name, quantity, price, total_price, order_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
        orderStmt = conn.prepareStatement(orderQuery, Statement.RETURN_GENERATED_KEYS);
        orderStmt.setInt(1, userid);
        orderStmt.setInt(2, product_id);
        orderStmt.setString(3, productName);
        orderStmt.setInt(4, quantity);
        orderStmt.setDouble(5, price);
        orderStmt.setDouble(6, total_price);
        orderStmt.setString(7, order_date);
        orderStmt.executeUpdate();

        // Retrieve generated order_id
        rs = orderStmt.getGeneratedKeys();
        int order_id = 0;
        if (rs.next()) {
            order_id = rs.getInt(1);
        }

        // Determine payment status
        String paymentStatus = paymentMethod.equalsIgnoreCase("PayPal") ? "Completed" : "Pending";

        // Insert payment details into 'payments' table
        String paymentQuery = "INSERT INTO payments(order_id, userid, payment_method, payment_status, payment_date) VALUES (?, ?, ?, ?, ?)";
        paymentStmt = conn.prepareStatement(paymentQuery);
        paymentStmt.setInt(1, order_id);
        paymentStmt.setInt(2, userid);
        paymentStmt.setString(3, paymentMethod);
        paymentStmt.setString(4, paymentStatus);
        paymentStmt.setString(5, order_date);
        paymentStmt.executeUpdate();

        // Retrieve user details (email, phone, name)
        String userEmail = "", userPhone = "", userName = "";
        String userQuery = "SELECT email, contact, username FROM users WHERE id = ?";
        userStmt = conn.prepareStatement(userQuery);
        userStmt.setInt(1, userid);
        userRs = userStmt.executeQuery();
        if (userRs.next()) {
            userEmail = userRs.getString("email");
            userPhone = userRs.getString("contact");
            userName = userRs.getString("username");
        }

        // Create HTML email content
        String emailContent = "<html><body>";
        emailContent += "<h2>Order Confirmation</h2>";
        emailContent += "<p>Dear " + userName + ",</p>";
        emailContent += "<p>Thank you for your order. Here are the details:</p>";
        emailContent += "<p><strong>Order ID:</strong> " + order_id + "<br/>";
        emailContent += "<strong>Product:</strong> " + productName + "<br/>";
        emailContent += "<strong>Quantity:</strong> " + quantity + "<br/>";
        emailContent += "<strong>Total Price:</strong> Rs." + total_price + "<br/>";
        emailContent += "<strong>Payment Method:</strong> " + paymentMethod + "<br/>";
        emailContent += "<strong>Payment Status:</strong> " + paymentStatus + "<br/>";
        emailContent += "</p>";
        emailContent += "<p>We appreciate your business!</p>";
        emailContent += "</body></html>";

        // Send email
        final String senderEmail = "chaudhary00suhana9837@gmail.com"; // Replace with your email
        final String senderPassword = System.getenv("SEND_EMAIL_PSW"); // Replace with an app password

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session mailSession = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        Message message = new MimeMessage(mailSession);
        message.setFrom(new InternetAddress(senderEmail));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(userEmail));
        message.setSubject("Order Confirmation - Order #" + order_id);
        message.setContent(emailContent, "text/html");

        Transport.send(message);

        // Send WhatsApp Message via Twilio
        String ACCOUNT_SID = System.getenv("TWILIO_ACCOUNT_SID");
        String AUTH_TOKEN = System.getenv("TWILIO_AUTH_TOKEN");

        final String TWILIO_WHATSAPP_NUMBER = "whatsapp:+14155238886";

        String recipientNumber = "whatsapp:+91" + userPhone;
        String messageBody = "Hello " + userName + "! Your order has been placed successfully.\n\n" +
                "Order ID: " + order_id + "\nTotal Amount: Rs." + total_price + "\n\nThank you for shopping with us!";

        try {
            com.twilio.Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
            com.twilio.rest.api.v2010.account.Message.creator(
                new com.twilio.type.PhoneNumber(recipientNumber),
                new com.twilio.type.PhoneNumber(TWILIO_WHATSAPP_NUMBER),
                messageBody
            ).create();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error sending WhatsApp message: " + e.getMessage() + "</p>");
        }

        response.sendRedirect("orderConfirmation.jsp?order_id=" + order_id);

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p style='color:red;'>Error processing order: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (userRs != null) userRs.close();
            if (orderStmt != null) orderStmt.close();
            if (paymentStmt != null) paymentStmt.close();
            if (userStmt != null) userStmt.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
%>



