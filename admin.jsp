<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Page</title>
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
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="admin">
        <h4 class="text-align-center">Admin Login</h4>
        <form action="adminLogin.jsp" class="adminform" method="post">
            <div class="mb-3">
                <label for="formG" class="form-label">Email Address</label>
                <input type="email" class="form-control" id="formG" name="email" required>
            </div>
            <div class="mb-3">
                <label for="formGr" class="form-label">Password</label>
                <input type="password" class="form-control" id="formGr" name="password" required>
            </div>
            <div class="mb-3">
                <button class="form-control btn btn-primary">Login</button>
            </div>
        </form>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>