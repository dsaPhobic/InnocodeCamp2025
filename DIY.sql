-- Thêm cột status để admin có thể bật/tắt bài tuyển dụng
ALTER TABLE Jobs ADD status NVARCHAR(20) DEFAULT 'active';

-- Thêm cột posted_at để lưu ngày đăng bài
ALTER TABLE Jobs ADD posted_at DATETIME DEFAULT GETDATE();

-- Thêm cột gps để lưu lat, lon dưới dạng string
ALTER TABLE Jobs ADD gps NVARCHAR(50); 