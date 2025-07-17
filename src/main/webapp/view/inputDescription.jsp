<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Phân tích kỹ năng</title>
</head>
<body>
<h2>🧠 Nhập mô tả hoặc upload CV</h2>

<form action="SkillAnalysisServlet" method="post" enctype="multipart/form-data">
    <label>Mô tả kỹ năng:</label><br>
    <textarea name="description" rows="5" cols="60"></textarea><br><br>

    <label>Upload CV (.pdf, .docx):</label>
    <input type="file" name="cvFile" accept=".pdf,.doc,.docx"><br><br>

    <input type="submit" value="Phân tích kỹ năng">
</form>
</body>
</html>
