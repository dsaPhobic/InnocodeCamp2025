<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
            <a href="/SkillChartServlet"><i data-lucide="bar-chart-3"></i> Skills Chart</a>
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
                <a href="${pageContext.request.contextPath}/SettingsServlet"><i data-lucide="user"></i> H? s? c?a b?n</a>
                <hr>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout"><i data-lucide="log-out"></i>??ng Xu?t</a>
            </div>
        </div>
    </div>
</header>
<script>
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
