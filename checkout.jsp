<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    // Get user ID from session
    HttpSession userSession = request.getSession();
    String userId = (String) userSession.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp"); // Redirect if not logged in
        return;
    }

    int user_id = Integer.parseInt(userId);
    String userName = "", userAddress = "", userState = "", userCity = "", userPin = "", userPhone = "";

    try {
        PreparedStatement userStmt = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
        userStmt.setInt(1, user_id);
        ResultSet userRs = userStmt.executeQuery();

        if (userRs.next()) {
            userName = userRs.getString("username");
            userAddress = userRs.getString("address");
            userState = userRs.getString("state");
            userCity = userRs.getString("city");
            userPin = userRs.getString("pincode");
            userPhone = userRs.getString("contact");
        } else {
            out.println("<p class='text-danger'>Error: User details not found.</p>");
        }

        userRs.close();
        userStmt.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="container mt-4">
        <h2 class="text-center mb-4">Checkout</h2>

        <div class="row">
            <!-- Order Summary -->
            <div class="col-md-6">
                <h4>Order Summary</h4>

                <table class="table table-bordered">

                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Quantity</th>
                            <th>Price</th>
                            <th>Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int grandTotal = 0;
                            try {
                                String query = "SELECT cart.product_id,product.image, product.title, product.price, cart.quantity FROM cart JOIN product ON cart.product_id = product.id WHERE cart.user_id = ?";
                                PreparedStatement stmt = conn.prepareStatement(query);
                                stmt.setInt(1, user_id);
                                ResultSet rs = stmt.executeQuery();

                                while (rs.next()) {
                                    int quantity = rs.getInt("quantity");
                                    int price = rs.getInt("price");
                                    String productImage=rs.getString("image");
                                    int totalPrice = quantity * price;
                                    grandTotal += totalPrice;
                        %>
                        <tr>
                            <td><%= rs.getString("title") %></td>
                            <td><%= quantity %></td>
                            <td>Rs. <%= price %></td>
                            <td>Rs. <%= totalPrice %></td>
                        </tr>

                        <img src="<%= productImage %>" class="card-img-top" alt="Product Image" style="height: 250px;background-position: center;background-size: cover;background-repeat: no-repeat;">
               

                        <%
                                }
                                rs.close();
                                stmt.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        %>
                    </tbody>
                </table>
                <h5>Grand Total: Rs. <%= grandTotal %></h5>
            </div>

            <!-- Shipping Details & Payment -->
            <div class="col-md-6">
                <h4>Shipping Address</h4>

                <form action="placeOrderAllCartProduct.jsp" method="post">
                    <!-- Hidden input for user ID -->
                    <input type="hidden" name="userId" value="<%= userId %>">

                    <div class="mb-3">
                        <label for="name" class="form-label">Full Name</label>
                        <input type="text" class="form-control" id="name" name="name" value="<%= userName %>" readonly>
                    </div>

                    <div class="mb-3">
                        <label for="address" class="form-label">Address</label>
                        <textarea class="form-control" id="address" name="address" rows="2" readonly><%= userAddress %>, <%= userCity %>, <%= userState %>, <%= userPin %>
                        </textarea>
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label">Phone Number</label>
                        <input type="text" class="form-control" id="phone" name="phone" value="<%= userPhone %>" readonly>
                    </div>

                    <!-- Change Address Button -->
                    <a href="changeAddressCart.jsp" class="btn btn-warning w-100">Change Address</a>

                    <h4 class="mt-3">Payment Method</h4>
                    <div class="mb-3">
                        <input type="radio" id="cod" name="paymentMethod" value="COD">
                        <label for="cod">Cash on Delivery</label>
                    </div>
                    <div class="mb-3">
                        <input type="radio" id="PayPal" name="paymentMethod" value="Card" checked>
                        <label for="PayPal">Credit/Debit/ATM Card</label>
                    </div>

                    <script src="https://www.paypal.com/sdk/js?client-id=Abm1xbKbNYGEQgU2jSDbqSFzonw-XaqNKWRDxK-YjIUq7yxzCyMqNK3EMBpYSbsAgTfXRKwS_7TcbtsG&currency=USD"></script>

                            <div id="paypal-button-container"></div>

                            <script>
                                // Approximate conversion rate (Example: 1 USD = 83 INR)
                                const exchangeRate = 83; 
                            
                                document.querySelectorAll('input[name="paymentMethod"]').forEach((radio) => {
    radio.addEventListener("change", function () {
        document.getElementById("paypal-button-container").style.display = 
            this.value === "Card" ? "block" : "none";
    });
});
                            
                                paypal.Buttons({
                                    createOrder: function (data, actions) {
                                        let inrAmount = parseFloat(document.getElementById("totalAmountInput").value);
                                        let usdAmount = (inrAmount / exchangeRate).toFixed(2); // Convert INR to USD
                            
                                        return actions.order.create({
                                            purchase_units: [{
                                                amount: {
                                                    currency_code: "USD",
                                                    value: usdAmount
                                                }
                                            }]
                                        });
                                    },
                                    onApprove: function (data, actions) {
                                        return actions.order.capture().then(function (details) {
                                            alert('Payment successful! Transaction ID: ' + details.id);
                                            window.location.href = "placeOrder.jsp?payment=PayPal&transactionId=" + details.id;
                                        });
                                    },
                                    onError: function (err) {
                                        console.error("PayPal Error:", err);
                                        alert("Payment failed! Try again.");
                                    }
                                }).render('#paypal-button-container');
                            </script>
                            <br>

                            <input type="hidden" name="totalAmount" id="totalAmountInput" value="<%= grandTotal %>">

                    
                    <button type="submit" class="btn btn-success w-100">Place Order</button>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
