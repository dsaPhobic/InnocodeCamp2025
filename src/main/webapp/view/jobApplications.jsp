<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Applications | GlobalWorks</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        /* ===== Layout tổng thể ===== */
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
            font-size: 1.125rem;
            color: #dbeafe;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1.5rem;
        }

        /* ===== Main Content ===== */
        .main-content {
            padding: 2rem;
        }

        /* ===== Stats Cards ===== */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: #fff;
            border-radius: 1rem;
            box-shadow: 0 2px 8px rgba(16, 30, 54, 0.08), 0 1.5px 4px rgba(16, 30, 54, 0.04);
            padding: 1.5rem;
            display: flex;
            align-items: center;
            border: 1px solid #e5e7eb;
        }

        .stat-icon {
            padding: 0.75rem;
            border-radius: 9999px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            color: #fff;
        }

        .stat-icon.applied {
            background: linear-gradient(to right, #2563eb, #7c3aed);
        }

        .stat-icon.pending {
            background: linear-gradient(to right, #f59e0b, #ea580c);
        }

        .stat-icon.accepted {
            background: linear-gradient(to right, #22c55e, #16a34a);
        }

        .stat-icon.rejected {
            background: linear-gradient(to right, #ef4444, #dc2626);
        }

        .stat-title {
            font-size: 0.95rem;
            color: #64748b;
            margin-bottom: 0.25rem;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: bold;
            color: #1e293b;
        }

        /* ===== Applications List ===== */
        .applications-section {
            background: #fff;
            border-radius: 1rem;
            box-shadow: 0 2px 8px rgba(16, 30, 54, 0.08), 0 1.5px 4px rgba(16, 30, 54, 0.04);
            border: 1px solid #e5e7eb;
            overflow: hidden;
        }

        .section-header {
            padding: 1.5rem;
            border-bottom: 1px solid #e5e7eb;
            background: #f8fafc;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1e293b;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 0.5rem;
            color: #2563eb;
        }

        /* ===== Application Cards ===== */
        .application-card {
            padding: 1.5rem;
            border-bottom: 1px solid #e5e7eb;
            transition: background-color 0.2s;
        }

        .application-card:hover {
            background: #f8fafc;
        }

        .application-card:last-child {
            border-bottom: none;
        }

        .app-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .app-info {
            flex: 1;
        }

        .job-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 0.25rem;
        }

        .company-name {
            color: #64748b;
            font-size: 0.95rem;
            margin-bottom: 0.5rem;
        }

        .app-meta {
            display: flex;
            gap: 1rem;
            font-size: 0.875rem;
            color: #64748b;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
            text-transform: uppercase;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-accepted {
            background: #dcfce7;
            color: #166534;
        }

        .status-rejected {
            background: #fee2e2;
            color: #991b1b;
        }

        .status-applied {
            background: #dbeafe;
            color: #1e40af;
        }

        .app-actions {
            display: flex;
            gap: 0.5rem;
        }

        .btn {
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            font-weight: 500;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
        }

        .btn-primary {
            background: #2563eb;
            color: #fff;
        }

        .btn-primary:hover {
            background: #1d4ed8;
        }

        .btn-secondary {
            background: #f1f5f9;
            color: #64748b;
            border: 1px solid #e2e8f0;
        }

        .btn-secondary:hover {
            background: #e2e8f0;
        }

        .btn-danger {
            background: #ef4444;
            color: #fff;
        }

        .btn-danger:hover {
            background: #dc2626;
        }

        /* ===== Empty State ===== */
        .empty-state {
            text-align: center;
            padding: 3rem 1.5rem;
            color: #64748b;
        }

        .empty-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #cbd5e1;
        }

        .empty-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #475569;
        }

        .empty-desc {
            margin-bottom: 1.5rem;
        }

        /* ===== Modal ===== */
        .modal {
            display: none;
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(30, 41, 59, 0.18);
            backdrop-filter: blur(2px);
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background: #fff;
            max-width: 480px;
            width: 95vw;
            border-radius: 1.2rem;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
            padding: 2rem;
            position: relative;
        }

        .modal-close {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: none;
            border: none;
            font-size: 1.5rem;
            color: #64748b;
            cursor: pointer;
            padding: 0.5rem;
            border-radius: 0.5rem;
            transition: background-color 0.2s;
        }

        .modal-close:hover {
            background: #f1f5f9;
        }

        .modal-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 1rem;
        }

        .modal-body {
            color: #64748b;
            line-height: 1.6;
        }

        /* ===== Responsive ===== */
        @media (max-width: 768px) {
            .hero h1 {
                font-size: 2rem;
            }
            
            .app-header {
                flex-direction: column;
                gap: 1rem;
            }
            
            .app-actions {
                justify-content: flex-start;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }

        /* ===== Message ===== */
        .message {
            padding: 1rem 1.5rem;
            border-radius: 0.75rem;
            margin-bottom: 1.5rem;
            font-weight: 500;
        }

        .message.success {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .message.error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }
    </style>
</head>
<body>
    <jsp:include page="/view/includes/navbar.jsp" />

    <div class="hero">
        <div class="container">
            <h1>My Applications 📋</h1>
            <p>Track your job applications and their current status</p>
        </div>
    </div>

    <div class="main-content">
        <div class="container">
            <!-- Hiển thị thông báo nếu có -->
            <c:if test="${not empty message}">
                <div class="message success">${message}</div>
            </c:if>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon applied">
                        <i data-lucide="briefcase"></i>
                    </div>
                    <div>
                        <div class="stat-title">Total Applied</div>
                        <div class="stat-value">${fn:length(applications)}</div>
                    </div>
                </div>

                <c:set var="pendingCount" value="0" />
                <c:set var="acceptedCount" value="0" />
                <c:set var="rejectedCount" value="0" />
                
                <c:forEach var="app" items="${applications}">
                    <c:choose>
                        <c:when test="${app.status == 'Pending'}">
                            <c:set var="pendingCount" value="${pendingCount + 1}" />
                        </c:when>
                        <c:when test="${app.status == 'Accepted'}">
                            <c:set var="acceptedCount" value="${acceptedCount + 1}" />
                        </c:when>
                        <c:when test="${app.status == 'Rejected'}">
                            <c:set var="rejectedCount" value="${rejectedCount + 1}" />
                        </c:when>
                    </c:choose>
                </c:forEach>

                <div class="stat-card">
                    <div class="stat-icon pending">
                        <i data-lucide="clock"></i>
                    </div>
                    <div>
                        <div class="stat-title">Pending</div>
                        <div class="stat-value">${pendingCount}</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon accepted">
                        <i data-lucide="check-circle"></i>
                    </div>
                    <div>
                        <div class="stat-title">Accepted</div>
                        <div class="stat-value">${acceptedCount}</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon rejected">
                        <i data-lucide="x-circle"></i>
                    </div>
                    <div>
                        <div class="stat-title">Rejected</div>
                        <div class="stat-value">${rejectedCount}</div>
                    </div>
                </div>
            </div>

            <!-- Applications List -->
            <div class="applications-section">
                <div class="section-header">
                    <div class="section-title">
                        <i data-lucide="list"></i>
                        Application History
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty applications}">
                        <c:forEach var="app" items="${applications}">
                            <div class="application-card">
                                <div class="app-header">
                                    <div class="app-info">
                                        <div class="job-title">${app.job.title}</div>
                                        <div class="company-name">${app.job.company}</div>
                                        <div class="app-meta">
                                            <div class="meta-item">
                                                <i data-lucide="map-pin" style="width: 14px;"></i>
                                                <c:set var="parts" value="${fn:split(app.job.location, ',')}" />
                                                <c:set var="city" value="${parts[fn:length(parts)-1]}" />
                                                <c:set var="city" value="${fn:replace(city, 'TP.', '')}" />
                                                <c:set var="city" value="${fn:replace(city, 'Thành phố', '')}" />
                                                <span>${fn:trim(city)}</span>
                                            </div>
                                            <div class="meta-item">
                                                <i data-lucide="calendar" style="width: 14px;"></i>
                                                <span>${app.appliedAt}</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="app-actions">
                                        <span class="status-badge status-${fn:toLowerCase(app.status)}">${app.status}</span>
                                    </div>
                                </div>
                                <div class="app-actions">
                                    <button class="btn btn-primary btn-detail" data-app-id="${app.jobId}">
                                        <i data-lucide="eye" style="width: 14px;"></i>
                                        View Details
                                    </button>
                                    <button class="btn btn-secondary btn-cancel" data-app-id="${app.jobId}">
                                        <i data-lucide="x" style="width: 14px;"></i>
                                        Cancel
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i data-lucide="briefcase"></i>
                            </div>
                            <div class="empty-title">No applications yet</div>
                            <div class="empty-desc">Start your job search journey by applying to positions that match your skills</div>
                            <a href="${pageContext.request.contextPath}/JobRecommendationServlet" class="btn btn-primary">
                                <i data-lucide="search" style="width: 14px;"></i>
                                Find Jobs
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Modal chi tiết ứng tuyển -->
    <div id="detailModal" class="modal">
        <div class="modal-content">
            <button id="closeDetailModal" class="modal-close">&times;</button>
            <div class="modal-title">Application Details</div>
            <div id="detailBody" class="modal-body">Đang tải...</div>
        </div>
    </div>

    <script>
        lucide.createIcons();

        // Mở modal chi tiết
        const detailModal = document.getElementById('detailModal');
        const detailBody = document.getElementById('detailBody');
        
        document.querySelectorAll('.btn-detail').forEach(btn => {
            btn.onclick = function() {
                const appId = btn.getAttribute('data-app-id');
                const card = btn.closest('.application-card');
                const title = card.querySelector('.job-title').textContent;
                const company = card.querySelector('.company-name').textContent;
                const status = card.querySelector('.status-badge').textContent;
                const appliedAt = card.querySelector('.meta-item:last-child span').textContent;
                
                detailBody.innerHTML = `
                    <div style="margin-bottom: 1rem;">
                        <strong style="color: #1e293b;">Job Title:</strong><br>
                        <span style="color: #2563eb; font-weight: 600;">${title}</span>
                    </div>
                    <div style="margin-bottom: 1rem;">
                        <strong style="color: #1e293b;">Company:</strong><br>
                        <span style="color: #64748b;">${company}</span>
                    </div>
                    <div style="margin-bottom: 1rem;">
                        <strong style="color: #1e293b;">Status:</strong><br>
                        <span class="status-badge status-${status.toLowerCase()}">${status}</span>
                    </div>
                    <div style="margin-bottom: 1rem;">
                        <strong style="color: #1e293b;">Applied Date:</strong><br>
                        <span style="color: #64748b;">${appliedAt}</span>
                    </div>
                    <div style="margin-top: 1.5rem; padding: 1rem; background: #f8fafc; border-radius: 0.5rem; border-left: 4px solid #2563eb;">
                        <div style="font-size: 0.875rem; color: #64748b;">
                            <strong>💡 Tip:</strong> To get more detailed updates, contact the recruiter directly or check your email for any communications from the company.
                        </div>
                    </div>
                `;
                detailModal.style.display = 'flex';
            };
        });

        // Đóng modal
        document.getElementById('closeDetailModal').onclick = function() {
            detailModal.style.display = 'none';
        };

        // Đóng modal khi click bên ngoài
        detailModal.onclick = function(e) {
            if (e.target === detailModal) {
                detailModal.style.display = 'none';
            }
        };

        // Hủy ứng tuyển
        const cancelBtns = document.querySelectorAll('.btn-cancel');
        cancelBtns.forEach(btn => {
            btn.onclick = function() {
                const appId = btn.getAttribute('data-app-id');
                const card = btn.closest('.application-card');
                const jobTitle = card.querySelector('.job-title').textContent;
                
                if (confirm(`Are you sure you want to cancel your application for "${jobTitle}"?`)) {
                    // Gửi AJAX tới DeleteApplicationServlet
                    fetch('DeleteApplicationServlet', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'jobId=' + encodeURIComponent(appId)
                    })
                    .then(res => res.text())
                    .then(result => {
                        if (result.trim() === 'success') {
                            alert('Application cancelled successfully!');
                            location.reload();
                        } else {
                            alert('Unable to cancel application.');
                        }
                    })
                    .catch(() => alert('Server connection error.'));
                }
            };
        });

        // Toggle user menu (nếu có)
        function toggleUserMenu() {
            const menu = document.getElementById("userMenu");
            if (menu) {
                menu.classList.toggle("hidden");
            }
        }

        window.addEventListener("click", function (e) {
            const menu = document.getElementById("userMenu");
            const icon = document.querySelector(".user-icon");
            if (menu && icon && !menu.contains(e.target) && !icon.contains(e.target)) {
                menu.classList.add("hidden");
            }
        });
    </script>
</body>
</html>
