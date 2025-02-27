
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
        <div class="right mt-5"  style="height: 80vh;margin-right: 100px;">
            
            <div class="mt-3">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card" style="width: 24rem;">
                            <h3 class="text-primary text-center mb-3" style="height: 70px;background-color: #E7F0DC;padding-top: 10px;">
                                User Login
                            </h3>
                            <div class="card-body">
                                <form id="registrationForm" action="loginUser.jsp" method="post">
                                    <div class="form-group mb-3">
                                        <label for="email">
                                            Email
                                        </label>
                                        <input type="email" 
                                               class="form-control" 
                                               id="email" name="email"
                                               placeholder="Email" required />
                                    </div>
                                    <div class="form-group">
                                        <label for="password">
                                            Password
                                        </label>
                                        <input type="password" 
                                               class="form-control" 
                                               id="password" name="password" 
                                               placeholder="Password"
                                            required />
                                    </div><br>
                                    <button class="mb-3 form-control btn btn-primary">
                                        Login
                                    </button>
                                </form>
                                <p class="mt-3" style="text-align: center;">
                                    <a href="" style="color: rgb(0, 138, 216) !important;text-decoration: none;text-align: center !important;">Forgot Password</a>
                                    <br>
                                    Not registered?
                                    <a href="register.jsp" style="color: rgb(0, 138, 216) !important;" >Create an
                                        account</a>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>