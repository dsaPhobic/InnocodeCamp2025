<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Công việc đã ứng tuyển</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f9f9f9; }
    </style>
</head>
<body>
    <h2>Danh sách công việc bạn đã ứng tuyển</h2>

    <!-- Hiển thị thông báo nếu có -->
    <c:if test="${not empty message}">
        <div style="color: green;">${message}</div>
    </c:if>

    <table>
        <tr>
            <th>Vị trí</th>
            <th>Công ty</th>
            <th>Trạng thái</th>
            <th>Ngày ứng tuyển</th>
        </tr>

        <c:forEach var="app" items="${applications}">
            <tr>
                <td>${app.job.title}</td>
                <td>${app.job.company}</td>
                <td>${app.status}</td>
                <td><c:out value="${app.appliedAt}" /></td>
            </tr>
        </c:forEach>

        <c:if test="${empty applications}">
            <tr>
                <td colspan="4"><em>Bạn chưa ứng tuyển công việc nào.</em></td>
            </tr>
        </c:if>
    </table>

    <!-- Liên kết điều hướng -->
    <p>
        <a href="home.jsp">🏠 Quay về trang chủ</a> |
        <a href="JobRecommendationServlet">🔍 Gợi ý việc làm</a>
    </p>
</body>
</html>
