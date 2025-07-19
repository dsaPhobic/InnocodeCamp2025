# Virtual Interview System - Testing & Troubleshooting Guide

## 🎯 Tổng quan
Hệ thống phỏng vấn ảo đã được cập nhật để hỗ trợ **nhiều câu hỏi trong một buổi phỏng vấn** và **đánh giá tổng hợp** sau khi hoàn thành tất cả câu hỏi.

## 🔧 Các tính năng mới

### 1. **Nhiều câu hỏi per session**
- ✅ Tạo 5 câu hỏi cho mỗi buổi phỏng vấn
- ✅ Navigation giữa các câu hỏi
- ✅ Progress tracking (1/5, 2/5, etc.)
- ✅ Lưu tất cả câu trả lời vào session

### 2. **Đánh giá tổng hợp**
- ✅ Đánh giá toàn bộ buổi phỏng vấn một lần
- ✅ AI-powered evaluation với ChatGPT
- ✅ Fallback evaluation khi AI không khả dụng
- ✅ Detailed feedback và suggestions

### 3. **Improved UI/UX**
- ✅ Modern card-based job selection
- ✅ Progress bar với animation
- ✅ Modal job details
- ✅ Responsive design

## 🧪 Testing Guide

### Bước 1: Kiểm tra Database
```sql
-- Kiểm tra bảng interviews có tồn tại
SELECT COUNT(*) FROM interviews;

-- Kiểm tra cấu trúc bảng
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'interviews';
```

### Bước 2: Kiểm tra Console Logs
Khi khởi động ứng dụng, kiểm tra console logs:
```
=== Interview System Initialization ===
Interviews table exists with X records
=== Testing Evaluation System ===
Fallback evaluation result: FEEDBACK: ...
Parsed result: {feedback=..., score=..., suggestions=...}
=== Evaluation System Test Complete ===
=== Initialization Complete ===
```

### Bước 3: Test Flow
1. **Chọn job** → Xem danh sách jobs
2. **Bắt đầu phỏng vấn** → Tạo 5 câu hỏi
3. **Trả lời câu hỏi 1** → Click "Câu hỏi tiếp theo"
4. **Trả lời câu hỏi 2-4** → Tiếp tục navigation
5. **Trả lời câu hỏi 5** → Click "Hoàn thành phỏng vấn"
6. **Xem kết quả** → Điểm số, feedback, suggestions

## 🔍 Troubleshooting

### Vấn đề: "Không thể đánh giá câu trả lời"

#### Nguyên nhân có thể:
1. **Session data bị mất**
2. **ChatGPT API không khả dụng**
3. **Parse error trong kết quả AI**
4. **Database connection issues**

#### Debug steps:

##### 1. Kiểm tra Session Data
Trong console logs, tìm:
```
Session verification:
  - Saved questions: 5
  - Saved answers: 0
  - Saved current question: 0
```

##### 2. Kiểm tra ChatGPT API
```
ChatGPT API not available, using fallback questions
ChatGPT API error, using fallback questions: ...
```

##### 3. Kiểm tra Evaluation Process
```
Evaluating complete interview for topic: ...
Number of questions: 5
Number of answers: 5
Evaluation result: FEEDBACK: ...
Parsed result: {feedback=..., score=..., suggestions=...}
```

##### 4. Kiểm tra Database
```sql
-- Kiểm tra interview records
SELECT * FROM interviews ORDER BY created_at DESC LIMIT 5;

-- Kiểm tra user permissions
SELECT * FROM Users WHERE id = [your_user_id];
```

### Vấn đề: "Interview not found"

#### Nguyên nhân:
1. **Session expired**
2. **Interview ID không đúng**
3. **User ID mismatch**

#### Debug steps:
```
Evaluating complete interview ID: 123 for user ID: 1
Session answers: 4
Session questions: 5
Retrieved interview: Found
Interview user ID: 1, Current user ID: 1
```

### Vấn đề: "Failed to create interview"

#### Nguyên nhân:
1. **Database connection issues**
2. **Missing foreign key constraints**
3. **Invalid data format**

#### Debug steps:
```
Creating interview for user ID: 1
Interview created successfully with ID: 123
Session verification:
  - Saved questions: 5
  - Saved answers: 0
  - Saved current question: 0
```

