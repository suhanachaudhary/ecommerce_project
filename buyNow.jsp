<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="dbconnect.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buy Now</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="style.css">
    <script>
        function updateTotal() {
            let quantity = document.getElementById("quantity").value;
            let price = parseFloat(document.getElementById("productPrice").value);
            let discount = parseFloat(document.getElementById("productDiscount").value);
            let shippingCharge = 30;
            let tax = 10;

            let discountedPrice = price - (price * (discount / 100));
            let totalProductPrice = discountedPrice * quantity;
            let finalTotal = totalProductPrice + shippingCharge + tax;

            document.getElementById("totalPrice").innerText = "Rs. " + totalProductPrice.toFixed(2);
            document.getElementById("finalAmount").innerText = "Rs. " + finalTotal.toFixed(2);
            document.getElementById("totalAmountInput").value = finalTotal;
        }
    </script>
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <%
    String productId = request.getParameter("productId");
    if (productId == null) {
        out.println("<p class='text-danger text-center'>Invalid request. Product ID is missing.</p>");
        return;
    }

    HttpSession userSession = request.getSession();
    String userId = (String) userSession.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    conn = (Connection) application.getAttribute("DBConnection");
    if (conn == null) {
        out.println("<p class='text-danger text-center'>Database connection failed.</p>");
        return;
    }

    // Fetch user details
    String userQuery = "SELECT * FROM users WHERE id = ?";
    PreparedStatement userStmt = conn.prepareStatement(userQuery);
    userStmt.setString(1, userId);
    ResultSet userRs = userStmt.executeQuery();

    String userName = "", userAddress = "",userState="",userCity="",userPin="", userPhone = "";
    if (userRs.next()) {
        userName = userRs.getString("username");
        userAddress = userRs.getString("address");
        userPhone = userRs.getString("contact");
        userState = userRs.getString("state");
        userCity = userRs.getString("city");
        userPin = userRs.getString("pincode");
    }
    userRs.close();
    userStmt.close();

    String cartQuery = "SELECT * FROM cart WHERE id = ?";
    PreparedStatement cartStmt = conn.prepareStatement(cartQuery);
    cartStmt.setInt(1, Integer.parseInt(productId));
    ResultSet crt = cartStmt.executeQuery();

    int quantity=0;
    if (crt.next()) {
        quantity = crt.getInt("quantity");
    }


    // Fetch product details
    String productQuery = "SELECT * FROM product WHERE id = ?";
    PreparedStatement productStmt = conn.prepareStatement(productQuery);
    productStmt.setInt(1, Integer.parseInt(productId));
    ResultSet productRs = productStmt.executeQuery();

    if (productRs.next()) {
        String productName = productRs.getString("title");
        double price = productRs.getDouble("price");
        double discount = productRs.getDouble("discount");
        String productImage=productRs.getString("image");

        double discountedPrice = price - (price * (discount / 100));
        double shippingCharge = 30;
        double tax = 10;
        int defaultQuantity = 1;
        double totalAmount = (discountedPrice * defaultQuantity) + shippingCharge + tax;
    %>

    <div class="container mt-4">
        <h2 class="text-center mb-4">Order Summary</h2>

        <div class="row">
            <div class="col-md-6">
                <!-- Delivery Address -->
                <div class="card" style="width: 28rem;">
                    <h5 class="card-header text-center">Delivery Address</h5>
                    <div class="card-body">
                        <h5 class="card-title"><%= userName %></h5>
                        <p class="card-text"><%= userAddress %>, <%=userCity%>, <%=userState%>, <%=userPin%>
                            <br>Contact Details: <%= userPhone %>
                        </p>
                        <a href="changeAddress.jsp?productId=<%= productId %>" class="btn btn-primary">Change Address</a>
                    </div>
                </div>

                <!-- Product Details -->
                <div class="card mt-3" style="width: 28rem;">
                    <h5 class="card-header text-center">Product Details</h5>
                    <div class="card-body">
                        <img src="<%= productImage %>" class="card-img-top" alt="Product Image" style="height: 200px;background-position: center;background-size: cover;background-repeat: no-repeat;">
                                  
                        <p><strong>Product Name:</strong> <%= productName %></p>
                        <p><strong>Price:</strong> Rs. <%= price %></p>
                        <p><strong>Discounted Price:</strong> Rs. <%= discountedPrice %></p>

                        <!-- Quantity Selector -->
                        <p><strong>Quantity:</strong>
                            <input type="number" id="quantity" name="quantity" value="1" min="1" max="10" class="form-control w-50 d-inline" oninput="updateTotal()">
                        </p>

                        <p><strong>Total Product Price:</strong> <span id="totalPrice">Rs. <%= discountedPrice %></span></p>
                        <p><strong>Shipping Charge:</strong> Rs. <%= shippingCharge %></p>
                        <p><strong>Tax:</strong> Rs. <%= tax %></p>
                        <hr>
                        <p><strong>Total Amount:</strong> <span id="finalAmount">Rs. <%= totalAmount %></span></p>

                        <!-- Hidden Inputs to store values for form submission -->
                        <input type="hidden" id="productPrice" value="<%= price %>">
                        <input type="hidden" id="productDiscount" value="<%= discount %>">
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <!-- Payment Method -->
                <div class="card" style="width: 28rem;">
                    <h5 class="card-header text-center">Payment</h5>
                    <div class="card-body">
                        <form action="placeOrder.jsp" method="post">

                            <input type="hidden" name="product_id" value="<%= productId %>">
                            <input type="hidden" name="product_name" value="<%= productName %>">
                            <input type="hidden" name="userId" value="<%= userId %>">
                            <input type="hidden" name="quantity" value="<%= quantity %>" required>
                            <input type="hidden" name="price" value="<%= price %>">

                            <input type="hidden" id="totalAmountInput" name="totalAmount" value="<%= totalAmount %>">

                            <p class="card-text">Payment Mode</p>
                            <div class="col">
                                <select id="inputState" name="payment_method" class="form-select" required>
                                    <option selected disabled>Choose...</option>
                                    <option value="PayPal">PayPal (Credit/Debit Card)</option>
                                    <option value="COD">Cash on Delivery</option>
                                </select>
                            </div><br>

                            <script src="https://www.paypal.com/sdk/js?client-id=Abm1xbKbNYGEQgU2jSDbqSFzonw-XaqNKWRDxK-YjIUq7yxzCyMqNK3EMBpYSbsAgTfXRKwS_7TcbtsG&currency=USD"></script>

                            <div id="paypal-button-container"></div>

                            <script>
                                // Approximate conversion rate (Example: 1 USD = 83 INR)
                                const exchangeRate = 83; 
                            
                                document.getElementById("inputState").addEventListener("change", function () {
                                    if (this.value === "PayPal") {
                                        document.getElementById("paypal-button-container").style.display = "block";
                                    } else {
                                        document.getElementById("paypal-button-container").style.display = "none";
                                    }
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

                            <div class="col">
                                <button type="submit" class="form-control btn-success mb-5 text-center">Place Order</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

        </div>
    </div>
    <%
    } else {
        out.println("<p class='text-danger text-center'>Product not found.</p>");
    }
    productRs.close();
    productStmt.close();
    %>

    <jsp:include page="footer.jsp" />
</body>
</html>
