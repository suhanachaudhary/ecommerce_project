<%@ page import="java.sql.*, java.io.*, mypackage.ConfigReader" %>

<%
    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        String url = "jdbc:mysql://mainline.proxy.rlwy.net:44699/railway";
        String user = System.getenv("DB_USERNAME");
        String dbPassword = System.getenv("DB_PASSWORD");

        if (url == null || url.isEmpty()) {
            throw new Exception("Database URL is null or empty!");
        }
        if (user == null || user.isEmpty()) {
            throw new Exception("Database username is null or empty!");
        }
        if (dbPassword == null || dbPassword.isEmpty()) {
            throw new Exception("Database password is null or empty!");
        }

        conn = DriverManager.getConnection(url, user, dbPassword);
        application.setAttribute("DBConnection", conn);


    } catch (Exception e) {
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
