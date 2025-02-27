<%@ include file="dbconnect.jsp" %>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    conn = (Connection) application.getAttribute("DBConnection");
    PreparedStatement pst = null;

    try {
        pst = conn.prepareStatement("insert into admins (email, password) VALUES (?, ?)");
        pst.setString(1, email);
        pst.setString(2, password);

        int rows = pst.executeUpdate();
        if (rows > 0) {
            session.setAttribute("username", email);
            response.sendRedirect("adminDashboard.jsp");
        } else {
            response.sendRedirect("addAdmin.jsp");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        try {
            if (pst != null) pst.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.println("Error closing resources: " + e.getMessage());
        }
    }
%>
