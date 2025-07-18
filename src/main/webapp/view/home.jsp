<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Home | GlobalWorks</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
        <script src="https://unpkg.com/lucide@latest"></script>
    </head>
    <body>
        <jsp:include page="/view/includes/navbar.jsp" />

        <div class="hero">
            <h1>Welcome back, ${sessionScope.user.fullname}! 👋</h1>
            <p>Ready to advance your IT career? Explore our tools and find your next opportunity.</p>
        </div>

        <div class="main-grid">
            <!-- Features Section -->
            <div>
                <div class="features-title">Quick Actions</div>
                <div class="feature-cards">
                    <a href="${pageContext.request.contextPath}/SkillAnalysisServlet" class="feature-card">
                        <span class="feature-icon"><i data-lucide="upload"></i></span>
                        <span class="feature-title">Skills Analysis</span>
                        <div class="feature-desc">Upload your CV or describe your experience to analyze your skills</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/JobRecommendationServlet" class="feature-card">
                        <span class="feature-icon"><i data-lucide="search"></i></span>
                        <span class="feature-title">Job Recommendations</span>
                        <div class="feature-desc">Get personalized job recommendations based on your skills</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/SkillChartServlet" class="feature-card">
                        <span class="feature-icon"><i data-lucide="bar-chart-3"></i></span>
                        <span class="feature-title">Skills Chart</span>
                        <div class="feature-desc">Visualize your skills with interactive radar charts</div>
                    </a>   
                    <a href="${pageContext.request.contextPath}/jobApplications.jsp" class="feature-card">
                        <span class="feature-icon"><i data-lucide="briefcase"></i></span>
                        <span class="feature-title">My Applications</span>
                        <div class="feature-desc">Track your job applications and their status</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/chat2.jsp" class="feature-card">
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
                            <c:forEach var="skill" items="${userSkills}" varStatus="i">
                                <c:if test="${i.index < 4}">
                                    <div class="skill-row">
                                        <span>${skill.skillName}</span>
                                        <div style="display:flex;align-items:center;">
                                            <div class="skill-bar-bg">
                                                <div class="skill-bar" style="width:${skill.score}%;"></div>
                                            </div>
                                            <span style="font-size:0.85rem;color:#64748b;">${skill.score}%</span>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="job-company">
                                No skills yet.
                                <a href="${pageContext.request.contextPath}/view/inputDescription.jsp" class="add-skills-link">Add your skills</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <script>
            lucide.createIcons();

            function toggleUserMenu() {
                const menu = document.getElementById("userMenu");
                menu.classList.toggle("hidden");
            }

            window.addEventListener("click", function (e) {

                const menu = document.getElementById("userMenu");
                const icon = document.querySelector(".user-icon");
                if (!menu.contains(e.target) && !icon.contains(e.target)) {
                    menu.classList.add("hidden");
                }
            });
        </script>
        <script src="../js/chart.js"></script>
        <jsp:include page="/chat1.jsp" />
    </body>
</html>
