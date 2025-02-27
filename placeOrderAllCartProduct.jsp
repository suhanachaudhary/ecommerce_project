<%@ page import="java.sql.*, java.util.Date, jakarta.servlet.http.*" %>
<%@ page import="com.twilio.Twilio, com.twilio.rest.api.v2010.account.Message, com.twilio.type.PhoneNumber" %>
<%@ page import="java.util.Properties, jakarta.mail.*, jakarta.mail.internet.*" %>
<%@ include file="dbconnect.jsp" %>
<%@ page import="mypackage.ConfigReader" %>

<%
    HttpSession userSession = request.getSession();
    String userId = (String) userSession.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int user_id = Integer.parseInt(userId);
    String paymentMethod = request.getParameter("paymentMethod");
    int totalAmount = Integer.parseInt(request.getParameter("totalAmount"));

    Date currentDate = new Date();
    java.sql.Timestamp orderDate = new java.sql.Timestamp(currentDate.getTime());

    String userName = "", userPhone = "", userAddress = "", userEmail = "";
    int order_id = 0;

    try {
        if (conn == null) {
            throw new Exception("Database connection is null!");
        }

        // Fetch user details
        PreparedStatement userStmt = conn.prepareStatement("SELECT username, address, contact, email FROM users WHERE id = ?");
        userStmt.setInt(1, user_id);
        ResultSet userRs = userStmt.executeQuery();

        if (userRs.next()) {
            userName = userRs.getString("username");
            userPhone = userRs.getString("contact");
            userAddress = userRs.getString("address");
            userEmail = userRs.getString("email");
        } else {
            out.println("<p class='text-danger'>Error: User details not found.</p>");
            return;
        }

        // Insert order
        String insertOrderQuery = "INSERT INTO orders (userid, product_id, product_name, quantity, price, total_price, order_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement orderStmt = conn.prepareStatement(insertOrderQuery, Statement.RETURN_GENERATED_KEYS);

        // Fetch cart items
        String cartQuery = "SELECT cart.product_id, cart.quantity, product.title, product.price FROM cart JOIN product ON cart.product_id = product.id WHERE cart.user_id = ?";
        PreparedStatement cartStmt = conn.prepareStatement(cartQuery);
        cartStmt.setInt(1, user_id);
        ResultSet cartRs = cartStmt.executeQuery();

        StringBuilder orderDetails = new StringBuilder();
        orderDetails.append("Dear ").append(userName).append(",\n\nYour order has been placed successfully.\n\nOrder Details:\n");

        while (cartRs.next()) {
            int productId = cartRs.getInt("product_id");
            int quantity = cartRs.getInt("quantity");
            String productName = cartRs.getString("title");
            double price = cartRs.getDouble("price");
            double totalPrice = price * quantity;

            // Insert into orders
            orderStmt.setInt(1, user_id);
            orderStmt.setInt(2, productId);
            orderStmt.setString(3, productName);
            orderStmt.setInt(4, quantity);
            orderStmt.setDouble(5, price);
            orderStmt.setDouble(6, totalPrice);
            orderStmt.setTimestamp(7, orderDate);
            orderStmt.executeUpdate();

            orderDetails.append(productName).append(" Quantity: ").append(quantity).append(", Price: Rs.").append(price).append("\n");
        }

        // Retrieve generated order ID
        ResultSet generatedKeys = orderStmt.getGeneratedKeys();
        if (generatedKeys.next()) {
            order_id = generatedKeys.getInt(1);
        }

        // Delete items from the cart
        String deleteCartQuery = "DELETE FROM cart WHERE user_id = ?";
        PreparedStatement deleteCartStmt = conn.prepareStatement(deleteCartQuery);
        deleteCartStmt.setInt(1, user_id);
        deleteCartStmt.executeUpdate();

        // ---------------- SEND ORDER CONFIRMATION EMAIL ----------------
        final String senderEmail = "chaudhary00suhana9837@gmail.com"; // Replace with actual email
        final String senderPassword = System.getenv("SEND_EMAIL_PSW");

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        jakarta.mail.Session mailSession = jakarta.mail.Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected jakarta.mail.PasswordAuthentication getPasswordAuthentication() {
                return new jakarta.mail.PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        jakarta.mail.Message emailMessage = new jakarta.mail.internet.MimeMessage(mailSession);
        emailMessage.setFrom(new jakarta.mail.internet.InternetAddress(senderEmail));
        emailMessage.setRecipients(jakarta.mail.Message.RecipientType.TO, jakarta.mail.internet.InternetAddress.parse(userEmail));
        emailMessage.setSubject("Order Confirmation - Order #" + order_id);
        emailMessage.setText(orderDetails.toString());

        jakarta.mail.Transport.send(emailMessage);

        String ACCOUNT_SID = System.getenv("TWILIO_ACCOUNT_SID");
        String AUTH_TOKEN = System.getenv("TWILIO_AUTH_TOKEN");
        final String TWILIO_WHATSAPP_NUMBER = "whatsapp:+14155238886";  // Twilio's WhatsApp sandbox number

        // Format user's WhatsApp number correctly
        String recipientNumber = "whatsapp:+" +"91"+userPhone;

        String messageBody = "Hello " + userName + "! Your order has been placed successfully.\n\n" +
                "Order ID: " + order_id + "\nTotal Amount: Rs." + totalAmount + "\n\nThank you for shopping with us!";

        try {
            // Initialize Twilio
            Twilio.init(ACCOUNT_SID, AUTH_TOKEN);

            // Send WhatsApp Message
            Message whatsappMessage = Message.creator(
                new PhoneNumber(recipientNumber),
                new PhoneNumber(TWILIO_WHATSAPP_NUMBER), 
                messageBody
            ).create();

            out.println("<h3>WhatsApp Message Sent Successfully!</h3>");
            out.println("<p>Message SID: " + whatsappMessage.getSid() + "</p>");

        } catch (Exception e) {
            out.println("<h3>Error Sending WhatsApp Message!</h3>");
            out.println("<p>" + e.getMessage() + "</p>");
        }

        response.sendRedirect("orderConfirmation.jsp?order_id=" + order_id);

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
    }
%>
