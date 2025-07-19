<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, model.Skill" %>
<html>
    <head>
        <title>Kết quả kỹ năng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/InputDescriptionCss.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    </head>
    <body class="bg-gray-50 py-8">
        <jsp:include page="/view/includes/navbar.jsp" />
        <div class="max-w-4xl mx-auto px-4 mt-10">
            <div class="mt-8 bg-white shadow rounded-lg p-8 analysis-container">
                <h2 class="text-2xl font-bold text-gray-900 mb-6" style="text-align:center;">🎯 Kết quả phân tích kỹ năng</h2>
                <ul class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                    <% List<Skill> skills = (List<Skill>) request.getAttribute("skills");
                       for (Skill s : skills) {
                          int score = s.getScore();
                          String colorClass = (score >= 80) ? "bg-green-100 text-green-800"
                              : (score >= 60) ? "bg-yellow-100 text-yellow-800"
                                  : "bg-red-100 text-red-800";
                    %>
                    <li class="p-4 rounded border <%= colorClass%> font-medium flex justify-between items-center skill-card">
                        <span><%= s.getSkillName()%></span>
                        <span class="font-semibold"><%= s.getScore()%>%</span>
                    </li>
                    <% } %>
                </ul>
                <div style="text-align:center;">
                    <a href="inputDescription.jsp" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded transition duration-200 inline-block" style="text-decoration:none;">↩ Phân tích lại</a>
                </div>
            </div>
        </div>
    </body>
</html>
