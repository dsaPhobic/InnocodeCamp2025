<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, model.Skill" %>
<%
    List<Skill> skills = (List<Skill>) request.getAttribute("skills");
    String jsSkillLabels = "[]";
    String jsSkillScores = "[]";
    if (skills != null && !skills.isEmpty()) {
        StringBuilder labels = new StringBuilder("[");
        StringBuilder scores = new StringBuilder("[");
        for (int i = 0; i < skills.size(); i++) {
            Skill s = skills.get(i);
            labels.append("'" + s.getSkillName() + "'");
            scores.append(s.getScore());
            if (i < skills.size() - 1) {
                labels.append(", ");
                scores.append(", ");
            }
        }
        labels.append("]");
        scores.append("]");
        jsSkillLabels = labels.toString();
        jsSkillScores = scores.toString();
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Biểu đồ kỹ năng</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="${pageContext.request.contextPath}/js/chart.js"></script>
    <style>
        body {
            font-family: 'Inter', Arial, sans-serif;
            background: linear-gradient(135deg, #e0e7ff 0%, #f8fafc 100%);
            margin: 0;
        }
        .chart-container {
            width: 100%;
            max-width: 520px;
            margin: 48px auto 0 auto;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 6px 32px rgba(127,85,177,0.10);
            padding: 36px 32px 28px 32px;
            min-height: 520px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        h2 {
            text-align: center;
            color: #3b3b5c;
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 18px;
            letter-spacing: 0.5px;
        }
        .chart-legend {
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.1rem;
            color: #4b5563;
        }
        .legend-color {
            width: 24px;
            height: 12px;
            border-radius: 6px;
            background: linear-gradient(90deg, #38bdf8, #6366f1);
            display: inline-block;
            border: 1.5px solid #2563eb;
        }
        @media (max-width: 600px) {
            .chart-container {
                padding: 18px 4px 12px 4px;
                min-height: 320px;
            }
            h2 { font-size: 1.2rem; }
        }
    </style>
</head>
<body>
    <div class="chart-container">
        <h2>Biểu đồ kỹ năng cá nhân</h2>
        <div class="chart-legend">
            <span class="legend-color"></span> Điểm kỹ năng
        </div>
        <canvas id="radarChart" width="400" height="400"></canvas>
    </div>
    <script>
        const skillLabels = <%= jsSkillLabels %>;
        const skillScores = <%= jsSkillScores %>;
        window.onload = function() {
            renderRadarChart(skillLabels, skillScores);
        }
    </script>
</body>
</html>
