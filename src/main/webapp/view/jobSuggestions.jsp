<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Việc làm gợi ý</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/jobSuggestions.css" />
</head>
<body>
<div class="jobsearch-hero" style="background: linear-gradient(to right, #2563eb, #7c3aed); color: #fff; padding: 2rem 0 1rem 0; text-align: center;">
    <h2 style="margin:0;font-size:2rem;font-weight:600;">Khám phá việc làm phù hợp cho bạn</h2>
    <p style="color:#dbeafe;">Tìm kiếm và ứng tuyển công việc IT mơ ước!</p>
</div>
<!-- Thanh search sát đỉnh đầu -->
<div style="width:100%;display:flex;justify-content:center;background:#f3f4f6;padding:0.5rem 0 0.5rem 0;">
    <form action="JobRecommendationServlet" method="get" style="display:flex;gap:1rem;align-items:center;max-width:700px;width:100%;background:#fff;padding:0.7rem 1.2rem;border-radius:1rem;box-shadow:0 2px 8px #0001;">
        <input type="text" name="title" placeholder="Tìm theo tiêu đề công việc..." style="flex:2;padding:0.7rem 1rem;border-radius:8px;border:1px solid #d1d5db;font-size:1rem;">
        <input type="text" name="location" placeholder="Tìm theo địa chỉ cụ thể..." style="flex:1;padding:0.7rem 1rem;border-radius:8px;border:1px solid #d1d5db;font-size:1rem;">
        <button type="submit" style="background:linear-gradient(to right,#2563eb,#7c3aed);color:#fff;padding:0.7rem 2rem;border:none;border-radius:8px;font-weight:600;font-size:1rem;cursor:pointer;">Tìm kiếm</button>
    </form>
