<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Home | GlobalWorks</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
        <script src="https://unpkg.com/lucide@latest"></script>
        <style>
            body {
                background: #f3f4f6;
                font-family: 'Inter', system-ui, sans-serif;
                margin: 0;
            }
            .hero {
                background: linear-gradient(to right, #2563eb, #7c3aed);
                color: #fff;
                padding: 3rem 0 2rem 0;
                text-align: center;
            }
            .hero h1 {
                font-size: 2.5rem;
                font-weight: bold;
                margin-bottom: 1rem;
            }
            .hero p {
                font-size: 1.25rem;
                color: #dbeafe;
            }
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 1.5rem;
            }
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 1.5rem;
                margin-top: -2.5rem;
                margin-bottom: 2rem;
            }
            .stat-card {
                background: #fff;
                border-radius: 1rem;
                box-shadow: 0 2px 8px #0001;
                padding: 1.5rem;
                display: flex;
                align-items: center;
            }
            .stat-icon {
                padding: 0.75rem;
                border-radius: 9999px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 1rem;
            }
            .stat-title {
                font-size: 0.95rem;
                color: #64748b;
            }
            .stat-value {
                font-size: 1.5rem;
                font-weight: bold;
                color: #222;
            }
            .main-grid {
                display: grid;
                grid-template-columns: 1fr 340px;
                gap: 2rem;
            }
            @media (max-width: 1000px) {
                .main-grid {
                    grid-template-columns: 1fr;
                }
            }
            .features-title {
                font-size: 1.3rem;
                font-weight: bold;
                margin-bottom: 1.5rem;
            }
            .feature-cards {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 1.25rem;
            }
            @media (max-width: 700px) {
                .feature-cards {
                    grid-template-columns: 1fr;
                }
            }
            .feature-card {
                display: block;
                background: #f1f5f9;
                border-radius: 0.75rem;
                padding: 1.25rem;
                border: 1px solid #e5e7eb;
                text-decoration: none;
                color: #222;
                transition: box-shadow .2s;
            }
            .feature-card:hover {
                box-shadow: 0 4px 16px #0002;
            }
            .feature-icon {
                padding: 0.75rem;
                border-radius: 0.75rem;
                background: linear-gradient(to right, #2563eb, #7c3aed);
                color: #fff;
                display: inline-flex;
                align-items: center;
                margin-right: 0.75rem;
            }
            .feature-title {
                font-size: 1.1rem;
                font-weight: 600;
            }
            .feature-desc {
                color: #64748b;
                font-size: 0.97rem;
                margin-top: 0.25rem;
            }
            .sidebar {
                display: flex;
                flex-direction: column;
                gap: 2rem;
            }
            .card {
                background: #fff;
                border-radius: 1rem;
                box-shadow: 0 2px 8px #0001;
                padding: 1.5rem;
            }
            .card-title {
                font-size: 1.1rem;
                font-weight: 600;
                margin-bottom: 1rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }
            .recent-job {
                border-left: 4px solid #2563eb;
                padding-left: 1rem;
                margin-bottom: 1rem;
            }
            .recent-job:last-child {
                margin-bottom: 0;
            }
            .job-title {
                font-weight: 500;
                font-size: 1rem;
            }
            .job-company {
                color: #64748b;
                font-size: 0.95rem;
            }
            .job-meta {
                color: #94a3b8;
                font-size: 0.85rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                margin-top: 0.25rem;
            }
            .skill-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 0.5rem;
            }
            .skill-bar-bg {
                width: 64px;
                height: 8px;
                background: #e5e7eb;
                border-radius: 9999px;
                margin-right: 0.5rem;
            }
            .skill-bar {
                height: 8px;
                background: #2563eb;
                border-radius: 9999px;
            }
            .add-skills-link {
                color: #2563eb;
                text-decoration: underline;
            }
            .bg-blue-100 {
                background: #dbeafe;
            }
            .bg-green-100 {
                background: #bbf7d0;
            }
            .bg-purple-100 {
                background: #ede9fe;
            }
            .bg-pink-100 {
                background: #fce7f3;
            }
            .text-blue-600 {
                color: #2563eb;
            }
            .text-green-600 {
                color: #22c55e;
            }
            .text-purple-600 {
                color: #a21caf;
            }
            .text-pink-600 {
                color: #db2777;
            }
            .text-yellow-600 {
                color: #eab308;
            }
            .navbar {
                background: white;
                box-shadow: 0 1px 4px rgba(0,0,0,0.05);
                padding: 0.75rem 1.5rem;
                position: sticky;
                top: 0;
                z-index: 50;
            }
            .navbar-container {
                max-width: 1200px;
                margin: auto;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
            .navbar-left {
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }
            .navbar-logo {
                width: 32px;
                height: 32px;
            }
            .navbar-brand {
                font-size: 1.2rem;
                font-weight: 700;
                color: #7c3aed;
            }
            .navbar-links {
                display: flex;
                align-items: center;
                gap: 1.25rem;
            }
            .navbar-links a {
                text-decoration: none;
                color: #334155;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 0.25rem;
            }
            .navbar-links a:hover {
                color: #2563eb;
            }
            .navbar-user {
                position: relative;
            }
            .user-icon {
                cursor: pointer;
                padding: 6px;
                border-radius: 9999px;
                transition: background 0.2s;
            }
            .user-icon:hover {
                background: #f3f4f6;
            }
            .user-menu {
                position: absolute;
                right: 0;
                top: 110%;
                background: white;
                border-radius: 0.75rem;
                box-shadow: 0 4px 16px rgba(0,0,0,0.1);
                width: 240px;
                padding: 1rem;
            }
            .user-menu a {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                text-decoration: none;
                padding: 0.5rem 0;
                color: #1e293b;
                font-size: 0.95rem;
            }
            .user-menu a:hover {
                background: #f3f4f6;
                border-radius: 0.5rem;
            }
            .user-info {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                margin-bottom: 0.75rem;
            }
            .avatar {
                width: 40px;
                height: 40px;
                border-radius: 9999px;
            }
            .user-name {
                font-weight: 600;
                color: #7c3aed;
            }
            .user-email {
                font-size: 0.85rem;
                color: #64748b;
            }
            .logout {
                color: #dc2626 !important;
            }
            .hidden {
                display: none;
            }

        </style>
    </head>
    <body>
        <!-- Navbar -->
        <header class="navbar">
            <div class="navbar-container">
                <div class="navbar-left">
                    <img src="${pageContext.request.contextPath}/assets/logo.png" alt="Logo" class="navbar-logo">
                    <span class="navbar-brand">InnocodeCamp</span>
                </div>
                <nav class="navbar-links">
                    <a href="${pageContext.request.contextPath}/HomeServlet"><i data-lucide="home"></i> Home</a>
                    <a href="${pageContext.request.contextPath}/view/inputDescription.jsp"><i data-lucide="upload"></i> Skills Analysis</a>
                    <a href="jobSuggestions.jsp"><i data-lucide="search"></i> Job Recommendations</a>
                    <a href="${pageContext.request.contextPath}/SkillChartServlet"><i data-lucide="bar-chart-3"></i> Skills Chart</a>
                    <a href="jobApplications.jsp"><i data-lucide="briefcase"></i> My Applications</a>
                    <a href="chatbot.jsp"><i data-lucide="message-square"></i> Career Chatbot</a>
                </nav>
                <div class="navbar-user">
                    <div class="user-icon" onclick="toggleUserMenu()">
                        <i data-lucide="user"></i>
                    </div>
                    <div id="userMenu" class="user-menu hidden">
                        <div class="user-info">
                            <img src="${pageContext.request.contextPath}/assets/avatar.png" class="avatar">
                            <div>
                                <div class="user-name">${sessionScope.user.fullname}</div>
                                <div class="user-email">${sessionScope.user.email}</div>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/SettingsServlet"><i data-lucide="user"></i> Hồ sơ của bạn</a>
                        <hr>
                        <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout"><i data-lucide="log-out"></i> Đăng xuất</a>

                    </div>
                </div>
            </div>
        </header>


        <div class="hero">
            <h1>Welcome back, ${sessionScope.user.fullname}! 👋</h1>
            <p>Ready to advance your IT career? Explore our tools and find your next opportunity.</p>
        </div>
        <div class="container">
            <!-- Stats Section -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon bg-blue-100"><i data-lucide="briefcase" class="text-blue-600"></i></div>
                    <div>
                        <div class="stat-title">Recent Jobs</div>
                        <div class="stat-value">${stats.totalJobs}</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon bg-green-100"><i data-lucide="file-text" class="text-green-600"></i></div>
                    <div>
                        <div class="stat-title">Applications</div>
                        <div class="stat-value">${stats.totalApplications}</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon bg-purple-100"><i data-lucide="bar-chart-3" class="text-purple-600"></i></div>
                    <div>
                        <div class="stat-title">Skills</div>
                        <div class="stat-value">${stats.totalSkills}</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon bg-pink-100"><i data-lucide="message-square" class="text-pink-600"></i></div>
                    <div>
                        <div class="stat-title">Chat Sessions</div>
                        <div class="stat-value">${stats.totalChats}</div>
                    </div>
                </div>
            </div>
            <div class="main-grid">
                <!-- Features Section -->
                <div>
                    <div class="features-title">Quick Actions</div>
                    <div class="feature-cards">
                        <a href="${pageContext.request.contextPath}/view/inputDescription.jsp" class="feature-card">
                            <span class="feature-icon"><i data-lucide="upload"></i></span>
                            <span class="feature-title">Skills Analysis</span>
                            <div class="feature-desc">Upload your CV or describe your experience to analyze your skills</div>
                        </a>

                        <a href="../jobSuggestions.jsp" class="feature-card">
                            <span class="feature-icon"><i data-lucide="search"></i></span>
                            <span class="feature-title">Job Recommendations</span>
                            <div class="feature-desc">Get personalized job recommendations based on your skills</div>
                        </a>
                        <a href="${pageContext.request.contextPath}/SkillChartServlet" class="feature-card">
                            <span class="feature-icon"><i data-lucide="bar-chart-3"></i></span>
                            <span class="feature-title">Skills Chart</span>
                            <div class="feature-desc">Visualize your skills with interactive radar charts</div>
                        </a>
                        <a href="../jobApplications.jsp" class="feature-card">
                            <span class="feature-icon"><i data-lucide="briefcase"></i></span>
                            <span class="feature-title">My Applications</span>
                            <div class="feature-desc">Track your job applications and their status</div>
                        </a>
                        <a href="../chatbot.jsp" class="feature-card">
                            <span class="feature-icon"><i data-lucide="message-square"></i></span>
                            <span class="feature-title">Career Chatbot</span>
                            <div class="feature-desc">Get AI-powered career guidance and advice</div>
                        </a>
                    </div>
                </div>
                <!-- Sidebar: Recent Jobs & Top Skills -->
                <div class="sidebar">
                    <div class="card">
                        <div class="card-title"><i data-lucide="trending-up" class="text-blue-600"></i>Recent Jobs</div>
                        <c:choose>
                            <c:when test="${not empty recentJobs}">
                                <c:forEach var="job" items="${recentJobs}">
                                    <div class="recent-job">
                                        <div class="job-title">${job.title}</div>
                                        <div class="job-company">${job.company}</div>
                                        <div class="job-meta">
                                            <i data-lucide="map-pin" style="width:14px;"></i> ${job.location}
                                            <i data-lucide="clock" style="width:14px;"></i> ${job.created_at}
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="job-company">No recent jobs available</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card">
                        <div class="card-title"><i data-lucide="star" class="text-yellow-600"></i>Your Top Skills</div>
                        <c:choose>
                            <c:when test="${not empty userSkills}">
                                <c:forEach var="skill" items="${userSkills}" begin="0" end="4">
                                    <div class="skill-row">
                                        <span>${skill.skill_name}</span>
                                        <div style="display:flex;align-items:center;">
                                            <div class="skill-bar-bg">
                                                <div class="skill-bar" style="width:${skill.score}%;"></div>
                                            </div>
                                            <span style="font-size:0.85rem;color:#64748b;">${skill.score}%</span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="job-company">
                                    No skills yet.
                                    <a href="../inputDescription.jsp" class="add-skills-link">Add your skills</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
        <script>lucide.createIcons();</script>
        <script>
            lucide.createIcons();
            function toggleUserMenu() {
                const menu = document.getElementById("userMenu");
                menu.classList.toggle("hidden");
            }
            // Auto close khi click ngoài
            window.addEventListener("click", function (e) {
                const menu = document.getElementById("userMenu");
                const icon = document.querySelector(".user-icon");
                if (!menu.contains(e.target) && !icon.contains(e.target)) {
                    menu.classList.add("hidden");
                }
            });
        </script>

    </body>
</html>
