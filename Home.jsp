<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<style>
    /* Chatbot Icon Styling */
.chatbot-icon {
    position: fixed;
    z-index:1;
    bottom: 20px;
    right: 20px;
    background-color: #007bff;
    color: white;
    border-radius: 50%;
    width: 60px;
    height: 60px;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 30px;
    cursor: pointer;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

/* Chat Window Styling */
.chat-window {
    position: fixed;
    z-index: 1;
    bottom: 80px;
    right: 20px;
    width: 300px;
    background: white;
    border-radius: 10px;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
    display: none;
}

.chat-header {
    background: #007bff;
    color: white;
    padding: 10px;
    text-align: center;
    border-top-left-radius: 10px;
    border-top-right-radius: 10px;
}

.chat-body {
    padding: 10px;
    height: 200px;
    overflow-y: auto;
    font-size: 14px;
}

.chat-footer {
    padding: 10px;
    display: flex;
    border-top: 1px solid #ccc;
}

.chat-footer input {
    flex: 1;
    padding: 5px;
    margin-right: 5px;
}

.chat-footer button {
    background: #007bff;
    color: white;
    border: none;
    padding: 5px 10px;
    cursor: pointer;
}

</style>

<body>
    <jsp:include page="navbar.jsp" />

    <%
    String flashMessage = (String) session.getAttribute("flashMessage");
    if (flashMessage != null) {
    %>
            <div class="d-flex justify-content-center align-items-start">
                <div class="alert alert-success alert-dismissible fade show col-8 text-center mt-3" role="alert">
                    <%= flashMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </div>
        
            
    <%
            // Remove flash message after displaying it
            session.removeAttribute("flashMessage");
        }
    %>
    <img src="./images/herosection.PNG" class="image" style="height: 60vh;width: 100%;" alt="hero section image"/>
    
    <h3 style="text-align: center; margin-top: 20px;">Category</h3>
    <div class="dashboard">

        <%
            PreparedStatement stmt = null;
            ResultSet rs = null;
            try {
                conn = (Connection) application.getAttribute("DBConnection");
                if (conn != null) {
                    String query = "SELECT id, title,image FROM category";
                    stmt = conn.prepareStatement(query);
                    rs = stmt.executeQuery();
                    
                    while (rs.next()) {
                        int categoryId = rs.getInt("id");
                        String categoryName = rs.getString("title");
                        String image = rs.getString("image");
        %>

        <a href="product.jsp?categoryId=<%= categoryId %>" style="color: #000 !important;">
            <div class="category">
                <img src="<%= image %>" alt="<%= categoryName %>">
                <h6><%= categoryName %></h6>
            </div>
        </a>

        <%
                    }
                } else {
                    out.println("<p>Database connection error!</p>");
                }
            } catch (SQLException e) {
                out.println("<p>Error retrieving categories: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                } catch (SQLException e) {
                    out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
                }
            }
        %>

    </div>


    <!-- Chatbot Icon -->
    <div class="chatbot-icon" onclick="toggleChat()">
        💬
    </div>

    <!-- Chat Window -->
    <div class="chat-window" id="chatWindow">
        <div class="chat-header">
            Chat with us
            <span style="float: right; cursor: pointer;" onclick="toggleChat()">✖</span>
        </div>
        <div class="chat-body" id="chatBody">
            <p>Welcome! How can I assist you?</p>
        </div>
        <div class="chat-footer">
            <input type="text" id="userInput" placeholder="Type a message...">
            <button onclick="sendMessage()">Send</button>
        </div>
    </div>

    <script>
        function toggleChat() {
            var chatWindow = document.getElementById("chatWindow");
            if (chatWindow.style.display === "none" || chatWindow.style.display === "") {
                chatWindow.style.display = "block";
            } else {
                chatWindow.style.display = "none";
            }
        }

        function sendMessage() {
            var userMessage = document.getElementById("userInput").value;
            var chatBody = document.getElementById("chatBody");

            if (userMessage.trim() === "") return;

            chatBody.innerHTML += "<p><strong>You:</strong> " + userMessage + "</p>";
            document.getElementById("userInput").value = "";

            // Send request to ChatbotServlet
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "ChatbotServlet", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    chatBody.innerHTML += "<p><strong>Bot:</strong> " + xhr.responseText + "</p>";
                    chatBody.scrollTop = chatBody.scrollHeight; // Auto-scroll to the bottom
                }
            };
            xhr.send("message=" + userMessage);
        }
    </script>

    <jsp:include page="footer.jsp" />
</body>
</html>
