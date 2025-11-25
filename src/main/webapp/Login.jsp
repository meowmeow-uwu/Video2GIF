<%@page import="model.Bean.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Đăng nhập</title>
</head>
<body>
<h1>Đăng nhập</h1>
<% 
String status = request.getParameter("status");
String error = request.getParameter("error");

// Hiển thị thông báo đăng ký thành công
if (status != null && status.equals("register_success")) { %>
    <p style="color: green;">Đăng ký thành công! Vui lòng đăng nhập.</p>
<% } 

// Hiển thị thông báo lỗi
if (error != null && error.equals("invalid")) { %>
    <p style="color: red;">Tên đăng nhập hoặc mật khẩu không đúng.</p>
<% } %>

<form action="CheckInfoServlet" method="post">

Tài Khoản:<input name="username" type="text" required><br>
Mật Khẩu:<input name="password" type="password" required><br>
<input value="Login" type="submit">
</form>
<br>
<a href="RegisterServlet">Chưa có tài khoản? Đăng ký!</a> <!-- BỔ SUNG: Liên kết đến trang đăng ký -->
<br>
<a href="index.jsp">Trở lại trang chủ</a>
</body>
</html>