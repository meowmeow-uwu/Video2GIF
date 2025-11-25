<%@page import="model.Bean.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // ĐÃ SỬA: Thống nhất sử dụng Session key "username"
    User user = (User) request.getSession().getAttribute("username");
    if (user == null) {
        response.sendRedirect("LoginServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Upload Video | DUT-Video2GIF</title>
</head>
<body>
    <h1>Upload Video, Xin chào <%=user.getUsername()%>!</h1>
    
    <form action="UploadServlet" method="post" enctype="multipart/form-data">
        Video (video1.mp4): <input type="file" name="videoFile" accept="video/*" required><br><br>
        
        Thời gian bắt đầu (VD - 00:15): <input type="text" name="start_time" value="00:00" pattern="[0-5]?[0-9]:[0-5][0-9]" title="Format: MM:SS" required><br><br>
        Thời gian kết thúc (VD - 00:20): <input type="text" name="end_time" value="00:10" pattern="[0-5]?[0-9]:[0-5][0-9]" title="Format: MM:SS" required><br><br>
        
        <input type="submit" value="Xử lý">
        <input type="reset" value="Reset">
    </form>
    <br>
    <a href="DashboardServlet">Trở lại Dashboard</a>
</body>
</html>