## 🛠️ Manual Testing

### Test Case 1: Basic Flow
```javascript
// 1. Start interview
fetch('VirtualInterviewServlet?action=start&jobId=1')
  .then(response => response.json())
  .then(data => console.log('Start result:', data));

// 2. Next question
fetch('VirtualInterviewServlet?action=nextQuestion', {
  method: 'POST',
  headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  body: 'interviewId=123&currentAnswer=Test answer 1'
})
.then(response => response.json())
.then(data => console.log('Next question result:', data));

// 3. Evaluate
fetch('VirtualInterviewServlet?action=evaluate', {
  method: 'POST',
  headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  body: 'interviewId=123&finalAnswer=Test final answer'
})
.then(response => response.json())
.then(data => console.log('Evaluation result:', data));
```

### Test Case 2: Fallback Evaluation
```java
// Test fallback evaluation directly
List<String> questions = List.of("Question 1", "Question 2");
List<String> answers = List.of("Answer 1", "Answer 2");
String topic = "Test Topic";

String result = generateFallbackCompleteEvaluation(questions, answers, topic);
Map<String, String> parsed = parseAIEvaluation(result);
System.out.println("Test result: " + parsed);
```

## 📊 Expected Results

### Successful Evaluation
```json
{
  "success": true,
  "feedback": "Cảm ơn bạn đã tham gia buổi phỏng vấn. Bạn đã thể hiện rất tốt...",
  "score": 85,
  "suggestions": "Để cải thiện kết quả phỏng vấn, bạn nên..."
}
```

### Error Response
```json
{
  "success": false,
  "error": "Interview not found"
}
```

## 🔧 Configuration

### ChatGPT API (Optional)
```java
// In LLMService.java
private static final String API_KEY = "your-openai-api-key";
```

### Database Configuration
```xml
<!-- In context.xml -->
<Resource name="jdbc/InnocodeSt1" 
          url="jdbc:sqlserver://localhost:1433;databaseName=InnocodeSt1;encrypt=true;trustServerCertificate=true"
          username="your_username" 
          password="your_password" />
```

## 📝 Log Analysis

### Key Log Messages to Monitor:
1. **Session Management:**
   ```
   Session verification: Saved questions: 5, Saved answers: 0
   Current answers in session: 3
   Added answer, total answers now: 4
   ```

2. **Evaluation Process:**
   ```
   Evaluating complete interview for topic: Java Developer
   Number of questions: 5, Number of answers: 5
   Evaluation result: FEEDBACK: ...
   Parsed result: {feedback=..., score=..., suggestions=...}
   ```

3. **Error Handling:**
   ```
   ChatGPT API not available, using fallback evaluation
   Error parsing AI evaluation: ...
   Session answers: null
   ```

## 🎯 Performance Tips

1. **Session Management:**
   - Clear session data after evaluation
   - Use proper session timeout
   - Monitor session size

2. **Database Optimization:**
   - Index on user_id and created_at
   - Regular cleanup of old records
   - Connection pooling

3. **AI Integration:**
   - Implement caching for common questions
   - Use fallback evaluation as primary
   - Monitor API rate limits

## 🚀 Deployment Checklist

- [ ] Database table `interviews` exists
- [ ] Foreign key constraints are set
- [ ] Session configuration is correct
- [ ] ChatGPT API key is configured (optional)
- [ ] Logging is enabled
- [ ] Error handling is tested
- [ ] UI is responsive on mobile
- [ ] Performance is acceptable

## 🔧 Recent Fixes (Latest Update)

### ✅ **Removed Numerical Scoring System**
- **Change**: Bỏ hệ thống đánh giá điểm số (0-100)
- **New Approach**: Đánh giá chi tiết với 4 tiêu chí:
  - **FEEDBACK**: Nhận xét tổng quan chi tiết
  - **STRENGTHS**: Liệt kê 3-5 điểm mạnh cụ thể
  - **WEAKNESSES**: Liệt kê 3-5 điểm cần cải thiện
  - **SUGGESTIONS**: Gợi ý cụ thể để cải thiện
  - **OVERALL_RATING**: Đánh giá tổng thể (Xuất sắc/Tốt/Khá/Cần cải thiện/Yếu)

