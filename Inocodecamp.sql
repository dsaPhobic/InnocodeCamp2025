CREATE DATABASE InnocodeSt1;
USE InnocodeSt1;
CREATE TABLE Users (
    id INT PRIMARY KEY IDENTITY(1,1),
    fullname NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    password NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX), 
    role NVARCHAR(50) DEFAULT 'user', 
    gender NVARCHAR(10), 
    date_of_birth DATE 
);



CREATE TABLE Skills (
    id INT PRIMARY KEY IDENTITY,
    user_id INT,
    skill_name NVARCHAR(100),
    score INT,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

CREATE TABLE Jobs (
    id INT PRIMARY KEY IDENTITY,
    title NVARCHAR(200),
    company NVARCHAR(200),
    location NVARCHAR(100),
    environment NVARCHAR(50),
    skill_required NVARCHAR(MAX),
    culture_tags NVARCHAR(200),
    description NVARCHAR(MAX),
    recruiter_email NVARCHAR(200), -- gửi email đến đây khi apply
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES Users(id)
);

CREATE TABLE JobRecommendations (
    id INT PRIMARY KEY IDENTITY,
    user_id INT,
    job_id INT,
    match_percent INT,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (job_id) REFERENCES Jobs(id)
);

CREATE TABLE JobApplications (
    id INT PRIMARY KEY IDENTITY,
    user_id INT,
    job_id INT,
    status NVARCHAR(50) DEFAULT 'Applied',
    applied_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (job_id) REFERENCES Jobs(id)
);

CREATE TABLE UploadedCVs (
    id INT PRIMARY KEY IDENTITY,
    user_id INT,
    file_name NVARCHAR(255),
    file_path NVARCHAR(255),
    uploaded_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

CREATE TABLE ChatLogs (
    id INT PRIMARY KEY IDENTITY,
    user_id INT,
    question NVARCHAR(MAX),
    answer NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- Thêm cột status để admin có thể bật/tắt bài tuyển dụng
ALTER TABLE Jobs ADD status NVARCHAR(20) DEFAULT 'active';

-- Thêm cột posted_at để lưu ngày đăng bài
ALTER TABLE Jobs ADD posted_at DATETIME DEFAULT GETDATE();

-- Thêm cột gps để lưu lat, lon dưới dạng string
ALTER TABLE Jobs ADD gps NVARCHAR(50);

INSERT INTO Users (fullname, email, password, description, role, gender, date_of_birth) VALUES
(N'Nguyễn Văn A', N'vana@example.com', N'123456', N'Lập trình viên backend', N'user', N'Nam', '1998-05-20'),
(N'Trần Thị B', N'bttran@example.com', N'123456', N'Frontend dev, thích UI/UX', N'user', N'Nữ', '2000-10-02'),
(N'Lê Văn C', N'levanc@example.com', N'123456', N'Quản lý dự án', N'admin', N'Nam', '1992-03-11');


INSERT INTO Skills (user_id, skill_name, score) VALUES
(1, N'Java', 80),
(1, N'SQL Server', 75),
(1, N'C++', 65),
(1, N'C#', 85),
(2, N'HTML/CSS', 90),
(2, N'JavaScript', 85),
(3, N'Project Management', 95),
(3, N'Scrum', 88);


INSERT INTO Jobs (title, company, location, environment, skill_required, culture_tags, description, recruiter_email, created_by) VALUES
(N'Java Backend Developer', N'Innocode Ltd.', N'Hà Nội', N'Hybrid', N'Java, SQL, Spring Boot', N'Năng động, Sáng tạo', N'Phát triển API cho hệ thống ERP', N'recruit@innocode.vn', 3),
(N'Frontend ReactJS', N'NovaTech', N'Hồ Chí Minh', N'Remote', N'JavaScript, ReactJS, HTML/CSS', N'Chủ động, Đổi mới', N'Xây dựng giao diện SPA', N'hr@novatech.vn', 3),
(N'Scrum Master', N'StartUpZone', N'Đà Nẵng', N'Onsite', N'Scrum, Agile, Quản lý dự án', N'Trẻ trung, Hợp tác', N'Quản lý tiến độ dự án phần mềm', N'scrum@startupzone.vn', 3);


INSERT INTO JobRecommendations (user_id, job_id, match_percent) VALUES
(1, 1, 85),
(2, 2, 90),
(3, 3, 88);


INSERT INTO JobApplications (user_id, job_id, status, applied_at) VALUES
(1, 1, N'Applied', GETDATE()),
(2, 2, N'Applied', GETDATE()),
(3, 3, N'Pending', GETDATE());

INSERT INTO UploadedCVs (user_id, file_name, file_path) VALUES
(1, N'vana_cv.pdf', N'/uploads/cvs/vana_cv.pdf'),
(2, N'ttran_cv.pdf', N'/uploads/cvs/ttran_cv.pdf'),
(3, N'levanc_cv.pdf', N'/uploads/cvs/levanc_cv.pdf');

INSERT INTO ChatLogs (user_id, question, answer) VALUES
(1, N'Có những vị trí nào phù hợp với Java?', N'Bạn phù hợp với vị trí Java Backend Developer tại Innocode Ltd.'),
(2, N'Làm thế nào để apply job Frontend?', N'Bạn có thể nộp hồ sơ trực tuyến qua NovaTech website.'),
(3, N'Cách tối ưu hóa quản lý dự án?', N'Hãy tham khảo phương pháp Scrum và Agile.');
