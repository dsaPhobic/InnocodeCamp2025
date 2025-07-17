<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, model.Skill" %>
<html>
    <head><title>Kết quả kỹ năng</title></head>
    <body>
        <h2>🎯 Kỹ năng được phân tích:</h2>
        <ul>
            <%
                List<Skill> skills = (List<Skill>) request.getAttribute("skills");
                for (Skill s : skills) {
            %>
            <li><%= s.getSkillName()%> – Điểm: <%= s.getScore()%></li>
                <% }%>
        </ul>
        <a href="inputDescription.jsp">↩ Phân tích lại</a>
    </body>
</html>
