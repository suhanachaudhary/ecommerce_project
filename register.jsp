<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Login Page</title>
    <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
    rel="stylesheet"
    integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
    crossorigin="anonymous"
  />
  <script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
    crossorigin="anonymous"
  ></script>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="login container d-flex justify-content-evenly align-items-center">
        <div class="left">
            <img src="./images//login.png" style="height: 80vh;width: 480px;" alt="login page">
        </div>

        <div class="right mt-2"  style="height: 70vh;margin-right: 100px;margin-bottom: 200px;">
            
            <div class="">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card" style="width: 26rem;">
                            <h3 class="text-primary text-center" style="height: 70px;background-color: #E7F0DC;padding-top: 10px;">
                                User Register
                            </h3>
                            <div class="card-body">
                                <form id="registrationForm" action="RegisterServlet" method="post" enctype="multipart/form-data">

                                    <div class="row">
                                        <div class="form-group mb-3 col-md-6">
                                            <label for="name">
                                                Username
                                            </label>
                                            <input type="text" 
                                                class="form-control" 
                                                id="name" name="username"
                                                placeholder="Username" required />
                                        </div>
                                        <div class="form-group mb-3 col-md-6">
                                            <label for="phone">
                                                Contact
                                            </label>
                                            <input type="text" 
                                                class="form-control" 
                                                id="phone" name="contact"
                                                placeholder="Phone" required />
                                        </div>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label for="email">
                                            Email
                                        </label>
                                        <input type="email" 
                                               class="form-control" 
                                               id="email" name="email" 
                                               placeholder="Email" required />
                                    </div>

                                    <div class="row">
                                        <div class="form-group mb-3 col-md-6">
                                            <label for="address">
                                                Address
                                            </label>
                                            <input type="text" 
                                                class="form-control" 
                                                id="address" name="address"
                                            required />
                                        </div>
                                        <div class="form-group mb-3 col-md-6">
                                            <label for="city">
                                                City
                                            </label>
                                            <input type="text" 
                                                class="form-control" 
                                                id="city" name="city" 
                                                required />
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="form-group mb-3 col-md-6">
                                            <label for="state">
                                                State
                                            </label>
                                            <input type="text" 
                                                class="form-control" 
                                                id="state" name="state" 
                                            required />
                                        </div>
                                        <div class="form-group mb-3 col-md-6">
                                            <label for="pincode">
                                                Pincode
                                            </label>
                                            <input type="text" 
                                                class="form-control" 
                                                id="pincode" name="pincode" 
                                                required />
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="form-group mb-3 col-md-6">
                                            <label for="pass1">
                                                Password
                                            </label>
                                            <input type="password" 
                                                class="form-control" 
                                                id="pass1" name="password"
                                            required />
                                        </div>
                                        <div class="form-group mb-3 col-md-6">
                                            <label for="pass2">
                                                Confirm Password
                                            </label>
                                            <input type="password" 
                                                class="form-control" 
                                                id="pass2" name="confirmpsw" 
                                                required />
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="profile">
                                            Profile Image
                                        </label>
                                        <input type="file" 
                                               class="form-control" 
                                               id="profile" name="image" 
                                            required />
                                    </div><br>
                                    <br>
                                    <button class="mb-3 form-control btn btn-primary">
                                        Register
                                    </button>
                                </form>
                                <p class="mt-3" style="text-align: center;">
                                    
                                    Already have an account?
                                    <a href="register.jsp" style="color: rgb(0, 138, 216) !important;" >Login</a>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <br><br>
    <jsp:include page="footer.jsp" />
</body>
</html>