// Virtual Interview JavaScript
let currentInterviewId = null;
let currentQuestionIndex = 0;
let totalQuestions = 0;
let isInterviewActive = false;

// Initialize the page
document.addEventListener('DOMContentLoaded', function() {
    initializeJobCards();
    initializeInterviewSession();
});

function initializeJobCards() {
    // Add click handlers for job cards
    const jobCards = document.querySelectorAll('.job-card');
    jobCards.forEach(card => {
        card.addEventListener('click', function() {
            const jobId = this.dataset.jobId;
            if (jobId) {
                startInterview(jobId);
            }
        });
    });
}

function initializeInterviewSession() {
    // Initialize interview session UI
    const interviewSession = document.getElementById('interviewSession');
    if (interviewSession) {
        // Add event listeners for interview controls
        const nextBtn = document.getElementById('nextQuestionBtn');
        const submitBtn = document.getElementById('submitInterviewBtn');
        const backBtn = document.getElementById('backToJobsBtn');
        
        if (nextBtn) {
            nextBtn.addEventListener('click', handleNextQuestion);
        }
        
        if (submitBtn) {
            submitBtn.addEventListener('click', handleSubmitInterview);
        }
        
        if (backBtn) {
            backBtn.addEventListener('click', showJobSelection);
        }
    }
}

function startInterview(jobId) {
    console.log('Starting interview for job ID:', jobId);
    
    // Show loading state
    showNotification('Đang chuẩn bị câu hỏi phỏng vấn...', 'info');
    
    fetch('VirtualInterviewServlet?action=start&jobId=' + parseInt(jobId))
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                currentInterviewId = data.interviewId;
                currentQuestionIndex = 1;
                totalQuestions = data.totalQuestions;
                isInterviewActive = true;
                
                // Update UI
                updateInterviewUI(data);
                showInterviewSession();
                
                showNotification('Bắt đầu phỏng vấn!', 'success');
            } else {
                showNotification('Không thể bắt đầu phỏng vấn', 'error');
            }
        })
        .catch(error => {
            console.error('Error starting interview:', error);
            showNotification('Lỗi khi bắt đầu phỏng vấn', 'error');
        });
}

function handleNextQuestion() {
    const answerInput = document.getElementById('answerInput');
    const currentAnswer = answerInput.value.trim();
    
    if (!currentAnswer) {
        showNotification('Vui lòng trả lời câu hỏi trước khi tiếp tục', 'warning');
        return;
    }
    
    // Show loading
    showNotification('Đang chuyển câu hỏi...', 'info');
    
    fetch('VirtualInterviewServlet?action=nextQuestion', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `interviewId=${currentInterviewId}&currentAnswer=${encodeURIComponent(currentAnswer)}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            if (data.hasNext) {
                // Show next question
                currentQuestionIndex = data.currentQuestion;
                updateQuestionUI(data);
                answerInput.value = '';
                showNotification(`Câu hỏi ${currentQuestionIndex}/${totalQuestions}`, 'info');
            } else {
                // Interview completed, show final submission
                showFinalSubmission();
                showNotification('Đã hoàn thành tất cả câu hỏi!', 'success');
            }
        } else {
            showNotification('Lỗi khi chuyển câu hỏi', 'error');
        }
    })
    .catch(error => {
        console.error('Error getting next question:', error);
        showNotification('Lỗi khi chuyển câu hỏi', 'error');
    });
}

function handleSubmitInterview() {
    const answerInput = document.getElementById('answerInput');
    const finalAnswer = answerInput.value.trim();
    
    if (!finalAnswer) {
        showNotification('Vui lòng trả lời câu hỏi cuối cùng', 'warning');
        return;
    }
    
    // Show loading
    showNotification('Đang đánh giá buổi phỏng vấn...', 'info');
    
    fetch('VirtualInterviewServlet?action=evaluate', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `interviewId=${currentInterviewId}&finalAnswer=${encodeURIComponent(finalAnswer)}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showInterviewResults(data);
            showNotification('Đánh giá hoàn thành!', 'success');
        } else {
            showNotification('Lỗi khi đánh giá phỏng vấn', 'error');
        }
    })
    .catch(error => {
        console.error('Error evaluating interview:', error);
        showNotification('Lỗi khi đánh giá phỏng vấn', 'error');
    });
}

function updateInterviewUI(data) {
    const questionElement = document.getElementById('currentQuestion');
    const jobInfoElement = document.getElementById('jobInfo');
    const progressElement = document.getElementById('questionProgress');
    
    if (questionElement) {
        questionElement.textContent = data.question;
    }
    
    if (jobInfoElement) {
        jobInfoElement.innerHTML = `
            <h4>${data.jobTitle}</h4>
            <p class="text-muted">${data.company}</p>
        `;
    }
    
    if (progressElement) {
        progressElement.textContent = `Câu hỏi ${currentQuestionIndex}/${totalQuestions}`;
    }
    
    // Update button states
    updateButtonStates();
}

function updateQuestionUI(data) {
    const questionElement = document.getElementById('currentQuestion');
    const progressElement = document.getElementById('questionProgress');
    
    if (questionElement) {
        questionElement.textContent = data.question;
    }
    
    if (progressElement) {
        progressElement.textContent = `Câu hỏi ${currentQuestionIndex}/${totalQuestions}`;
    }
}

function updateButtonStates() {
    const nextBtn = document.getElementById('nextQuestionBtn');
    const submitBtn = document.getElementById('submitInterviewBtn');
    
    if (nextBtn) {
        nextBtn.style.display = currentQuestionIndex < totalQuestions ? 'inline-block' : 'none';
    }
    
    if (submitBtn) {
        submitBtn.style.display = currentQuestionIndex >= totalQuestions ? 'inline-block' : 'none';
    }
}

