<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Skill" %>
<html>
    <head>
        <title>📄 Phân tích kỹ năng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/InputDescriptionCss.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />

        <link rel="stylesheet" href="https://unpkg.com/lucide@latest" />
        <style>
            body{
                margin: 0;
                padding:0;
            }
        </style>
    </head>
    <body class="bg-gray-50 py-8">

        <!-- ✅ Thêm navbar -->
        <jsp:include page="/view/includes/navbar.jsp" />

        <div class="max-w-4xl mx-auto px-4 mt-8">
            <h1 class="text-3xl font-bold text-gray-900 mb-4">📄 Upload CV để phân tích kỹ năng</h1>
            <p class="text-gray-600 mb-6">Tải lên CV của bạn để hệ thống tự động phân tích kỹ năng phù hợp.</p>

            <form action="${pageContext.request.contextPath}/SkillAnalysisServlet" method="post" enctype="multipart/form-data" class="bg-white shadow-md rounded px-8 py-6">
                <label class="block text-sm font-medium text-gray-700 mb-2">Chọn file CV (.pdf, .docx):</label>
                <input type="file" name="cvFile" accept=".pdf,.doc,.docx" required
                       class="mb-4 block w-full text-sm text-gray-900 border border-gray-300 rounded-lg cursor-pointer bg-gray-50 focus:outline-none" />

                <button type="submit"
                        class="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-4 rounded transition duration-200">
                    📊 Phân tích kỹ năng
                </button>
            </form>

            <%
                List<Skill> skills = (List<Skill>) request.getAttribute("skills");
                if (skills != null && !skills.isEmpty()) {
            %>
            <div class="mt-8 bg-white shadow rounded-lg p-6">
                <h2 class="text-xl font-semibold text-gray-900 mb-4">✅ Kỹ năng đã phân tích</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <% for (Skill skill : skills) {
                            int score = skill.getScore();
                            String colorClass = (score >= 80) ? "bg-green-100 text-green-700"
                                    : (score >= 60) ? "bg-yellow-100 text-yellow-700"
                                            : "bg-red-100 text-red-700";
                    %>
                    <div class="p-4 rounded border <%= colorClass%>">
                        <div class="flex justify-between mb-1">
                            <span class="font-medium"><%= skill.getSkillName()%></span>
                            <span class="font-semibold"><%= score%>%</span>
                        </div>
                        <div class="w-full bg-white bg-opacity-50 rounded-full h-2">
                            <div class="bg-current h-2 rounded-full" style="width: <%= score%>%"></div>
                        </div>
                    </div>
                    <% }%>
                </div>

                <div class="mt-6 p-4 bg-blue-50 rounded-lg">
                    <h3 class="text-blue-900 font-medium mb-1">Tóm tắt phân tích</h3>
                    <p class="text-sm text-blue-800">
                        Hệ thống đã phát hiện <%= skills.size()%> kỹ năng, với điểm số từ
                        <%= skills.stream().mapToInt(Skill::getScore).min().orElse(0)%>% đến
                        <%= skills.stream().mapToInt(Skill::getScore).max().orElse(100)%>%.
                    </p>
                </div>
            </div>
            <% }%>
        </div>

        <script>lucide.createIcons();</script>
    </body>
</html>
