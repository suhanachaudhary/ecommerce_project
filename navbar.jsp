<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>

<%
    Object userIdObj = session.getAttribute("userId");
    Integer userId = null;
    if (userIdObj != null) {
        try {
            userId = Integer.parseInt(userIdObj.toString()); // Safely convert to Integer
        } catch (NumberFormatException e) {
            userId = null; // Handle conversion error gracefully
        }
    }
    boolean isLoggedIn = (userId != null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Navbar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="style.css" />
</head>

<body>
    <nav class="navbar navbar-expand-lg navbar-primary bg-primary">
        <div class="container-fluid d-flex justify-content-between">
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="cart.jsp">
                            <i class="fa-solid fa-cart-shopping" style="color: #ffffff"></i>&nbsp;&nbsp;Ecomestore
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="Home.jsp">
                            <i class="fa-solid fa-house" style="color: #ffffff"></i>&nbsp;&nbsp;Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="product.jsp">Product</a>
                    </li>

                    <form method="get" action="product.jsp">
                        <div class="nav-item dropdown">
                            <a class="nav-link active dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Category
                            </a>
                            <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <li><button class="dropdown-item" type="submit" name="category" value="Phone">Phones</button></li>
                                <li><button class="dropdown-item" type="submit" name="category" value="Laptop">Laptop</button></li>
                                <li><button class="dropdown-item" type="submit" name="category" value="Fashion">Fashion</button></li>
                                <li><button class="dropdown-item" type="submit" name="category" value="Beauty Product">Beauty Product</button></li>
                                <li><button class="dropdown-item" type="submit" name="category" value="Books">Books</button></li>
                            </ul>
                        </div>
                    </form>
                </ul>
            </div>

            <ul class="navbar-nav me-auto mb-lg-0 ms-0">
                <% if (isLoggedIn) { %>
                    <li class="nav-item">
                        <a class="nav-link active" href="orders.jsp">
                            <i class="fa-solid fa-box" style="color: #ffffff;"></i>&nbsp;&nbsp;My Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="logout.jsp">
                            <i class="fa-solid fa-sign-out-alt" style="color: #ffffff;"></i>&nbsp;&nbsp;Logout
                        </a>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link active" href="login.jsp">
                            <i class="fa-solid fa-right-to-bracket" style="color: #ffffff;"></i>&nbsp;&nbsp;Login
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="register.jsp">Register</a>
                    </li>
                <% } %>
                
                <li class="nav-item">
                    <a class="nav-link active" href="admin.jsp">Admin</a>
                </li>
            </ul>
        </div>
    </nav>
</body>
</html>