### ✅ **Enhanced AI Prompt**
- **Improved Prompt**: Chi tiết hơn với 4 tiêu chí đánh giá:
  1. **NỘI DUNG CÂU TRẢ LỜI**: Độ chi tiết, tính chính xác, sự liên quan
  2. **KỸ NĂNG TRÌNH BÀY**: Tổ chức ý tưởng, giải thích rõ ràng, ví dụ minh họa
  3. **KIẾN THỨC CHUYÊN MÔN**: Hiểu biết, kinh nghiệm, cập nhật công nghệ
  4. **THÁI ĐỘ VÀ TÍNH CHUYÊN NGHIỆP**: Tự tin, học hỏi, chuyên nghiệp

### ✅ **Updated UI/UX**
- **New Sections**: 
  - Overall Rating với màu sắc phân biệt
  - Strengths section (màu xanh lá)
  - Weaknesses section (màu đỏ nhạt)
  - Enhanced feedback và suggestions sections
- **Removed**: Score display và score-related styling

### 📊 **New Feedback Examples**
```
FEEDBACK: Cảm ơn bạn đã tham gia buổi phỏng vấn về Java Developer. Bạn đã thể hiện rất tốt với những câu trả lời chi tiết và chuyên nghiệp.

STRENGTHS:
• Có khả năng trả lời chi tiết và đầy đủ thông tin
• Hoàn thành tất cả câu hỏi phỏng vấn
• Thể hiện sự quan tâm đến chủ đề phỏng vấn

WEAKNESSES:
• Cần cải thiện thêm về cách trình bày ý tưởng

SUGGESTIONS:
• Rèn luyện kỹ năng giao tiếp và trình bày ý tưởng
• Cập nhật kiến thức chuyên môn thường xuyên
• Thực hành phỏng vấn thường xuyên để cải thiện kỹ năng

OVERALL_RATING: Tốt
```

### 🧪 **Test Results**
When you restart the application, you'll see test results in console:
```
=== Testing Evaluation System ===
--- Test Case 1: Good Answers ---
Fallback evaluation result: FEEDBACK: ...
STRENGTHS: • Có khả năng trả lời chi tiết...
WEAKNESSES: • Cần cải thiện thêm...
SUGGESTIONS: • Rèn luyện kỹ năng...
OVERALL_RATING: Tốt
--- Test Case 2: Poor Answers ---
Fallback evaluation result: FEEDBACK: ...
STRENGTHS: • Có thái độ tích cực...
WEAKNESSES: • Có 2 câu hỏi chưa được trả lời...
SUGGESTIONS: • Cố gắng trả lời tất cả câu hỏi...
OVERALL_RATING: Yếu
```

### ✅ **Updated Q&A Storage and Display**
- **Change**: Gom tất cả câu hỏi và câu trả lời vào một field `user_answer`
- **Format**: 
  ```
  Câu hỏi 1: [Nội dung câu hỏi]
  Câu trả lời: [Nội dung câu trả lời]
  
  Câu hỏi 2: [Nội dung câu hỏi]
  Câu trả lời: [Nội dung câu trả lời]
  
  ...
  ```
- **Database**: Lưu vào cột `user_answer` khi hoàn thành phỏng vấn
- **Display**: Hiển thị trong interview history với format dễ đọc
- **Benefits**: 
  - Dễ review toàn bộ buổi phỏng vấn
  - Không cần join nhiều bảng
  - Format thống nhất cho tất cả interviews

### ✅ **Enhanced Interview History Display**
- **New Section**: "Câu hỏi và câu trả lời" thay vì tách riêng
- **Format**: Sử dụng `<pre>` tag để giữ nguyên format
- **Styling**: Background xám nhạt, border, padding phù hợp
- **Responsive**: Tự động wrap text trên mobile

## 📞 Support

Nếu gặp vấn đề, hãy:
1. Kiểm tra console logs
2. Verify database connectivity
3. Test với fallback evaluation
4. Check session configuration
5. Review error messages

Hệ thống được thiết kế để hoạt động ngay cả khi ChatGPT API không khả dụng! 