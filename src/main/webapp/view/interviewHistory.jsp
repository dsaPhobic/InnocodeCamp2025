<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử Phỏng vấn | GlobalWorks</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/interviewHistory.css" />
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body>
    <jsp:include page="/view/includes/navbar.jsp" />

    <div class="history-container">
        <div class="history-header">
            <h1>📚 Lịch sử Phỏng vấn</h1>
            <p>Xem lại các phiên phỏng vấn đã thực hiện</p>
            <a href="${pageContext.request.contextPath}/VirtualInterviewServlet" class="new-interview-btn">
                <i data-lucide="plus"></i>
                Phỏng vấn mới
            </a>
        </div>

        <div class="history-content">
            <c:choose>
                <c:when test="${not empty interviews}">
                    <div class="interviews-grid">
                        <c:forEach var="interview" items="${interviews}">
                            <div class="interview-card">
                                <div class="interview-header" onclick="toggleInterviewContent(this)">
                                    <div class="header-left">
                                        <div class="topic-badge ${interview.topic}">
                                            <c:choose>
                                                <c:when test="${interview.topic == 'java'}">☕ Java</c:when>
                                                <c:when test="${interview.topic == 'python'}">🐍 Python</c:when>
                                                <c:when test="${interview.topic == 'javascript'}">⚡ JavaScript</c:when>
                                                <c:when test="${interview.topic == 'database'}">🗄️ Database</c:when>
                                                <c:when test="${interview.topic == 'general'}">💼 Phỏng vấn chung</c:when>
                                                <c:otherwise>${interview.topic}</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="interview-date">
                                            <i data-lucide="calendar"></i>
                                            ${interview.formattedCreatedAt}
                                        </div>
                                    </div>
                                    <div class="header-right">
                                        <div class="status-badge ${interview.status}">
                                            <c:choose>
                                                <c:when test="${interview.status == 'completed'}">
                                                    <i data-lucide="check-circle"></i> Hoàn thành
                                                </c:when>
                                                <c:otherwise>
                                                    <i data-lucide="clock"></i> Đang thực hiện
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="toggle-icon">
                                            <i data-lucide="chevron-down"></i>
                                        </div>
                                        <div class="delete-icon" onclick="deleteInterview('${interview.id}', event)">
                                            <i data-lucide="trash-2"></i>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="interview-content" style="display: none;">
                                    <div class="content-wrapper">
                                        <c:if test="${not empty interview.userAnswer}">
                                            <div class="qa-section">
                                                <h3>📝 Câu hỏi và câu trả lời:</h3>
                                                <div class="qa-content">
                                                    <pre>${interview.userAnswer}</pre>
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty interview.aiFeedback}">
                                            <div class="feedback-section">
                                                <h3>💬 Nhận xét:</h3>
                                                <p>${interview.aiFeedback}</p>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty interview.suggestions}">
                                            <div class="suggestions-section">
                                                <h3>💡 Gợi ý:</h3>
                                                <p>${interview.suggestions}</p>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-icon">🎤</div>
                        <h2>Chưa có phiên phỏng vấn nào</h2>
                        <p>Bắt đầu phỏng vấn đầu tiên để rèn luyện kỹ năng của bạn!</p>
                        <a href="${pageContext.request.contextPath}/VirtualInterviewServlet" class="start-interview-btn">
                            <i data-lucide="mic"></i>
                            Bắt đầu phỏng vấn
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        lucide.createIcons();
        
        function toggleInterviewContent(header) {
            const card = header.closest('.interview-card');
            const content = card.querySelector('.interview-content');
            const toggleIcon = card.querySelector('.toggle-icon i');
            
            if (content.style.display === 'none') {
                content.style.display = 'block';
                toggleIcon.setAttribute('data-lucide', 'chevron-up');
            } else {
                content.style.display = 'none';
                toggleIcon.setAttribute('data-lucide', 'chevron-down');
            }
            
            // Recreate the icon
            lucide.createIcons();
        }
        
        function deleteInterview(interviewId, event) {
            event.stopPropagation(); // Prevent card toggle
            
            if (confirm('Bạn có chắc chắn muốn xóa phiên phỏng vấn này?')) {
                // Send delete request
                fetch('InterviewHistoryServlet?action=delete&id=' + interviewId, {
                    method: 'POST'
                })
                .then(response => {
                    if (response.ok) {
                        // Remove the card from DOM
                        const card = event.target.closest('.interview-card');
                        card.style.animation = 'slideOut 0.3s ease-out';
                        setTimeout(() => {
                            card.remove();
                        }, 300);
                    } else {
                        alert('Có lỗi xảy ra khi xóa phiên phỏng vấn');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi xóa phiên phỏng vấn');
                });
            }
        }
        
        // Auto-expand first completed interview
        document.addEventListener('DOMContentLoaded', function() {
            const completedCards = document.querySelectorAll('.interview-card .status-badge.completed');
            if (completedCards.length > 0) {
                const firstCompletedCard = completedCards[0];
                const card = firstCompletedCard.closest('.interview-card');
                const header = card.querySelector('.interview-header');
                toggleInterviewContent(header);
            }
        });
    </script>
</body>
</html> 