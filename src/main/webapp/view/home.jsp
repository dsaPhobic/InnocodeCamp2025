<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
                    <a href="${pageContext.request.contextPath}/JobApplicationsServlet" class="feature-card">
                        <span class="feature-icon"><i data-lucide="briefcase"></i></span>
                        <span class="feature-title">My Applications</span>
                        <div class="feature-desc">Track your job applications and their status</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/chat2.jsp" class="feature-card">
                        <span class="feature-icon"><i data-lucide="message-square"></i></span>
                        <span class="feature-title">Career Chatbot</span>
                        <div class="feature-desc">Get AI-powered career guidance and advice</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/VirtualInterviewServlet" class="feature-card">
                        <span class="feature-icon"><i data-lucide="mic"></i></span>
                        <span class="feature-title">Phỏng vấn Ảo</span>
                        <div class="feature-desc">Rèn luyện kỹ năng phỏng vấn với AI chuyên nghiệp</div>
                    </a>
                </div>
            </div>

            <!-- Sidebar: Recent Jobs & Top Skills -->
            <div class="sidebar">
                <div class="card">
                    <div class="card-title"><i data-lucide="trending-up" class="text-blue-600"></i>Recent Jobs</div>
                    <c:choose>
                        <c:when test="${not empty recentJobs}">
                            <c:forEach var="job" items="${recentJobs}" varStatus="i">
                                <c:if test="${i.index < 3}">
                                    <div class="recent-job">
                                        <div class="job-title">
                                            <a href="${pageContext.request.contextPath}/JobRecommendationServlet?jobId=${job.id}" style="color:inherit;text-decoration:none;cursor:pointer;">
                                                ${job.title}
                                            </a>
                                        </div>
                                        <div class="job-company">${job.company}</div>
                                        <div class="job-meta">
                                            <i data-lucide="map-pin" style="width:14px;"></i>
                                            <c:set var="parts" value="${fn:split(job.location, ',')}" />
                                            <c:set var="city" value="${parts[fn:length(parts)-1]}" />
                                            <c:set var="city" value="${fn:replace(city, 'TP.', '')}" />
                                            <c:set var="city" value="${fn:replace(city, 'Thành phố', '')}" />
                                            <span>${fn:trim(city)}</span>
                                            <i data-lucide="clock" style="width:14px;"></i>
                                            <c:choose>
                                                <c:when test="${not empty job.postedAt}">
                                                    ${job.postedAt}
                                                </c:when>
                                                <c:otherwise>
                                                    N/A
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:if>
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
        </div>

        <!-- Beautiful Footer -->
        <footer class="footer">
            <div class="footer-waves">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
                    <path fill="#667eea" fill-opacity="0.1" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,122.7C672,117,768,139,864,154.7C960,171,1056,181,1152,165.3C1248,149,1344,107,1392,85.3L1440,64L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path>
                </svg>
            </div>
            
            <div class="footer-content">
                <div class="footer-section">
                    <div class="footer-logo">
                        <h3>GlobalWorks</h3>
                        <p>Empowering IT professionals to reach their full potential</p>
                    </div>
                    <div class="social-links">
                        <a href="#" class="social-link">
                            <i data-lucide="facebook"></i>
                        </a>
                        <a href="#" class="social-link">
                            <i data-lucide="twitter"></i>
                        </a>
                        <a href="#" class="social-link">
                            <i data-lucide="linkedin"></i>
                        </a>
                        <a href="#" class="social-link">
                            <i data-lucide="github"></i>
                        </a>
                    </div>
                </div>
                
                <div class="footer-section">
                    <h4>Features</h4>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/SkillAnalysisServlet">Skills Analysis</a></li>
                        <li><a href="${pageContext.request.contextPath}/JobRecommendationServlet">Job Recommendations</a></li>
                        <li><a href="${pageContext.request.contextPath}/SkillChartServlet">Skills Chart</a></li>
                        <li><a href="${pageContext.request.contextPath}/JobApplicationsServlet">My Applications</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h4>Resources</h4>
                    <ul>
                        <li><a href="#">Career Guide</a></li>
                        <li><a href="#">Interview Tips</a></li>
                        <li><a href="#">Resume Builder</a></li>
                        <li><a href="#">Salary Calculator</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h4>Support</h4>
                    <ul>
                        <li><a href="#">Help Center</a></li>
                        <li><a href="#">Contact Us</a></li>
                        <li><a href="#">Privacy Policy</a></li>
                        <li><a href="#">Terms of Service</a></li>
                    </ul>
                </div>
            </div>
            
            <div class="footer-bottom">
                <div class="footer-bottom-content">
                    <p>&copy; 2025 GlobalWorks. All rights reserved.</p>
                    <div class="footer-stats">
                        <span><i data-lucide="users"></i> 10,000+ Users</span>
                        <span><i data-lucide="briefcase"></i> 50,000+ Jobs</span>
                        <span><i data-lucide="award"></i> 95% Success Rate</span>
                    </div>
                </div>
            </div>
        </footer>

        <style>
            .footer {
                position: relative;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                margin-top: 80px;
                overflow: hidden;
            }

            .footer-waves {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100px;
                overflow: hidden;
            }

            .footer-waves svg {
                position: relative;
                display: block;
                width: calc(100% + 1.3px);
                height: 100px;
            }

            .footer-content {
                position: relative;
                z-index: 2;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 40px;
                padding: 60px 40px 40px;
                max-width: 1200px;
                margin: 0 auto;
            }

            .footer-section h4 {
                color: white;
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 20px;
                position: relative;
            }

            .footer-section h4::after {
                content: '';
                position: absolute;
                bottom: -8px;
                left: 0;
                width: 30px;
                height: 3px;
                background: rgba(255, 255, 255, 0.3);
                border-radius: 2px;
            }

            .footer-logo h3 {
                font-size: 24px;
                font-weight: 700;
                margin-bottom: 12px;
                background: linear-gradient(135deg, #ffffff 0%, #f0f0f0 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .footer-logo p {
                color: rgba(255, 255, 255, 0.8);
                line-height: 1.6;
                margin-bottom: 20px;
            }

            .social-links {
                display: flex;
                gap: 12px;
            }

            .social-link {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 40px;
                height: 40px;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 50%;
                color: white;
                text-decoration: none;
                transition: all 0.3s ease;
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .social-link:hover {
                background: rgba(255, 255, 255, 0.2);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            }

            .social-link i {
                width: 18px;
                height: 18px;
            }

            .footer-section ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .footer-section ul li {
                margin-bottom: 12px;
            }

            .footer-section ul li a {
                color: rgba(255, 255, 255, 0.8);
                text-decoration: none;
                transition: all 0.3s ease;
                display: inline-block;
                position: relative;
            }

            .footer-section ul li a:hover {
                color: white;
                transform: translateX(5px);
            }

            .footer-section ul li a::before {
                content: '';
                position: absolute;
                bottom: -2px;
                left: 0;
                width: 0;
                height: 1px;
                background: white;
                transition: width 0.3s ease;
            }

            .footer-section ul li a:hover::before {
                width: 100%;
            }

            .footer-bottom {
                position: relative;
                z-index: 2;
                background: rgba(0, 0, 0, 0.1);
                padding: 20px 40px;
                backdrop-filter: blur(10px);
                border-top: 1px solid rgba(255, 255, 255, 0.1);
            }

            .footer-bottom-content {
                max-width: 1200px;
                margin: 0 auto;
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 20px;
            }

            .footer-bottom p {
                color: rgba(255, 255, 255, 0.8);
                margin: 0;
            }

            .footer-stats {
                display: flex;
                gap: 20px;
                flex-wrap: wrap;
            }

            .footer-stats span {
                display: flex;
                align-items: center;
                gap: 6px;
                color: rgba(255, 255, 255, 0.8);
                font-size: 14px;
            }

            .footer-stats i {
                width: 16px;
                height: 16px;
            }

            /* Floating particles in footer */
            .footer::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="footer-grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.05)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.05)"/><circle cx="50" cy="10" r="0.5" fill="rgba(255,255,255,0.05)"/><circle cx="10" cy="60" r="0.5" fill="rgba(255,255,255,0.05)"/><circle cx="90" cy="40" r="0.5" fill="rgba(255,255,255,0.05)"/></pattern></defs><rect width="100" height="100" fill="url(%23footer-grain)"/></svg>');
                pointer-events: none;
                z-index: 1;
            }

            /* Responsive design */
            @media (max-width: 768px) {
                .footer-content {
                    grid-template-columns: 1fr;
                    gap: 30px;
                    padding: 40px 20px 30px;
                }

                .footer-bottom-content {
                    flex-direction: column;
                    text-align: center;
                }

                .footer-stats {
                    justify-content: center;
                }

                .social-links {
                    justify-content: center;
                }
            }

            @media (max-width: 480px) {
                .footer-content {
                    padding: 30px 15px 20px;
                }

                .footer-bottom {
                    padding: 15px 20px;
                }

                .footer-stats {
                    gap: 15px;
                }
            }

            /* Animation for footer elements */
            .footer-section {
                animation: fadeInUp 0.6s ease-out;
            }

            .footer-section:nth-child(1) { animation-delay: 0.1s; }
            .footer-section:nth-child(2) { animation-delay: 0.2s; }
            .footer-section:nth-child(3) { animation-delay: 0.3s; }
            .footer-section:nth-child(4) { animation-delay: 0.4s; }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>

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
