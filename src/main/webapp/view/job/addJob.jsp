<%-- 
    Document   : addJob
    Created on : Jul 17, 2025, 6:05:14 PM
    Author     : hmqua
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thêm Công Việc</title>
</head>
<body>
    <h1>Thêm Công Việc Mới</h1>
    <form action="../AddJobServlet" method="post">
        <label>Tiêu đề:</label><br>
        <input type="text" name="title" required><br>
        <label>Công ty:</label><br>
        <input type="text" name="company" required><br>
        <label>Địa điểm:</label><br>
        <input type="text" name="location" required><br>
        <label>Môi trường:</label><br>
        <input type="text" name="environment"><br>
        <label>Kỹ năng yêu cầu:</label><br>
        <input type="text" name="skill_required"><br>
        <label>Văn hoá/Tags:</label><br>
        <input type="text" name="culture_tags"><br>
        <label>Mô tả:</label><br>
        <textarea name="description"></textarea><br>
        <label>Email nhà tuyển dụng:</label><br>
        <input type="email" name="recruiter_email" required><br>
        <label>Trạng thái:</label><br>
        <select name="status">
            <option value="active">Đang tuyển</option>
            <option value="inactive">Tạm dừng</option>
        </select><br>
        <label>Ngày đăng bài:</label><br>
        <input type="datetime-local" name="posted_at"><br><br>
        <input type="submit" value="Thêm công việc">
    </form>
    <br>
    <a href="../ViewJobsServlet">Quay lại danh sách công việc</a>
</body>
</html>
