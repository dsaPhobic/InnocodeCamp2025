<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Phân tích kỹ năng</title>
</head>
<body>
<h2>📄 Upload CV để phân tích kỹ năng</h2>

<form action="SkillAnalysisServlet" method="post" enctype="multipart/form-data">
    <label>Chọn file CV (.pdf, .docx):</label><br>
    <input type="file" name="cvFile" accept=".pdf,.doc,.docx" required><br><br>

    <input type="submit" value="Phân tích kỹ năng">
</form>
</body>
</html>