</div>
<div class="container" style="max-width:1200px;margin:0 auto;">
    <!-- Thanh search -->
    <div style="display:flex;gap:2rem;">
        <!-- Sidebar: Danh sách job -->
        <div class="sidebar" style="flex:1;min-width:320px;background:#fff;border-radius:1rem;box-shadow:0 2px 8px #0001;padding:1rem;max-height:80vh;overflow-y:auto;">
            <c:forEach var="rec" items="${recommendations}">
                <div class="job-card" data-job-id="${rec.job.id}" style="display:flex;align-items:flex-start;gap:1rem;padding:1.2rem 1rem 1rem 1rem;border-radius:1rem;border:1px solid #e5e7eb;margin-bottom:1.2rem;box-shadow:0 2px 8px #0001;cursor:pointer;transition:box-shadow .2s;">
                    <div style="width:48px;height:48px;background:#dbeafe;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:1.5rem;color:#2563eb;font-weight:700;">
                        <span>${fn:substring(rec.job.company,0,1)}</span>
                    </div>
                    <div style="flex:1;">
                        <div class="job-title" style="font-size:1.1rem;font-weight:600;color:#2563eb;">${rec.job.title}</div>
                        <div style="color:#64748b;font-size:0.97rem;">${rec.job.company}</div>
                        <div style="display:flex;gap:0.5rem;margin:0.5rem 0 0.2rem 0;align-items:center;flex-wrap:wrap;">
                            <c:if test="${rec.job.salary > 0}">
                                <span style="background:#bbf7d0;color:#22c55e;padding:2px 12px;border-radius:8px;font-size:1rem;font-weight:600;">
                                    <c:choose>
                                        <c:when test="${rec.job.salary >= 1000000}">
                                            <c:out value="${rec.job.salary/1000000}"/> triệu
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${rec.job.salary}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </c:if>
                            <c:if test="${not empty rec.job.location}">
                                <span style="background:#dbeafe;color:#2563eb;padding:2px 12px;border-radius:8px;font-size:1rem;display:flex;align-items:center;"><i data-lucide='map-pin' style='width:15px;margin-right:3px;'></i>${rec.job.location}</span>
                            </c:if>
                            <c:if test="${not empty rec.job.experience}">
                                <span style="background:#ede9fe;color:#a21caf;padding:2px 12px;border-radius:8px;font-size:1rem;">${rec.job.experience}</span>
                            </c:if>
                        </div>
                        <c:if test="${not empty rec.job.skillRequired}">
                            <div style="margin-top:0.3rem;color:#64748b;font-size:0.95rem;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:220px;">${rec.job.skillRequired}</div>
                        </c:if>
                    </div>
                    <div style="display:flex;flex-direction:column;gap:0.5rem;align-items:flex-end;">
                        <button class="btn btn-primary btn-preview" data-job-id="${rec.job.id}" style="background:#2563eb;color:#fff;padding:6px 16px;border-radius:6px;border:none;font-weight:600;">Xem nhanh</button>
                        <button class="btn btn-primary btn-apply" data-job-id="${rec.job.id}" style="background:#22c55e;color:#fff;padding:6px 16px;border-radius:6px;border:none;font-weight:600;">Ứng tuyển</button>
                    </div>
                    <div id="job-desc-${rec.job.id}" style="display:none;">
                        <h2 style="margin:0 0 0.5rem 0;font-size:1.3rem;color:#2563eb;">${rec.job.title}</h2>
                        <div style="color:#64748b;font-size:1.05rem;margin-bottom:0.5rem;">${rec.job.company}</div>
                        <div style="display:flex;gap:0.7rem;margin-bottom:0.7rem;align-items:center;flex-wrap:wrap;">
                            <c:if test="${rec.job.salary > 0}">
                                <span style="background:#bbf7d0;color:#22c55e;padding:2px 12px;border-radius:8px;font-size:1rem;font-weight:600;">
                                    <c:choose>
                                        <c:when test="${rec.job.salary >= 1000000}">
                                            <c:out value="${rec.job.salary/1000000}"/> triệu
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${rec.job.salary}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </c:if>
                            <c:if test="${not empty rec.job.location}">
                                <span style="background:#dbeafe;color:#2563eb;padding:2px 12px;border-radius:8px;font-size:1rem;display:flex;align-items:center;"><i data-lucide='map-pin' style='width:15px;margin-right:3px;'></i>${rec.job.location}</span>
                            </c:if>
                            <c:if test="${not empty rec.job.experience}">
                                <span style="background:#ede9fe;color:#a21caf;padding:2px 12px;border-radius:8px;font-size:1rem;">${rec.job.experience}</span>
                            </c:if>
                        </div>
                        <div class="match-info" style="margin-bottom:0.7rem;">Phù hợp: ${rec.matchPercent}% <c:if test="${not empty rec.matchDetail}"> - ${rec.matchDetail}</c:if></div>
                        <div class="markdown-preview" style="background:#f9f9f9;border:1px solid #e5e7eb;border-radius:8px;padding:1.2rem 1rem 1rem 1rem;">
                            <c:out value="${rec.job.description}" escapeXml="false"/>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty recommendations}">
                <div class="job-card">Không có công việc phù hợp.</div>
            </c:if>
        </div>
        <!-- Chi tiết job bên phải -->
        <div class="details" id="detail-pane" style="flex:3;background:#fff;padding:2.5rem 3rem;border-radius:1rem;box-shadow:0 2px 8px #0001;min-height:400px;">
            <div class="no-selection" style="color:#888;text-align:center;padding-top:40px;">
                <em>Chọn công việc để xem mô tả chi tiết.</em>
            </div>
        </div>
    </div>
</div>
<script src="https://unpkg.com/lucide@latest"></script>
<script>
    lucide.createIcons();
    document.querySelectorAll('.btn-preview').forEach(btn => {
        btn.addEventListener('click', () => {
            const jobId = btn.getAttribute('data-job-id');
            const detailPane = document.getElementById("detail-pane");
            const jobDesc = document.getElementById("job-desc-" + jobId);
            detailPane.innerHTML = jobDesc.innerHTML;
            lucide.createIcons();
        });
    });
    document.querySelectorAll('.btn-apply').forEach(button => {
        button.addEventListener('click', () => {
            const jobId = button.getAttribute('data-job-id');
            fetch('ApplyJobServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: 'jobId=' + jobId
            })
                .then(response => response.text())
                .then(result => {
                    if (result.trim() === 'success') {
                        button.disabled = true;
                        button.innerText = "Đã ứng tuyển";
                        button.style.backgroundColor = '#4CAF50';
                        alert("✅ Ứng tuyển thành công!");
                    } else if (result.trim() === 'duplicate') {
                        alert("⚠️ Bạn đã ứng tuyển công việc này.");
                    } else {
                        alert("❌ Có lỗi xảy ra.");
                    }
                })
                .catch(error => {
                    alert("❌ Không thể kết nối máy chủ.");
                    console.error(error);
                });
        });
    });
</script>
</body>
</html>
