<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chọn công việc phỏng vấn</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .header {
            text-align: center;
            color: white;
            margin-bottom: 3rem;
        }

        .header h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            font-weight: 700;
        }

        .header p {
            font-size: 1.2rem;
            opacity: 0.9;
        }

        .search-section {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .search-input {
            width: 100%;
            padding: 1rem 1.5rem;
            border: 2px solid #e5e7eb;
            border-radius: 0.8rem;
            font-size: 1.1rem;
            outline: none;
            transition: border-color 0.3s;
        }

        .search-input:focus {
            border-color: #667eea;
        }

        .jobs-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }

        .job-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
            border: 2px solid transparent;
        }

        .job-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
            border-color: #667eea;
        }

        .job-card.selected {
            border-color: #667eea;
            background: #f8faff;
        }

        .job-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 0.5rem;
        }

        .job-company {
            color: #6b7280;
            font-size: 1rem;
            margin-bottom: 1rem;
        }

        .job-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .job-tag {
            background: #e0e7ff;
            color: #3730a3;
            padding: 0.3rem 0.8rem;
            border-radius: 0.5rem;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .job-salary {
            background: #dcfce7;
            color: #166534;
            padding: 0.3rem 0.8rem;
            border-radius: 0.5rem;
            font-size: 0.9rem;
            font-weight: 600;
            display: inline-block;
            margin-bottom: 1rem;
        }

        .job-location {
            color: #6b7280;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .interview-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
            width: 100%;
        }

        .interview-btn:hover {
            transform: translateY(-2px);
        }

        .interview-btn:disabled {
            background: #9ca3af;
            cursor: not-allowed;
            transform: none;
        }

        .loading {
            text-align: center;
            padding: 2rem;
            color: white;
        }

        .no-jobs {
            text-align: center;
            padding: 3rem;
            color: white;
            font-size: 1.2rem;
        }

        .back-btn {
            position: fixed;
            top: 2rem;
            left: 2rem;
            background: rgba(255,255,255,0.2);
            color: white;
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 0.5rem;
            cursor: pointer;
            backdrop-filter: blur(10px);
            transition: background 0.3s;
        }

        .back-btn:hover {
            background: rgba(255,255,255,0.3);
        }
    </style>
</head>
<body>
    <button class="back-btn" onclick="window.history.back()">← Quay lại</button>
    
    <div class="container">
        <div class="header">
            <h1>🎤 Phỏng vấn Ảo với AI</h1>
            <p>Chọn công việc bạn muốn thực hành phỏng vấn</p>
        </div>

        <div class="search-section">
            <input type="text" class="search-input" id="searchInput" placeholder="Tìm kiếm công việc theo tên, công ty hoặc kỹ năng...">
        </div>

        <div id="jobsContainer">
            <div class="loading">🔄 Đang tải danh sách công việc...</div>
        </div>
    </div>

    <script>
        let allJobs = [];
        let selectedJob = null;

        // Load jobs when page loads
        document.addEventListener('DOMContentLoaded', function() {
            loadJobs();
        });

        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            filterJobs(searchTerm);
        });

        function loadJobs() {
            fetch('${pageContext.request.contextPath}/JobListServlet?action=getJobs')
                .then(function(response) {
                    if (!response.ok) {
                        throw new Error('Server error: ' + response.status);
                    }
                    return response.json();
                })
                .then(function(data) {
                    // Kiểm tra nếu có lỗi từ server
                    if (data.error) {
                        throw new Error(data.error);
                    }
                    
                    // Đảm bảo data là array
                    if (!Array.isArray(data)) {
                        console.warn('Server returned non-array data:', data);
                        data = [];
                    }
                    
                    allJobs = data;
                    displayJobs(data);
                })
                .catch(function(error) {
                    console.error('Error loading jobs:', error);
                    document.getElementById('jobsContainer').innerHTML = 
                        '<div class="no-jobs">❌ Không thể tải danh sách công việc: ' + error.message + '</div>';
                });
        }

        function displayJobs(jobs) {
            const container = document.getElementById('jobsContainer');
            
            if (jobs.length === 0) {
                container.innerHTML = '<div class="no-jobs">Không tìm thấy công việc nào</div>';
                return;
            }

            let html = '<div class="jobs-grid">';
            jobs.forEach(function(job) {
                html += createJobCard(job);
            });
            html += '</div>';
            
            container.innerHTML = html;
        }

        function createJobCard(job) {
            const salary = job.salary > 0 ? 
                (job.salary >= 1000000 ? (job.salary/1000000) + ' triệu' : job.salary.toString()) : 
                'Thương lượng';
            
            const skills = job.skillRequired ? job.skillRequired.split(',').slice(0, 3) : [];
            
            let html = '<div class="job-card" data-job-id="' + job.id + '" onclick="selectJob(' + job.id + ')">';
            html += '<div class="job-title">' + job.title + '</div>';
            html += '<div class="job-company">' + job.company + '</div>';
            
            if (job.salary > 0) {
                html += '<div class="job-salary">💰 ' + salary + '</div>';
            }
            
            if (job.location) {
                html += '<div class="job-location">📍 ' + job.location + '</div>';
            }
            
            if (skills.length > 0) {
                html += '<div class="job-tags">';
                skills.forEach(function(skill) {
                    html += '<span class="job-tag">' + skill.trim() + '</span>';
                });
                html += '</div>';
            }
            
            html += '<button class="interview-btn" onclick="startInterview(' + job.id + ', event)">';
            html += '🎤 Bắt đầu phỏng vấn';
            html += '</button>';
            html += '</div>';
            
            return html;
        }

        function selectJob(jobId) {
            // Remove previous selection
            document.querySelectorAll('.job-card').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Add selection to current card
            const card = document.querySelector(`[data-job-id="${jobId}"]`);
            if (card) {
                card.classList.add('selected');
                selectedJob = allJobs.find(job => job.id === jobId);
            }
        }

        function startInterview(jobId, event) {
            event.stopPropagation();
            
            const job = allJobs.find(job => job.id === jobId);
            if (!job) return;
            
            // Redirect to virtual interview page with job info
            const params = new URLSearchParams({
                jobId: job.id,
                jobTitle: job.title,
                jobDescription: job.description || '',
                skillRequired: job.skillRequired || ''
            });
            
            window.location.href = `virtualInterview.jsp?${params.toString()}`;
        }

        function filterJobs(searchTerm) {
            if (!searchTerm) {
                displayJobs(allJobs);
                return;
            }
            
            const filteredJobs = allJobs.filter(job => {
                const title = job.title ? job.title.toLowerCase() : '';
                const company = job.company ? job.company.toLowerCase() : '';
                const skills = job.skillRequired ? job.skillRequired.toLowerCase() : '';
                const location = job.location ? job.location.toLowerCase() : '';
                
                return title.includes(searchTerm) || 
                       company.includes(searchTerm) || 
                       skills.includes(searchTerm) ||
                       location.includes(searchTerm);
            });
            
            displayJobs(filteredJobs);
        }
    </script>
</body>
</html> 