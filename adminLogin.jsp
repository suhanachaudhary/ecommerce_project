<%@ include file="dbconnect.jsp" %>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    conn = (Connection) application.getAttribute("DBConnection");
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        pst = conn.prepareStatement("SELECT * FROM admins WHERE email=? AND password=?");
        pst.setString(1, email);
        pst.setString(2, password);
        rs = pst.executeQuery();

        if (rs.next()) {
            session.setAttribute("admin", rs.getString("email"));
            response.sendRedirect("adminDashboard.jsp");
        } else {
            response.sendRedirect("admin.jsp");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
