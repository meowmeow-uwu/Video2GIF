<%@page import="model.Bean.VideoRequest"%>
<%@page import="model.Bean.User"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dashboard</title>
<style>
    body { font-family: Arial, sans-serif; padding: 20px; }
    table { width: 100%; border-collapse: collapse; }
    th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
    th { background-color: #f2f2f2; }
    .status-pending { color: orange; font-weight: bold; }
    .status-processing { color: blue; font-weight: bold; }
    .status-completed { color: green; font-weight: bold; }
    .status-failed { color: red; font-weight: bold; } /* BỔ SUNG: Trạng thái FAILED */
    .message { padding: 10px; margin-bottom: 15px; border-radius: 4px; }
    .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
</style>
</head>
<body>
<h1> Bảng điều khiển </h1>
<%
User user = (User)request.getSession().getAttribute("username"); 
List<VideoRequest> requests = (List<VideoRequest>) request.getAttribute("videoRequests");

String statusParam = request.getParameter("status");
String msgParam = request.getParameter("msg");

if (user != null) {
%>
Username: <%=user.getUsername()%> <br>
Email: <%=user.getEmail()%> <br>
<a href="LogoutServlet">Đăng xuất</a>
<hr>

<% 
    if (statusParam != null) {
        String message = "";
        String cssClass = "message ";
        
        switch (statusParam) {
            case "register_success": // BỔ SUNG: Cho Đăng ký
                message = "Đăng ký thành công! Bạn đã được tự động đăng nhập.";
                cssClass += "success";
                break;
            case "upload_success":
                message = "Yêu cầu upload và xử lý đã được gửi thành công. Vui lòng chờ đợi.";
                cssClass += "success";
                break;
            case "delete_success":
                message = "Yêu cầu và các file liên quan đã được xóa thành công.";
                cssClass += "success";
                break;
            case "error":
                message = "Đã xảy ra lỗi: " + (msgParam != null ? msgParam : "Lỗi không xác định");
                cssClass += "error";
                break;
        }
        if (!message.isEmpty()) {
%>
<div class="<%=cssClass%>"><%=message%></div>
<%
        }
    }
%>

<h2>Yêu cầu chuyển đổi Video</h2>
<a href="UploadServlet">(+) Upload video mới</a>
<br><br>

<table border="1" cellpadding="10" cellspacing="0">
    <tr>
        <th>ID</th>
        <th>Video Name</th>
        <th>Time Range</th>
        <th>Status</th>
        <th>Actions</th>
    </tr>
    <% if (requests != null) {
        for (VideoRequest req : requests) { 
            String statusClass = "";
            switch (req.getStatus()) {
                case "PENDING":
                    statusClass = "status-pending";
                    break;
                case "PROCESSING":
                    statusClass = "status-processing";
                    break;
                case "COMPLETED":
                    statusClass = "status-completed";
                    break;
                case "FAILED": // BỔ SUNG: Trạng thái FAILED
                    statusClass = "status-failed";
                    break;
            }
        %>
            <tr>
                <td><%=req.getRequest_id()%></td>
                <td><%=req.getOriginal_video_name()%></td>
                <td><%=req.getStart_time()%> - <%=req.getEnd_time()%></td>
                <td class="<%=statusClass%>"><%=req.getStatus()%></td>
                <td>
                    <a href="DeleteRequestServlet?request_id=<%=req.getRequest_id()%>" onclick="return confirm('Bạn có chắc chắn muốn xóa yêu cầu #<%=req.getRequest_id()%>?');">Xóa</a>
                    <% if ("COMPLETED".equals(req.getStatus())) { %>
                         | <a href="PreviewServlet?request_id=<%=req.getRequest_id()%>" target="_blank">Xem trước</a> 
                         | <a href="DownloadServlet?request_id=<%=req.getRequest_id()%>">Tải về</a> 
                    <% } %>
                    <% if ("FAILED".equals(req.getStatus())) { %>
                         | <span style="color: red; font-size: small;">Lỗi xử lý</span>
                    <% } %>
                </td>
            </tr>
        <% }
    } %>
</table>


<%}%>
</body>
</html>