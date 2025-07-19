<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phỏng vấn Ảo - InnocodeCamp</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/virtualInterview.css" rel="stylesheet">
</head>
<body>
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h2 class="text-center mb-4">
                    <i class="fas fa-microphone-alt"></i> Phỏng vấn Ảo với AI
                </h2>
                <p class="text-center text-muted mb-4">
                    Chọn một công việc để bắt đầu buổi phỏng vấn ảo với 5 câu hỏi được tạo tự động
                </p>
            </div>
        </div>
        
        <!-- Job Selection Section -->
        <div id="jobSelection" class="job-selection-section">
            <div class="row">
                <c:forEach var="job" items="${jobs}">
                    <div class="col-md-6 col-lg-4 mb-4">
                        <div class="job-card" data-job-id="${job.id}">
                            <div class="job-card-header">
                                <h5 class="job-title">${job.title}</h5>
                                <span class="company-name">${job.company}</span>
                            </div>
                            <div class="job-card-body">
                                <p class="job-description">
                                    ${job.description != null ? job.description : 'Không có mô tả'}
                                </p>
                                <div class="job-details">
                                    <span class="badge bg-primary">${job.skillRequired != null ? job.skillRequired : 'Không yêu cầu'}</span>
                                    <span class="badge bg-secondary">${job.experience != null ? job.experience : 'Không yêu cầu'}</span>
                                </div>
                            </div>
                            <div class="job-card-footer">
                                <button class="btn btn-outline-primary btn-sm" onclick="showJobDetails('${job.id}')">
                                    <i class="fas fa-eye"></i> Xem chi tiết
                                </button>
                                <button class="btn btn-success btn-sm" onclick="startInterview('${job.id}')">
                                    <i class="fas fa-play"></i> Bắt đầu phỏng vấn
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
        
        <!-- Interview Session Section -->
        <div id="interviewSession" class="interview-session-section" style="display: none;">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="interview-container">
                        <!-- Job Info -->
                        <div id="jobInfo" class="job-info-section mb-4">
                            <div class="text-center">
                                <h4 id="jobTitle"></h4>
                                <p id="companyName" class="text-muted"></p>
                            </div>
                        </div>
                        
                        <!-- Progress Bar -->
                        <div class="progress-section mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span id="questionProgress" class="progress-text">Câu hỏi 1/5</span>
                                <div class="progress" style="width: 70%;">
                                    <div id="progressBar" class="progress-bar" role="progressbar" style="width: 20%"></div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Question Section -->
                        <div class="question-section mb-4">
                            <div class="question-container">
                                <h5 class="question-label">
                                    <i class="fas fa-question-circle"></i> Câu hỏi:
                                </h5>
                                <div id="currentQuestion" class="question-text">
                                    <!-- Question will be loaded here -->
                                </div>
                                <div class="question-actions mt-2">
                                    <button class="btn btn-outline-secondary btn-sm" onclick="speakQuestion()">
                                        <i class="fas fa-volume-up"></i> Đọc câu hỏi
                                    </button>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Answer Section -->
                        <div class="answer-section mb-4">
                            <label for="answerInput" class="form-label">
                                <i class="fas fa-comment"></i> Câu trả lời của bạn:
                            </label>
                            <div class="input-group">
                                <textarea id="answerInput" class="form-control" rows="4" 
                                          placeholder="Nhập câu trả lời của bạn..."></textarea>
                                <button class="btn btn-outline-primary" onclick="startVoiceInput()">
                                    <i class="fas fa-microphone"></i>
                                </button>
                            </div>
                        </div>
                        
                        <!-- Final Message -->
                        <div id="finalMessage" class="alert alert-info" style="display: none;">
                            <!-- Final message will be shown here -->
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <button id="backToJobsBtn" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Quay lại
                            </button>
                            <button id="nextQuestionBtn" class="btn btn-primary">
                                <i class="fas fa-arrow-right"></i> Câu hỏi tiếp theo
                            </button>
                            <button id="submitInterviewBtn" class="btn btn-success" style="display: none;">
                                <i class="fas fa-check"></i> Hoàn thành phỏng vấn
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Interview Results Section -->
        <div id="interviewResults" class="interview-results-section" style="display: none;">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="results-container">
                        <div class="text-center mb-4">
                            <h3><i class="fas fa-trophy"></i> Kết quả phỏng vấn</h3>
                        </div>
                        
                        <!-- Overall Rating Section -->
                        <div class="rating-section mb-4">
                            <div class="rating-display">
                                <span class="rating-label">Đánh giá tổng thể:</span>
                                <span id="overallRating" class="rating-value">Khá</span>
                            </div>
                        </div>
                        
                        <!-- Feedback Section -->
                        <div class="feedback-section mb-4">
                            <h5><i class="fas fa-comments"></i> Nhận xét tổng quan:</h5>
                            <div id="interviewFeedback" class="feedback-text">
                                <!-- Feedback will be loaded here -->
                            </div>
                        </div>
                        
                        <!-- Strengths Section -->
                        <div class="strengths-section mb-4">
                            <h5><i class="fas fa-star"></i> Điểm mạnh:</h5>
                            <div id="interviewStrengths" class="strengths-text">
                                <!-- Strengths will be loaded here -->
                            </div>
                        </div>
                        
                        <!-- Weaknesses Section -->
                        <div class="weaknesses-section mb-4">
                            <h5><i class="fas fa-exclamation-triangle"></i> Điểm cần cải thiện:</h5>
                            <div id="interviewWeaknesses" class="weaknesses-text">
                                <!-- Weaknesses will be loaded here -->
                            </div>
                        </div>
                        
                        <!-- Suggestions Section -->
                        <div class="suggestions-section mb-4">
                            <h5><i class="fas fa-lightbulb"></i> Gợi ý cải thiện:</h5>
                            <div id="interviewSuggestions" class="suggestions-text">
                                <!-- Suggestions will be loaded here -->
                            </div>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="text-center">
                            <button class="btn btn-primary" onclick="showJobSelection()">
                                <i class="fas fa-redo"></i> Phỏng vấn khác
                            </button>
                            <a href="InterviewHistoryServlet" class="btn btn-outline-secondary">
                                <i class="fas fa-history"></i> Xem lịch sử
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Job Details Modal -->
    <div class="modal fade" id="jobDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Chi tiết công việc</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="jobDetailsContent">
                    <!-- Job details will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-success" onclick="startInterviewFromModal()">
                        <i class="fas fa-play"></i> Bắt đầu phỏng vấn
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Notification Container -->
    <div id="notificationContainer" class="notification-container"></div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/virtualInterview.js"></script>
    
    <script>
        let selectedJobId = null;
        
                 function showJobDetails(jobId) {
             selectedJobId = parseInt(jobId);
             // Load job details via AJAX or use existing data
             const jobCard = document.querySelector(`[data-job-id="${jobId}"]`);
             const title = jobCard.querySelector('.job-title').textContent;
             const company = jobCard.querySelector('.company-name').textContent;
             const description = jobCard.querySelector('.job-description').textContent;
            
            document.getElementById('jobDetailsContent').innerHTML = `
                <h4>${title}</h4>
                <p class="text-muted">${company}</p>
                <hr>
                <h6>Mô tả công việc:</h6>
                <p>${description}</p>
            `;
            
            const modal = new bootstrap.Modal(document.getElementById('jobDetailsModal'));
            modal.show();
        }
        
        function startInterviewFromModal() {
            if (selectedJobId) {
                const modal = bootstrap.Modal.getInstance(document.getElementById('jobDetailsModal'));
                modal.hide();
                startInterview(selectedJobId);
            }
        }
        
        // Update progress bar
        function updateProgressBar(current, total) {
            const progressBar = document.getElementById('progressBar');
            const percentage = (current / total) * 100;
            progressBar.style.width = percentage + '%';
        }
        
        // Override the updateQuestionUI function to include progress bar update
        const originalUpdateQuestionUI = window.updateQuestionUI;
        window.updateQuestionUI = function(data) {
            if (originalUpdateQuestionUI) {
                originalUpdateQuestionUI(data);
            }
            updateProgressBar(data.currentQuestion, data.totalQuestions);
        };
        
        // Override the updateInterviewUI function to include progress bar update
        const originalUpdateInterviewUI = window.updateInterviewUI;
        window.updateInterviewUI = function(data) {
            if (originalUpdateInterviewUI) {
                originalUpdateInterviewUI(data);
            }
            updateProgressBar(1, data.totalQuestions);
        };
    </script>
</body>
</html> 