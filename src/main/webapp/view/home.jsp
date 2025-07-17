<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home | GlobalWorks</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../auth-home.css">
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body class="home-bg">
    <div class="home-container fade-in">
        <header class="home-header">
            <h1>Welcome, <span class="user-name">${sessionScope.user.fullname}</span>!</h1>
            <p class="subtitle">Empowering digital citizens to discover meaningful international career opportunities through AI-powered skill profiling and job matching.</p>
        </header>
        <main class="card-grid">
            <a href="inputDescription.jsp" class="nav-card">
                <i data-lucide="edit-3"></i>
                <span>Update Description</span>
            </a>
            <a href="skillResult.jsp" class="nav-card">
                <i data-lucide="brain-cog"></i>
                <span>Analyze Skills</span>
            </a>
            <a href="skillChart.jsp" class="nav-card">
                <i data-lucide="radar"></i>
                <span>Skill Radar Chart</span>
            </a>
            <a href="jobSuggestions.jsp" class="nav-card">
                <i data-lucide="briefcase"></i>
                <span>Job Suggestions</span>
            </a>
            <a href="viewJobs.jsp" class="nav-card">
                <i data-lucide="folder-open"></i>
                <span>Matching Job List</span>
            </a>
            <a href="chatbot.jsp" class="nav-card">
                <i data-lucide="message-circle"></i>
                <span>Career Chatbot</span>
            </a>
            <a href="../LogoutServlet" class="nav-card logout-card">
                <i data-lucide="log-out"></i>
                <span>Logout</span>
            </a>
        </main>
    </div>
    <div class="globe-bg">
        <!-- Optional: Animated SVG globe or wave background -->
        <svg viewBox="0 0 1440 320" class="wave-svg"><path fill="#667eea" fill-opacity="0.3" d="M0,160L60,170.7C120,181,240,203,360,197.3C480,192,600,160,720,133.3C840,107,960,85,1080,101.3C1200,117,1320,171,1380,197.3L1440,224L1440,320L1380,320C1320,320,1200,320,1080,320C960,320,840,320,720,320C600,320,480,320,360,320C240,320,120,320,60,320L0,320Z"></path></svg>
    </div>
    <script src="js/auth-home.js"></script>
    <script>lucide.createIcons();</script>
</body>
</html>
