<%
    session.invalidate();
    response.sendRedirect("Home.jsp?msg=Logged out successfully");
%>
