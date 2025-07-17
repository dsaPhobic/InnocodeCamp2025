<%-- 
    Document   : viewJobs
    Created on : Jul 17, 2025, 6:05:24 PM
    Author     : hmqua
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Job"%>
<%
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Danh sách công việc</title>
    <style>
        table, th, td { border: 1px solid black; border-collapse: collapse; padding: 5px; }
        th { background: #eee; }
    </style>
</head>
<body>
    <h1>Danh sách công việc</h1>
    <a href="addJob.jsp">Thêm công việc mới</a>
    <br><br>
    <table>
        <tr>
            <th>ID</th>
            <th>Tiêu đề</th>
            <th>Công ty</th>
            <th>Địa điểm</th>
            <th>Môi trường</th>
            <th>Kỹ năng</th>
            <th>Văn hoá/Tags</th>
            <th>Mô tả</th>
            <th>Email tuyển dụng</th>
            <th>Hành động</th>
        </tr>
        <% if (jobs != null && !jobs.isEmpty()) {
            for (Job job : jobs) { %>
        <tr>
            <td><%=job.getId()%></td>
            <td><%=job.getTitle()%></td>
            <td><%=job.getCompany()%></td>
            <td><%=job.getLocation()%></td>
            <td><%=job.getEnvironment()%></td>
            <td><%=job.getSkillRequired()%></td>
            <td><%=job.getCultureTags()%></td>
            <td><%=job.getDescription()%></td>
            <td><%=job.getRecruiterEmail()%></td>
            <td>
                <a href="editJob.jsp?id=<%=job.getId()%>">Edit</a>
                <form action="../../DeleteJobServlet" method="post" style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn xoá?');">
                    <input type="hidden" name="id" value="<%=job.getId()%>" />
                    <input type="submit" value="Delete" />
                </form>
            </td>
        </tr>
        <% } 
        } else { %>
        <tr><td colspan="10">Không có công việc nào.</td></tr>
        <% } %>
    </table>
</body>
</html>
