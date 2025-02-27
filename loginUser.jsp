<%@ include file="dbconnect.jsp" %>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    conn = (Connection) application.getAttribute("DBConnection");
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        pst = conn.prepareStatement("SELECT * FROM users WHERE email=? AND password=?");
        pst.setString(1, email);
        pst.setString(2, password);
        rs = pst.executeQuery();

        if (rs.next()) {
            int userId = rs.getInt("id");
            String userName = rs.getString("username");

            session.setAttribute("flashMessage", "Welcome, " + userName + "! You have successfully logged in.");
            
            // Store user in session
                session.setAttribute("userId", String.valueOf(userId));
                session.setAttribute("userName", userName);
                response.sendRedirect("Home.jsp");

        } else {
            response.sendRedirect("login.jsp?msg=Invalid credentials");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
