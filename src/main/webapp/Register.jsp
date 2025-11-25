<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Đăng ký tài khoản</title>
</head>
<body>
<h1>Đăng ký</h1>
<% 
// Hiển thị thông báo lỗi (nếu có)
String error = request.getParameter("error");
if (error != null) {
    String msg = "";
    if (error.equals("mismatch")) {
        msg = "Mật khẩu xác nhận không khớp.";
    } else if (error.equals("usertaken")) {
        msg = "Tên đăng nhập đã được sử dụng. Vui lòng chọn tên khác.";
    } else {
        msg = "Đã xảy ra lỗi trong quá trình đăng ký.";
    }
%>
    <p style="color: red;"><%=msg%></p>
<% } %>

<form action="RegisterServlet" method="post">
    Tài Khoản: <input name="username" type="text" required><br><br>
    Email: <input name="email" type="email" required><br><br>
    Mật Khẩu: <input name="password" type="password" required><br><br>
    Xác nhận Mật Khẩu: <input name="confirm_password" type="password" required><br><br>
    <input value="Đăng ký" type="submit">
</form>
<br>
<a href="LoginServlet">Đã có tài khoản? Đăng nhập!</a>
<br>
<a href="index.jsp">Trở lại trang chủ</a>
</body>
</html>