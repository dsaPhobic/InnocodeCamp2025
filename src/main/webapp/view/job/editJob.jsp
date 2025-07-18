<%-- 
    Document   : editJob
    Created on : Jul 17, 2025, 6:05:19 PM
    Author     : hmqua
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Job"%>
<%
    Job job = (Job) request.getAttribute("job");
    if (job == null) {
%>
    <p>Không tìm thấy công việc.</p>
    <a href="../ViewJobsServlet">Quay lại danh sách công việc</a>
<%
    } else {
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sửa Công Việc</title>
</head>
<body>
    <h1>Sửa Công Việc</h1>
    <form action="../EditJobServlet" method="post">
        <input type="hidden" name="id" value="<%=job.getId()%>" />
        <label>Tiêu đề:</label><br>
        <input type="text" name="title" value="<%=job.getTitle()%>" required><br>
        <label>Công ty:</label><br>
        <input type="text" name="company" value="<%=job.getCompany()%>" required><br>
        <label>Địa điểm:</label><br>
        <input type="text" name="location" value="<%=job.getLocation()%>" required><br>
        <label>Môi trường:</label><br>
        <input type="text" name="environment" value="<%=job.getEnvironment()%>"><br>
        <label>Kỹ năng yêu cầu:</label><br>
        <input type="text" name="skill_required" value="<%=job.getSkillRequired()%>"><br>
        <label>Văn hoá/Tags:</label><br>
        <input type="text" name="culture_tags" value="<%=job.getCultureTags()%>"><br>
        <label>Mô tả:</label><br>
        <textarea name="description"><%=job.getDescription()%></textarea><br>
        <label>Email nhà tuyển dụng:</label><br>
        <input type="email" name="recruiter_email" value="<%=job.getRecruiterEmail()%>" required><br>
        <label>Trạng thái:</label><br>
        <select name="status">
            <option value="active" <%=job.getStatus()!=null && job.getStatus().equals("active")?"selected":""%>>Đang tuyển</option>
            <option value="inactive" <%=job.getStatus()!=null && job.getStatus().equals("inactive")?"selected":""%>>Tạm dừng</option>
        </select><br>
        <label>Ngày đăng bài:</label><br>
        <input type="datetime-local" name="posted_at" value="<%=job.getPostedAt()!=null? new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(job.getPostedAt()):""%>"><br><br>
        <input type="submit" value="Cập nhật công việc">
    </form>
    <br>
    <a href="../ViewJobsServlet">Quay lại danh sách công việc</a>
</body>
</html>
<%
    }
%>
