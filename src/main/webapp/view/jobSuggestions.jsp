<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Việc làm gợi ý</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
        }

        .container {
            display: flex;
            gap: 20px;
            padding: 20px;
        }

        .sidebar {
            flex: 1;
            background: white;
            border-radius: 8px;
            padding: 10px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
        }

        .job-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 12px;
            background-color: #ffffff;
            transition: box-shadow 0.2s;
        }

        .job-card:hover {
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        .job-title {
            font-weight: bold;
            font-size: 16px;
            color: #1a73e8;
        }

        .job-info {
            font-size: 14px;
            color: #333;
            margin-top: 5px;
        }

        .job-buttons {
            margin-top: 10px;
        }

        .btn {
            padding: 6px 12px;
            font-size: 13px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-primary {
            background-color: #1a73e8;
            color: white;
        }

        .btn-primary:hover {
            background-color: #1259c3;
        }

        .details {
            flex: 2;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
        }

        .details h3 {
            margin-top: 0;
        }

        .markdown-preview {
            padding: 10px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 6px;
            margin-top: 10px;
        }

        .match-info {
            margin-top: 10px;
            font-style: italic;
            color: #555;
        }

        .no-selection {
            color: #888;
            text-align: center;
            padding-top: 40px;
        }
        .markdown-preview {
          background: #f9f9fc;
          border: 1px solid #e5e7eb;
          border-radius: 1rem;
          padding: 1.5rem 1.2rem 1.2rem 1.2rem;
          font-size: 1.08rem;
          color: #22223b;
          line-height: 1.7;
          margin-top: 1rem;
          overflow-x: auto;
        }
        .markdown-preview h1, .markdown-preview h2, .markdown-preview h3 {
          color: #2563eb;
          margin-top: 1.2em;
          margin-bottom: 0.5em;
          font-weight: 700;
        }
        .markdown-preview ul, .markdown-preview ol {
          margin-left: 1.5em;
          margin-bottom: 1em;
        }
        .markdown-preview li {
          margin-bottom: 0.3em;
        }
        .markdown-preview strong {
          color: #7c3aed;
        }
        .markdown-preview code {
          background: #e0e7ff;
          color: #1e293b;
          border-radius: 5px;
          padding: 2px 6px;
          font-size: 0.98em;
        }
        .markdown-preview blockquote {
          border-left: 4px solid #2563eb;
          background: #e0e7ff33;
          padding: 0.7em 1em;
          margin: 1em 0;
          color: #334155;
          font-style: italic;
        }
        .search-bar-wrap {
          display: flex;
          justify-content: center;
          background: #f3f4f6;
          padding: 1.2rem 0 1.2rem 0;
        }
        #searchForm {
          gap: 1.2rem !important;
          border-radius: 1.5rem !important;
          box-shadow: 0 2px 12px #0001 !important;
        }
        #searchBtn {
          margin-left: 1.2rem !important;
          border-radius: 1.2rem !important;
          background: linear-gradient(90deg,#2563eb,#7c3aed) !important;
          font-weight: 700;
          font-size: 1.13rem;
          padding: 0.9rem 2.5rem;
          box-shadow: 0 2px 8px #0001;
          transition: background 0.2s;
        }
        #searchBtn:hover {
          background: linear-gradient(90deg,#1e40af,#7c3aed) !important;
        }
        input, select {
          border-radius: 1rem !important;
          background: #f8fafc !important;
        }
    </style>
</head>
<body>
<div class="jobsearch-hero" style="background: linear-gradient(to right, #2563eb, #7c3aed); color: #fff; padding: 2rem 0 1rem 0; text-align: center;">
    <h2 style="margin:0;font-size:2rem;font-weight:600;">Khám phá việc làm phù hợp cho bạn</h2>
    <p style="color:#dbeafe;">Tìm kiếm và ứng tuyển công việc IT mơ ước!</p>
</div>
<!-- Thanh search sát đỉnh đầu -->
<div class="search-bar-wrap">
  <form id="searchForm" action="JobRecommendationServlet" method="get" style="display:flex;gap:1.2rem;align-items:center;max-width:900px;width:100%;background:#fff;padding:0.9rem 1.5rem;border-radius:1.5rem;box-shadow:0 2px 12px #0001;">
    <div class="input-address-group" style="position:relative;display:flex;align-items:center;flex:1;">
      <input type="text" id="addressInput" name="location" placeholder="Tìm theo địa chỉ cụ thể..." style="flex:1;padding:0.8rem 2.2rem 0.8rem 1.1rem;border-radius:1rem;border:1px solid #d1d5db;font-size:1.08rem;background:#f8fafc;" autocomplete="off">
      <span id="addressStatus" style="position:absolute;right:10px;top:50%;transform:translateY(-50%);width:28px;height:28px;display:flex;align-items:center;justify-content:center;pointer-events:none;"></span>
    </div>
    <select id="radiusSelect" name="radiusKm" style="padding:0.8rem 1.2rem;border-radius:1rem;border:1px solid #d1d5db;font-size:1.08rem;background:#f8fafc;">
      <option value="5">5 km</option>
      <option value="10">10 km</option>
      <option value="15">15 km</option>
    </select>
    <input type="text" name="title" placeholder="Tìm theo tiêu đề công việc..." style="flex:2;padding:0.8rem 1.1rem;border-radius:1rem;border:1px solid #d1d5db;font-size:1.08rem;background:#f8fafc;">
    <button id="searchBtn" type="submit" style="margin-left:1.2rem;background:linear-gradient(90deg,#2563eb,#7c3aed);color:#fff;padding:0.9rem 2.5rem;border:none;border-radius:1.2rem;font-weight:700;font-size:1.13rem;box-shadow:0 2px 8px #0001;cursor:pointer;transition:background 0.2s;">Tìm kiếm</button>
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
                                <c:set var="parts" value="${fn:split(rec.job.location, ',')}" />
                                <c:set var="city" value="${parts[fn:length(parts)-1]}" />
                                <c:set var="city" value="${fn:replace(city, 'TP.', '')}" />
                                <c:set var="city" value="${fn:replace(city, 'Thành phố', '')}" />
                                <span style="background:#dbeafe;color:#2563eb;padding:2px 12px;border-radius:8px;font-size:1rem;display:flex;align-items:center;"><i data-lucide='map-pin' style='width:15px;margin-right:3px;'></i>${fn:trim(city)}</span>
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
                                <c:set var="parts" value="${fn:split(rec.job.location, ',')}" />
                                <c:set var="city" value="${parts[fn:length(parts)-1]}" />
                                <c:set var="city" value="${fn:replace(city, 'TP.', '')}" />
                                <c:set var="city" value="${fn:replace(city, 'Thành phố', '')}" />
                                <span style="background:#dbeafe;color:#2563eb;padding:2px 12px;border-radius:8px;font-size:1rem;display:flex;align-items:center;"><i data-lucide='map-pin' style='width:15px;margin-right:3px;'></i>${fn:trim(city)}</span>
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
<!-- Modal Apply Job -->
<div id="applyModal" style="display:none;position:fixed;z-index:9999;left:0;top:0;width:100vw;height:100vh;background:rgba(30,41,59,0.25);backdrop-filter:blur(2px);align-items:center;justify-content:center;">
  <div style="background:#fff;max-width:700px;width:98vw;border-radius:1.2rem;box-shadow:0 8px 32px #0002;padding:2.5rem 2.5rem 2rem 2.5rem;position:relative;">
    <button id="closeApplyModal" style="position:absolute;top:18px;right:18px;background:none;border:none;font-size:1.7rem;color:#64748b;cursor:pointer;">&times;</button>
    <h2 style="color:#2563eb;font-weight:700;font-size:1.5rem;margin-bottom:1.2rem;">Ứng tuyển công việc</h2>
    <form id="applyForm" enctype="multipart/form-data">
      <label style="font-weight:600;color:#2563eb;font-size:1.08rem;">Thư gửi nhà tuyển dụng:</label>
      <textarea id="coverLetter" name="coverLetter" rows="12" style="width:100%;border-radius:0.7rem;border:1px solid #d1d5db;padding:1.1rem;margin:0.7rem 0 1.2rem 0;font-size:1.08rem;resize:vertical;min-height:220px;">Kính gửi Anh/Chị,

Tôi tên là [Họ và tên], hiện tại tôi đang quan tâm và mong muốn ứng tuyển vào vị trí [Tên vị trí] tại [Tên công ty].
Với các kỹ năng nổi bật như: [Kỹ năng], tôi tin rằng mình có thể đóng góp tích cực cho sự phát triển của công ty.

Tôi đã đính kèm CV để Anh/Chị tham khảo thêm về quá trình học tập và làm việc của mình. Rất mong có cơ hội được trao đổi thêm với Anh/Chị về vị trí này.

Xin cảm ơn Anh/Chị đã dành thời gian xem xét hồ sơ của tôi.
Trân trọng,
[Họ và tên]
[Số điện thoại]
[Email liên hệ]</textarea>
      <label style="font-weight:600;color:#2563eb;font-size:1.08rem;">Đính kèm CV (PDF):</label>
      <input type="file" id="cvFile" name="cvFile" accept="application/pdf" style="margin:0.5rem 0 1.2rem 0;padding:0.7rem;border-radius:0.5rem;border:1px solid #d1d5db;font-size:1.05rem;" required />
      <div id="applyError" style="color:#dc2626;font-size:1.05rem;margin-bottom:0.9rem;display:none;"></div>
      <button type="submit" style="background:linear-gradient(to right,#2563eb,#7c3aed);color:#fff;padding:1rem 2.5rem;border:none;border-radius:0.9rem;font-weight:700;font-size:1.13rem;box-shadow:0 2px 8px #0001;cursor:pointer;">Gửi ứng tuyển</button>
    </form>
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
    // Modal Apply Job logic
    let currentApplyJobId = null;
    document.querySelectorAll('.btn-apply').forEach(button => {
        button.addEventListener('click', (e) => {
            e.preventDefault();
            if (button.disabled || button.classList.contains('applied')) {
                alert('⚠️ Bạn đã ứng tuyển công việc này.');
                return;
            }
            currentApplyJobId = button.getAttribute('data-job-id');
            document.getElementById('applyModal').style.display = 'flex';
            document.getElementById('applyError').style.display = 'none';
            document.getElementById('applyForm').reset();
        });
    });
    document.getElementById('closeApplyModal').onclick = function() {
        document.getElementById('applyModal').style.display = 'none';
    };
    document.getElementById('applyForm').onsubmit = function(ev) {
        ev.preventDefault();
        const form = ev.target;
        const coverLetter = form.coverLetter.value.trim();
        const fileInput = form.cvFile;
        const errorDiv = document.getElementById('applyError');
        errorDiv.style.display = 'none';
        if (!coverLetter) {
            errorDiv.textContent = 'Vui lòng nhập thư gửi nhà tuyển dụng.';
            errorDiv.style.display = 'block';
            return;
        }
        if (!fileInput.files[0] || fileInput.files[0].type !== 'application/pdf') {
            errorDiv.textContent = 'Vui lòng chọn file PDF hợp lệ.';
            errorDiv.style.display = 'block';
            return;
        }
        const formData = new FormData();
        formData.append('jobId', currentApplyJobId);
        formData.append('coverLetter', coverLetter);
        formData.append('cvFile', fileInput.files[0]);
        fetch('ApplyJobServlet', {
            method: 'POST',
            headers: { 'X-Requested-With': 'XMLHttpRequest' },
            body: formData
        })
        .then(res => res.text())
        .then(result => {
            console.log('Server response:', JSON.stringify(result));
            if (result.trim() === 'success') {
                document.getElementById('applyModal').style.display = 'none';
                alert('✅ Ứng tuyển thành công!');
            } else if (result.trim() === 'duplicate') {
                errorDiv.textContent = '⚠️ Bạn đã ứng tuyển công việc này.';
                errorDiv.style.display = 'block';
            } else {
                errorDiv.textContent = '❌ Có lỗi xảy ra khi gửi ứng tuyển.';
                errorDiv.style.display = 'block';
            }
        })
        .catch(() => {
            errorDiv.textContent = '❌ Không thể kết nối máy chủ.';
            errorDiv.style.display = 'block';
        });
    };

    // Tự động scroll và xem nhanh nếu có jobId trên URL
    window.addEventListener('DOMContentLoaded', function() {
        // Ưu tiên lấy jobId từ biến JSP nếu có
        var jobId = null;
        <% if (request.getAttribute("jobId") != null) { %>
            jobId = '<%= request.getAttribute("jobId") %>';
        <% } else { %>
            const urlParams = new URLSearchParams(window.location.search);
            jobId = urlParams.get('jobId');
        <% } %>
        if (jobId) {
            const card = document.querySelector('.job-card[data-job-id="' + jobId + '"]');
            if (card) {
                card.scrollIntoView({behavior: 'smooth', block: 'center'});
                const btn = card.querySelector('.btn-preview');
                if (btn) btn.click();
                card.style.boxShadow = '0 0 0 3px #2563eb, 0 2px 8px #0001';
            }
        }
    });

    // Địa chỉ: kiểm tra hợp lệ và hiển thị tick/x
    const addressInput = document.getElementById('addressInput');
    const addressStatus = document.getElementById('addressStatus');
    const searchBtn = document.getElementById('searchBtn');
    let addressValid = false;
    let debounceTimeout = null;
    addressInput.addEventListener('input', function() {
        const val = addressInput.value.trim();
        addressStatus.innerHTML = '';
        addressValid = false;
        // Nếu không nhập địa chỉ, luôn enable nút tìm kiếm
        if (!val) {
            searchBtn.disabled = false;
            return;
        }
        searchBtn.disabled = true;
        if (debounceTimeout) clearTimeout(debounceTimeout);
        debounceTimeout = setTimeout(() => {
            fetch('JobRecommendationServlet?action=checkAddress&address=' + encodeURIComponent(val))
                .then(res => res.text())
                .then(result => {
                    if (result.trim() === 'true') {
                        addressStatus.innerHTML = `<svg width="24" height="24" fill="none" stroke="#22c55e" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><polyline points="20 6 10 18 4 12"></polyline></svg>`;
                        addressValid = true;
                        searchBtn.disabled = false;
                    } else {
                        addressStatus.innerHTML = `<svg width="24" height="24" fill="none" stroke="#dc2626" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>`;
                        addressValid = false;
                        searchBtn.disabled = true;
                    }
                })
                .catch(() => {
                    addressStatus.innerHTML = `<svg width="24" height="24" fill="none" stroke="#dc2626" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>`;
                    addressValid = false;
                    searchBtn.disabled = true;
                });
        }, 500);
    });
    // Khi submit search, chỉ kiểm tra tick nếu có nhập địa chỉ
    const searchForm = document.getElementById('searchForm');
    searchForm.onsubmit = function(ev) {
        if (addressInput.value.trim() && !addressValid) {
            ev.preventDefault();
            alert('Địa chỉ không tồn tại. Vui lòng nhập địa chỉ hợp lệ!');
            addressInput.focus();
            return false;
        }
    };
</script>
</body>
</html>