function showFinalSubmission() {
    const nextBtn = document.getElementById('nextQuestionBtn');
    const submitBtn = document.getElementById('submitInterviewBtn');
    const finalMessage = document.getElementById('finalMessage');
    
    if (nextBtn) nextBtn.style.display = 'none';
    if (submitBtn) submitBtn.style.display = 'inline-block';
    
    if (finalMessage) {
        finalMessage.style.display = 'block';
        finalMessage.textContent = 'Đây là câu hỏi cuối cùng. Sau khi trả lời, hệ thống sẽ đánh giá toàn bộ buổi phỏng vấn.';
    }
}

function showInterviewSession() {
    const jobSelection = document.getElementById('jobSelection');
    const interviewSession = document.getElementById('interviewSession');
    
    if (jobSelection) jobSelection.style.display = 'none';
    if (interviewSession) interviewSession.style.display = 'block';
}

function showJobSelection() {
    const jobSelection = document.getElementById('jobSelection');
    const interviewSession = document.getElementById('interviewSession');
    const resultsSection = document.getElementById('interviewResults');
    
    if (jobSelection) jobSelection.style.display = 'block';
    if (interviewSession) interviewSession.style.display = 'none';
    if (resultsSection) resultsSection.style.display = 'none';
    
    // Reset interview state
    currentInterviewId = null;
    currentQuestionIndex = 0;
    totalQuestions = 0;
    isInterviewActive = false;
    
    // Clear form
    const answerInput = document.getElementById('answerInput');
    if (answerInput) answerInput.value = '';
}

function showInterviewResults(data) {
    const interviewSession = document.getElementById('interviewSession');
    const resultsSection = document.getElementById('interviewResults');
    
    if (interviewSession) interviewSession.style.display = 'none';
    if (resultsSection) {
        resultsSection.style.display = 'block';
        
        // Update results content
        const ratingElement = document.getElementById('overallRating');
        const feedbackElement = document.getElementById('interviewFeedback');
        const strengthsElement = document.getElementById('interviewStrengths');
        const weaknessesElement = document.getElementById('interviewWeaknesses');
        const suggestionsElement = document.getElementById('interviewSuggestions');
        
        if (ratingElement) {
            ratingElement.textContent = data.overallRating || 'Khá';
            ratingElement.className = getRatingClass(data.overallRating);
        }
        
        if (feedbackElement) {
            feedbackElement.textContent = data.feedback || 'Không có nhận xét.';
        }
        
        if (strengthsElement) {
            strengthsElement.innerHTML = formatListText(data.strengths || 'Không có điểm mạnh được ghi nhận.');
        }
        
        if (weaknessesElement) {
            weaknessesElement.innerHTML = formatListText(data.weaknesses || 'Không có điểm yếu được ghi nhận.');
        }
        
        if (suggestionsElement) {
            suggestionsElement.innerHTML = formatListText(data.suggestions || 'Không có gợi ý cải thiện.');
        }
    }
}

function getRatingClass(rating) {
    if (!rating) return 'rating-average';
    
    const ratingLower = rating.toLowerCase();
    if (ratingLower.includes('xuất sắc') || ratingLower.includes('tốt')) return 'rating-excellent';
    if (ratingLower.includes('khá')) return 'rating-good';
    if (ratingLower.includes('cần cải thiện')) return 'rating-average';
    if (ratingLower.includes('yếu')) return 'rating-poor';
    return 'rating-average';
}

function formatListText(text) {
    if (!text) return 'Không có thông tin.';
    
    // Convert \n to <br> and handle bullet points
    return text.replace(/\n/g, '<br>').replace(/•/g, '• ');
}

// Speech recognition and synthesis functions
let recognition = null;
let synthesis = window.speechSynthesis;

function initializeSpeechRecognition() {
    if ('webkitSpeechRecognition' in window) {
        recognition = new webkitSpeechRecognition();
        recognition.continuous = false;
        recognition.interimResults = false;
        recognition.lang = 'vi-VN';
        
        recognition.onresult = function(event) {
            const transcript = event.results[0][0].transcript;
            const answerInput = document.getElementById('answerInput');
            if (answerInput) {
                answerInput.value = transcript;
            }
        };
        
        recognition.onerror = function(event) {
            console.error('Speech recognition error:', event.error);
            showNotification('Lỗi nhận diện giọng nói', 'error');
        };
    }
}

function startVoiceInput() {
    if (recognition) {
        recognition.start();
        showNotification('Đang lắng nghe...', 'info');
    } else {
        showNotification('Trình duyệt không hỗ trợ nhận diện giọng nói', 'warning');
    }
}

function speakQuestion() {
    const questionElement = document.getElementById('currentQuestion');
    if (questionElement && synthesis) {
        const utterance = new SpeechSynthesisUtterance(questionElement.textContent);
        utterance.lang = 'vi-VN';
        utterance.rate = 0.8;
        synthesis.speak(utterance);
        showNotification('Đang đọc câu hỏi...', 'info');
    }
}

// Utility functions
function showNotification(message, type = 'info') {
        // Create notification element
        const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
        notification.textContent = message;
        
        // Add to page
        document.body.appendChild(notification);
        
        // Remove after 3 seconds
        setTimeout(() => {
        if (notification.parentNode) {
            notification.parentNode.removeChild(notification);
        }
        }, 3000);
    }

// Initialize speech recognition when page loads
document.addEventListener('DOMContentLoaded', function() {
    initializeSpeechRecognition();
}); 