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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/skillChart.css" />
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="${pageContext.request.contextPath}/js/chart.js"></script>
    </head>
    <body>
        <jsp:include page="/view/includes/navbar.jsp" />
        
        <% Boolean noSkills = (Boolean) request.getAttribute("noSkills"); %>
        <% if (noSkills != null && noSkills) { %>
        <div class="chart-container">
            <h2>Biểu đồ kỹ năng cá nhân</h2>
            <div style="text-align: center; padding: 40px 20px;">
                <div style="font-size: 4rem; margin-bottom: 20px;">📊</div>
                <h3 style="color: #64748b; margin-bottom: 16px;">Bạn chưa có kỹ năng nào</h3>
                <p style="color: #94a3b8; margin-bottom: 24px;">Hãy phân tích CV hoặc mô tả kinh nghiệm để tạo biểu đồ kỹ năng</p>
                <a href="${pageContext.request.contextPath}/SkillAnalysisServlet" 
                   style="display: inline-block; background: linear-gradient(135deg, #667eea, #764ba2); 
                          color: white; padding: 12px 24px; border-radius: 8px; text-decoration: none; 
                          font-weight: 600; transition: transform 0.2s ease;">
                    Phân tích kỹ năng ngay
                </a>
            </div>
        </div>
        <% } else { %>
        <div class="chart-container">
            <h2>Biểu đồ kỹ năng cá nhân</h2>
            <div class="chart-legend">
                <span class="legend-color"></span> Điểm kỹ năng
            </div>
            <canvas id="radarChart" width="400" height="400"></canvas>
        </div>
        
        <% 
        // Hiển thị biểu đồ cột so sánh với thị trường
        List<Map<String, Object>> comparisonData = (List<Map<String, Object>>) request.getAttribute("comparisonData");
        if (comparisonData != null && !comparisonData.isEmpty()) {
        %>
        <div class="chart-container">
            <h2>So sánh kỹ năng với thị trường</h2>
            <div class="chart-legend">
                <span class="legend-color" style="background: #667eea;"></span> Kỹ năng của bạn
                <span class="legend-color" style="background: #f59e0b; margin-left: 20px;"></span> Trung bình thị trường
            </div>
            <canvas id="barChart" width="600" height="400"></canvas>
        </div>
        <% } %>
        <% } %>
        
        <% 
        // Hiển thị danh sách công việc phù hợp
        List<model.JobRecommendation> recommendations = (List<model.JobRecommendation>) request.getAttribute("recommendations");
        if (recommendations != null && !recommendations.isEmpty()) {
        %>
        <div class="suggestions-container">
            <div class="suggestions-header">
                <span class="suggestions-icon">🎯</span>
                <h3 class="suggestions-title">Top 3 công việc phù hợp nhất với kỹ năng của bạn</h3>
            </div>
            <div class="job-list">
                <% for (int i = 0; i < recommendations.size() && i < 3; i++) { 
                    model.JobRecommendation rec = recommendations.get(i);
                    model.Job job = rec.getJob();
                %>
                <div class="job-card" data-job-id="<%= job.getId() %>" style="display: flex; align-items: flex-start; gap: 1rem; padding: 1.2rem 1rem 1rem 1rem; border-radius: 1rem; border: 1px solid #e5e7eb; margin-bottom: 1.2rem; box-shadow: 0 2px 8px #0001; cursor: pointer; transition: box-shadow .2s; background: white; position: relative;">
                    <!-- Rank badge -->
                    <div style="position: absolute; top: -8px; left: -8px; width: 32px; height: 32px; background: <%= i == 0 ? "#ffd700" : i == 1 ? "#c0c0c0" : "#cd7f32" %>; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; color: white; font-size: 0.9rem; border: 2px solid white; box-shadow: 0 2px 4px rgba(0,0,0,0.2);">
                        <%= i + 1 %>
                    </div>
                    <div style="width: 48px; height: 48px; background: #dbeafe; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; color: #2563eb; font-weight: 700;">
                        <span><%= job.getCompany() != null && !job.getCompany().isEmpty() ? job.getCompany().charAt(0) : "J" %></span>
                    </div>
                    <div style="flex: 1;">
                        <div class="job-title" style="font-size: 1.1rem; font-weight: 600; color: #2563eb;"><%= job.getTitle() %></div>
                        <div style="color: #64748b; font-size: 0.97rem;"><%= job.getCompany() %></div>
                        <div style="display: flex; gap: 0.5rem; margin: 0.5rem 0 0.2rem 0; align-items: center; flex-wrap: wrap;">
                            <% if (job.getSalary() > 0) { %>
                                <span style="background: #bbf7d0; color: #22c55e; padding: 2px 12px; border-radius: 8px; font-size: 1rem; font-weight: 600;">
                                    <% if (job.getSalary() >= 1000000) { %>
                                        <%= job.getSalary()/1000000 %> triệu
                                    <% } else { %>
                                        <%= job.getSalary() %>
                                    <% } %>
                                </span>
                            <% } %>
                            <% if (job.getLocation() != null && !job.getLocation().isEmpty()) { %>
                                <span style="background: #dbeafe; color: #2563eb; padding: 2px 12px; border-radius: 8px; font-size: 1rem; display: flex; align-items: center;">
                                    <i data-lucide="map-pin" style="width: 15px; margin-right: 3px;"></i>
                                    <%= job.getLocation().contains(",") ? job.getLocation().split(",")[job.getLocation().split(",").length-1].trim() : job.getLocation() %>
                                </span>
                            <% } %>
                            <% if (job.getExperience() != null && !job.getExperience().isEmpty()) { %>
                                <span style="background: #ede9fe; color: #a21caf; padding: 2px 12px; border-radius: 8px; font-size: 1rem;"><%= job.getExperience() %></span>
                            <% } %>
                        </div>
                        <% if (job.getSkillRequired() != null && !job.getSkillRequired().isEmpty()) { %>
                            <div style="margin-top: 0.3rem; color: #64748b; font-size: 0.95rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 220px;"><%= job.getSkillRequired() %></div>
                        <% } %>
                        <div style="margin-top: 0.5rem;">
                            <span style="background: <%= rec.getMatchPercent() >= 80 ? "#22c55e" : rec.getMatchPercent() >= 60 ? "#f59e0b" : "#ef4444" %>; color: white; padding: 4px 12px; border-radius: 8px; font-size: 0.9rem; font-weight: 600;">
                                Phù hợp: <%= rec.getMatchPercent() %>%
                            </span>
                            <% if (rec.getMatchDetail() != null && !rec.getMatchDetail().isEmpty()) { %>
                                <span style="color: #64748b; font-size: 0.9rem; margin-left: 8px;"><%= rec.getMatchDetail() %></span>
                            <% } %>
                        </div>
                    </div>
                    <div style="display: flex; flex-direction: column; gap: 0.5rem; align-items: flex-end;">
                        <button class="btn btn-primary btn-preview" data-job-id="<%= job.getId() %>" style="background: #2563eb; color: #fff; padding: 6px 16px; border-radius: 6px; border: none; font-weight: 600;">Xem nhanh</button>
                        <button class="btn btn-primary btn-apply" data-job-id="<%= job.getId() %>" style="background: #22c55e; color: #fff; padding: 6px 16px; border-radius: 6px; border: none; font-weight: 600;">Ứng tuyển</button>
                    </div>
                </div>
                <% } %>
            </div>
            <div style="text-align: center; margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/JobRecommendationServlet" 
                   style="display: inline-block; background: linear-gradient(135deg, #667eea, #764ba2); 
                          color: white; padding: 12px 24px; border-radius: 8px; text-decoration: none; 
                          font-weight: 600; transition: transform 0.2s ease;">
                    Xem tất cả công việc phù hợp
                </a>
            </div>
        </div>
        <% } %>
        
        <% 
        List<String> weakSkillSuggestions = (List<String>) request.getAttribute("weakSkillSuggestions");
        if (weakSkillSuggestions != null && !weakSkillSuggestions.isEmpty()) {
        %>
        <div class="suggestions-container">
            <div class="suggestions-header">
                <span class="suggestions-icon">💡</span>
                <h3 class="suggestions-title">Gợi ý cải thiện kỹ năng yếu</h3>
            </div>
            <div class="skill-suggestions">
                <% for (int i = 0; i < weakSkillSuggestions.size(); i++) { %>
                <div class="suggestion-item markdown-content" style="--item-index: <%= i %>;">
                    <%= weakSkillSuggestions.get(i) %>
                </div>
                <% } %>
            </div>
        </div>
        <% } %>
        
        <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
        <script>
            lucide.createIcons();
            const skillLabels = <%= jsSkillLabels%>;
            const skillScores = <%= jsSkillScores%>;
            
            // Dữ liệu cho biểu đồ cột so sánh
            const comparisonData = [
                <% 
                List<Map<String, Object>> comparisonData = (List<Map<String, Object>>) request.getAttribute("comparisonData");
                if (comparisonData != null) { 
                    for (Map<String, Object> data : comparisonData) { 
                %>
                        {
                            skill: '<%= data.get("skillName") %>',
                            userScore: <%= data.get("userScore") %>,
                            marketAverage: <%= data.get("marketAverage") %>
                        },
                <% 
                    }
                } 
                %>
            ];
            
            window.onload = function () {
                renderRadarChart(skillLabels, skillScores);
                if (comparisonData.length > 0) {
                    renderBarChart(comparisonData);
                }
            }
            
            function renderBarChart(data) {
                const ctx = document.getElementById('barChart').getContext('2d');
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.map(item => item.skill),
                        datasets: [
                            {
                                label: 'Kỹ năng của bạn',
                                data: data.map(item => item.userScore),
                                backgroundColor: '#667eea',
                                borderColor: '#5a67d8',
                                borderWidth: 1,
                                borderRadius: 4,
                                borderSkipped: false,
                            },
                            {
                                label: 'Trung bình thị trường',
                                data: data.map(item => item.marketAverage),
                                backgroundColor: '#f59e0b',
                                borderColor: '#d97706',
                                borderWidth: 1,
                                borderRadius: 4,
                                borderSkipped: false,
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                titleColor: '#fff',
                                bodyColor: '#fff',
                                borderColor: '#667eea',
                                borderWidth: 1,
                                cornerRadius: 8,
                                displayColors: true,
                                callbacks: {
                                    label: function(context) {
                                        return context.dataset.label + ': ' + context.parsed.y + '/100';
                                    }
                                }
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                max: 100,
                                grid: {
                                    color: 'rgba(0, 0, 0, 0.1)',
                                    drawBorder: false
                                },
                                ticks: {
                                    color: '#6b7280',
                                    font: {
                                        size: 12
                                    }
                                }
                            },
                            x: {
                                grid: {
                                    display: false
                                },
                                ticks: {
                                    color: '#6b7280',
                                    font: {
                                        size: 12
                                    }
                                }
                            }
                        },
                        interaction: {
                            intersect: false,
                            mode: 'index'
                        },
                        animation: {
                            duration: 1000,
                            easing: 'easeInOutQuart'
                        }
                    }
                });
            }
            
            // Xử lý buttons
            document.addEventListener('DOMContentLoaded', function() {
                // Tạo modal HTML
                const modalHTML = `
                    <div id="jobModal" class="job-modal" style="display: none;">
                        <div class="modal-overlay"></div>
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3 id="modalTitle">Chi tiết công việc</h3>
                                <button class="modal-close" onclick="closeModal()">&times;</button>
                            </div>
                            <div class="modal-body" id="modalBody">
                                <!-- Content will be inserted here -->
                            </div>
                            <div class="modal-footer" id="modalFooter">
                                <!-- Buttons will be inserted here -->
                            </div>
                        </div>
                    </div>
                `;
                document.body.insertAdjacentHTML('beforeend', modalHTML);
                
                // Xem nhanh button
                document.querySelectorAll('.btn-preview').forEach(btn => {
                    btn.addEventListener('click', (e) => {
                        e.stopPropagation();
                        const jobId = btn.getAttribute('data-job-id');
                        const jobCard = btn.closest('.job-card');
                        const jobTitle = jobCard.querySelector('.job-title').textContent;
                        const company = jobCard.querySelector('div[style*="color: #64748b"]').textContent;
                        const matchPercent = jobCard.querySelector('span[style*="background"]').textContent;
                        
                        // Hiển thị modal với thông tin job
                        document.getElementById('modalTitle').textContent = 'Chi tiết công việc';
                        document.getElementById('modalBody').innerHTML = `
                            <div class="job-detail">
                                <div class="job-detail-header">
                                    <h4>${jobTitle}</h4>
                                    <p class="company-name">${company}</p>
                                    <span class="match-badge">${matchPercent}</span>
                                </div>
                                <div class="job-detail-content">
                                    <p><strong>Mô tả công việc:</strong></p>
                                    <p>Đây là một vị trí thú vị với nhiều cơ hội phát triển. Bạn sẽ được làm việc trong môi trường năng động và học hỏi nhiều kỹ năng mới.</p>
                                    
                                    <p><strong>Yêu cầu:</strong></p>
                                    <ul>
                                        <li>Kinh nghiệm 2-3 năm trong lĩnh vực liên quan</li>
                                        <li>Kỹ năng giao tiếp tốt</li>
                                        <li>Khả năng làm việc nhóm</li>
                                        <li>Chịu được áp lực cao</li>
                                    </ul>
                                    
                                    <p><strong>Quyền lợi:</strong></p>
                                    <ul>
                                        <li>Lương thưởng cạnh tranh</li>
                                        <li>Bảo hiểm đầy đủ</li>
                                        <li>Cơ hội thăng tiến</li>
                                        <li>Môi trường làm việc trẻ trung</li>
                                    </ul>
                                </div>
                            </div>
                        `;
                        document.getElementById('modalFooter').innerHTML = `
                            <button class="btn-secondary" onclick="closeModal()">Đóng</button>
                            <button class="btn-primary" onclick="applyForJob('${jobId}', '${jobTitle}', '${company}')">Ứng tuyển ngay</button>
                        `;
                        showModal();
                    });
                });
                
                // Ứng tuyển button
                document.querySelectorAll('.btn-apply').forEach(btn => {
                    btn.addEventListener('click', (e) => {
                        e.stopPropagation();
                        const jobId = btn.getAttribute('data-job-id');
                        const jobCard = btn.closest('.job-card');
                        const jobTitle = jobCard.querySelector('.job-title').textContent;
                        const company = jobCard.querySelector('div[style*="color: #64748b"]').textContent;
                        
                        // Hiển thị modal xác nhận ứng tuyển
                        document.getElementById('modalTitle').textContent = 'Xác nhận ứng tuyển';
                        document.getElementById('modalBody').innerHTML = `
                            <div class="apply-confirmation">
                                <div class="confirmation-icon">📝</div>
                                <h4>Bạn có chắc chắn muốn ứng tuyển?</h4>
                                <p class="confirmation-text">Hồ sơ của bạn sẽ được gửi đến nhà tuyển dụng. Bạn có thể theo dõi trạng thái ứng tuyển trong phần "Hồ sơ ứng tuyển".</p>
                            </div>
                        `;
                        document.getElementById('modalFooter').innerHTML = `
                            <button class="btn-secondary" onclick="closeModal()">Hủy</button>
                            <button class="btn-success" onclick="confirmApply('${jobId}', '${jobTitle}', '${company}')">Xác nhận ứng tuyển</button>
                        `;
                        showModal();
                    });
                });
            });
            
            // Modal functions
            function showModal() {
                document.getElementById('jobModal').style.display = 'flex';
                document.body.style.overflow = 'hidden';
            }
            
            function closeModal() {
                document.getElementById('jobModal').style.display = 'none';
                document.body.style.overflow = 'auto';
            }
            
            function applyForJob(jobId, jobTitle, company) {
                closeModal();
                // Hiển thị modal xác nhận ứng tuyển
                document.getElementById('modalTitle').textContent = 'Xác nhận ứng tuyển';
                                        document.getElementById('modalBody').innerHTML = `
                            <div class="apply-confirmation">
                                <div class="confirmation-icon">📝</div>
                                <h4>Bạn có chắc chắn muốn ứng tuyển?</h4>
                                <p class="confirmation-text">Hồ sơ của bạn sẽ được gửi đến nhà tuyển dụng. Bạn có thể theo dõi trạng thái ứng tuyển trong phần "Hồ sơ ứng tuyển".</p>
                            </div>
                        `;
                document.getElementById('modalFooter').innerHTML = `
                    <button class="btn-secondary" onclick="closeModal()">Hủy</button>
                    <button class="btn-success" onclick="confirmApply('${jobId}', '${jobTitle}', '${company}')">Xác nhận ứng tuyển</button>
                `;
                showModal();
            }
            
            function confirmApply(jobId, jobTitle, company) {
                // Chuyển đến trang JobRecommendationServlet để xử lý ứng tuyển
                window.location.href = '${pageContext.request.contextPath}/JobRecommendationServlet?jobId=' + jobId;
            }
            
            // Close modal when clicking overlay
            document.addEventListener('click', function(e) {
                if (e.target.classList.contains('modal-overlay')) {
                    closeModal();
                }
            });
        </script>
    </body>
</html>