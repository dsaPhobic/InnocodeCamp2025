package controller;

import dao.InterviewDAO;
import dao.JobDAO;
import model.Interview;
import model.Job;
import model.User;
import service.LLMService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.ArrayList;

@WebServlet("/VirtualInterviewServlet")
public class VirtualInterviewServlet extends HttpServlet {
    
    private InterviewDAO interviewDAO;
    private JobDAO jobDAO;
    private LLMService llmService;
    
    @Override
    public void init() throws ServletException {
        interviewDAO = new InterviewDAO();
        jobDAO = new JobDAO();
        llmService = new LLMService();
        
        // Check if interviews table exists
        System.out.println("=== Interview System Initialization ===");
        boolean tableExists = interviewDAO.checkTableExists();
        if (!tableExists) {
            System.err.println("WARNING: Interviews table does not exist!");
        } else {
            interviewDAO.logTableStructure();
        }
        
        // Test evaluation system
        testEvaluationSystem();
        
        System.out.println("=== Initialization Complete ===");
    }
    
    private void testEvaluationSystem() {
        System.out.println("=== Testing Evaluation System ===");
        
        // Test Case 1: Good answers
        List<String> testQuestions1 = List.of(
            "Bạn có thể giới thiệu về bản thân không?",
            "Tại sao bạn muốn làm việc tại công ty này?",
            "Điểm mạnh của bạn là gì?"
        );
        
        List<String> testAnswers1 = List.of(
            "Tôi là một developer có 3 năm kinh nghiệm trong Java development. Tôi đã làm việc với Spring Boot, Hibernate và các công nghệ web khác.",
            "Tôi thích môi trường làm việc năng động và có cơ hội học hỏi. Công ty có văn hóa tốt và dự án thú vị.",
            "Tôi có khả năng học nhanh và làm việc nhóm tốt. Tôi cũng có kinh nghiệm trong việc giải quyết vấn đề phức tạp."
        );
        
        String testTopic1 = "Java Developer tại ABC Company";
        
        // Test Case 2: Poor answers
        List<String> testQuestions2 = List.of(
            "Bạn biết gì về Java?",
            "Kinh nghiệm của bạn?"
        );
        
        List<String> testAnswers2 = List.of(
            "Java",
            "Có"
        );
        
        String testTopic2 = "Java Developer";
        
        // Test fallback evaluation
        System.out.println("--- Test Case 1: Good Answers ---");
        String fallbackResult1 = generateFallbackCompleteEvaluation(testQuestions1, testAnswers1, testTopic1);
        System.out.println("Fallback evaluation result: " + fallbackResult1);
        
        Map<String, String> parsedResult1 = parseAIEvaluation(fallbackResult1);
        System.out.println("Parsed result: " + parsedResult1);
        
        System.out.println("--- Test Case 2: Poor Answers ---");
        String fallbackResult2 = generateFallbackCompleteEvaluation(testQuestions2, testAnswers2, testTopic2);
        System.out.println("Fallback evaluation result: " + fallbackResult2);
        
        Map<String, String> parsedResult2 = parseAIEvaluation(fallbackResult2);
        System.out.println("Parsed result: " + parsedResult2);
        
        // Test Q&A format
        System.out.println("--- Test Case 3: Q&A Format ---");
        StringBuilder testQA = new StringBuilder();
        for (int i = 0; i < testQuestions1.size() && i < testAnswers1.size(); i++) {
            testQA.append("Câu hỏi ").append(i + 1).append(": ").append(testQuestions1.get(i)).append("\n");
            testQA.append("Câu trả lời: ").append(testAnswers1.get(i)).append("\n\n");
        }
        System.out.println("Combined Q&A format:");
        System.out.println(testQA.toString());
        System.out.println("Q&A length: " + testQA.length() + " characters");
        
        System.out.println("=== Evaluation System Test Complete ===");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("getJobs".equals(action)) {
            // Lấy danh sách jobs để hiển thị
            try {
                List<Job> jobs = jobDAO.getAllJobs();
                request.setAttribute("jobs", jobs);
                request.getRequestDispatcher("/view/virtualInterview.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } else if ("start".equals(action)) {
            // Bắt đầu phỏng vấn mới với job cụ thể
            try {
                int jobId = Integer.parseInt(request.getParameter("jobId"));
                System.out.println("Starting interview for job ID: " + jobId);
                
                Job job = jobDAO.getJobById(jobId);
                if (job != null) {
                    System.out.println("Found job: " + job.getTitle() + " at " + job.getCompany());
                    
                    // Tạo danh sách câu hỏi cho buổi phỏng vấn
                    List<String> questions = generateQuestionsFromJob(job);
                    System.out.println("Generated " + questions.size() + " questions");
                    
                    // Tạo interview với câu hỏi đầu tiên
                    Interview interview = new Interview(user.getId(), "job_" + jobId, "");
                    interview.setTopic(job.getTitle() + " tại " + job.getCompany());
                    
                    System.out.println("Creating interview for user ID: " + user.getId());
                    if (interviewDAO.createInterview(interview)) {
                        System.out.println("Interview created successfully with ID: " + interview.getId());
                        
                        // Lưu tất cả câu hỏi vào session để sử dụng sau
                        session.setAttribute("interview_" + interview.getId() + "_questions", questions);
                        session.setAttribute("interview_" + interview.getId() + "_current_question", 0);
                        session.setAttribute("interview_" + interview.getId() + "_answers", new ArrayList<String>());
                        
                        // Verify session data was saved
                        @SuppressWarnings("unchecked")
                        List<String> savedQuestions = (List<String>) session.getAttribute("interview_" + interview.getId() + "_questions");
                        @SuppressWarnings("unchecked")
                        List<String> savedAnswers = (List<String>) session.getAttribute("interview_" + interview.getId() + "_answers");
                        Integer savedCurrentQuestion = (Integer) session.getAttribute("interview_" + interview.getId() + "_current_question");
                        
                        System.out.println("Session verification:");
                        System.out.println("  - Saved questions: " + (savedQuestions != null ? savedQuestions.size() : "null"));
                        System.out.println("  - Saved answers: " + (savedAnswers != null ? savedAnswers.size() : "null"));
                        System.out.println("  - Saved current question: " + savedCurrentQuestion);
                        
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        PrintWriter out = response.getWriter();
                        out.print("{\"success\": true, \"interviewId\": " + interview.getId()
                                + ", \"question\": \"" + questions.get(0).replace("\"", "\\\"")
                                + "\", \"jobTitle\": \"" + job.getTitle().replace("\"", "\\\"")
                                + "\", \"company\": \"" + job.getCompany().replace("\"", "\\\"")
                                + "\", \"totalQuestions\": " + questions.size()
                                + ", \"currentQuestion\": 1}");
                        out.flush();
                    } else {
                        System.err.println("Failed to create interview in database");
                        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create interview");
                    }
                } else {
                    System.err.println("Job not found with ID: " + jobId);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Job not found");
                }
            } catch (Exception e) {
                System.err.println("Error starting interview: " + e.getMessage());
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error starting interview");
            }
        } else if ("nextQuestion".equals(action)) {
            // Lấy câu hỏi tiếp theo
            try {
                int interviewId = Integer.parseInt(request.getParameter("interviewId"));
                String currentAnswer = request.getParameter("currentAnswer");
                
                System.out.println("Getting next question for interview ID: " + interviewId);
                System.out.println("Current answer: " + (currentAnswer != null ? currentAnswer.substring(0, Math.min(30, currentAnswer.length())) + "..." : "null"));
                
                // Lưu câu trả lời hiện tại
                @SuppressWarnings("unchecked")
                List<String> answers = (List<String>) session.getAttribute("interview_" + interviewId + "_answers");
                System.out.println("Current answers in session: " + (answers != null ? answers.size() : "null"));
                
                if (answers != null && currentAnswer != null) {
                    answers.add(currentAnswer);
                    session.setAttribute("interview_" + interviewId + "_answers", answers);
                    System.out.println("Added answer, total answers now: " + answers.size());
                } else {
                    System.err.println("Answers list is null or current answer is null");
                }
                
                // Lấy thông tin câu hỏi từ session
                @SuppressWarnings("unchecked")
                List<String> questions = (List<String>) session.getAttribute("interview_" + interviewId + "_questions");
                Integer currentQuestionIndex = (Integer) session.getAttribute("interview_" + interviewId + "_current_question");
                
                System.out.println("Questions in session: " + (questions != null ? questions.size() : "null"));
                System.out.println("Current question index: " + currentQuestionIndex);
                
                if (questions != null && currentQuestionIndex != null) {
                    currentQuestionIndex++;
                    
                    if (currentQuestionIndex < questions.size()) {
                        // Còn câu hỏi tiếp theo
                        session.setAttribute("interview_" + interviewId + "_current_question", currentQuestionIndex);
                        System.out.println("Moving to question " + (currentQuestionIndex + 1) + " of " + questions.size());
                        
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        PrintWriter out = response.getWriter();
                        out.print("{\"success\": true, \"hasNext\": true, \"question\": \"" + 
                                questions.get(currentQuestionIndex).replace("\"", "\\\"") + 
                                "\", \"currentQuestion\": " + (currentQuestionIndex + 1) + 
                                ", \"totalQuestions\": " + questions.size() + "}");
                        out.flush();
                    } else {
                        // Đã hết câu hỏi, chuyển sang đánh giá
                        System.out.println("No more questions, interview complete");
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        PrintWriter out = response.getWriter();
                        out.print("{\"success\": true, \"hasNext\": false, \"message\": \"Đã hoàn thành tất cả câu hỏi. Vui lòng gửi để đánh giá.\"}");
                        out.flush();
                    }
                } else {
                    System.err.println("Questions or current question index is null");
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Interview session not found");
                }
            } catch (Exception e) {
                System.err.println("Error getting next question: " + e.getMessage());
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error getting next question");
            }
        } else if ("evaluate".equals(action)) {
            // Đánh giá toàn bộ buổi phỏng vấn
            try {
                int interviewId = Integer.parseInt(request.getParameter("interviewId"));
                String finalAnswer = request.getParameter("finalAnswer");
                
                System.out.println("Evaluating complete interview ID: " + interviewId + " for user ID: " + user.getId());
                System.out.println("Final answer: " + (finalAnswer != null ? finalAnswer.substring(0, Math.min(50, finalAnswer.length())) + "..." : "null"));
                
                if (finalAnswer == null || finalAnswer.trim().isEmpty()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Final answer is required");
                    return;
                }
                
                // Lấy tất cả câu trả lời từ session
                @SuppressWarnings("unchecked")
                List<String> answers = (List<String>) session.getAttribute("interview_" + interviewId + "_answers");
                @SuppressWarnings("unchecked")
                List<String> questions = (List<String>) session.getAttribute("interview_" + interviewId + "_questions");
                
                System.out.println("Session answers: " + (answers != null ? answers.size() : "null"));
                System.out.println("Session questions: " + (questions != null ? questions.size() : "null"));
                
                if (answers == null) {
                    answers = new ArrayList<>();
                    System.out.println("Created new answers list");
                }
                answers.add(finalAnswer);
                System.out.println("Total answers after adding final: " + answers.size());
                
                // Log all answers for debugging
                for (int i = 0; i < answers.size(); i++) {
                    String answer = answers.get(i);
                    System.out.println("Answer " + (i + 1) + ": " + (answer != null ? answer.substring(0, Math.min(30, answer.length())) + "..." : "null"));
                }
                
                Interview interview = interviewDAO.getInterviewById(interviewId);
                System.out.println("Retrieved interview: " + (interview != null ? "Found" : "Not found"));
                
                if (interview != null) {
                    System.out.println("Interview user ID: " + interview.getUserId() + ", Current user ID: " + user.getId());
                    System.out.println("Interview topic: " + interview.getTopic());
                }
                
                if (interview != null && interview.getUserId() == user.getId()) {
                    System.out.println("Processing complete interview evaluation...");
                    
                    // Combine all questions and answers into a formatted string
                    StringBuilder combinedQA = new StringBuilder();
                    if (questions != null && answers != null) {
                        for (int i = 0; i < questions.size() && i < answers.size(); i++) {
                            combinedQA.append("Câu hỏi ").append(i + 1).append(": ").append(questions.get(i)).append("\n");
                            combinedQA.append("Câu trả lời: ").append(answers.get(i) != null ? answers.get(i) : "Không có câu trả lời").append("\n\n");
                        }
                    }
                    
                    // Tạo đánh giá tổng hợp cho toàn bộ buổi phỏng vấn
                    String evaluation = evaluateCompleteInterview(questions, answers, interview.getTopic());
                    System.out.println("Evaluation result: " + evaluation);
                    
                    // Parse kết quả từ AI
                    Map<String, String> result = parseAIEvaluation(evaluation);
                    System.out.println("Parsed result: " + result);
                    
                    interview.setUserAnswer(combinedQA.toString());
                    interview.setAiFeedback(result.get("feedback"));
                    interview.setSuggestions(result.get("suggestions"));
                    interview.setStatus("completed");
                    
                    if (interviewDAO.updateInterview(interview)) {
                        System.out.println("Interview evaluation completed successfully");
                        
                        // Xóa session data
                        session.removeAttribute("interview_" + interviewId + "_questions");
                        session.removeAttribute("interview_" + interviewId + "_current_question");
                        session.removeAttribute("interview_" + interviewId + "_answers");
                        
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        PrintWriter out = response.getWriter();
                        out.print("{\"success\": true, \"feedback\": \"" + result.get("feedback").replace("\"", "\\\"")
                                + "\", \"strengths\": \"" + result.get("strengths").replace("\"", "\\\"").replace("\n", "\\n")
                                + "\", \"weaknesses\": \"" + result.get("weaknesses").replace("\"", "\\\"").replace("\n", "\\n")
                                + "\", \"suggestions\": \"" + result.get("suggestions").replace("\"", "\\\"").replace("\n", "\\n")
                                + "\", \"overallRating\": \"" + result.get("overallRating").replace("\"", "\\\"") + "\"}");
                        out.flush();
                    } else {
                        System.err.println("Failed to update interview in database");
                        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update interview");
                    }
                } else {
                    System.err.println("Interview not found or unauthorized access. Interview: " + (interview != null ? "exists" : "null"));
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Interview not found");
                }
            } catch (Exception e) {
                System.err.println("Error evaluating complete interview: " + e.getMessage());
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error evaluating interview");
            }
        } else {
            // Hiển thị trang phỏng vấn với danh sách jobs
            try {
                List<Job> jobs = jobDAO.getAllJobs();
                request.setAttribute("jobs", jobs);
                request.getRequestDispatcher("/view/virtualInterview.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private List<String> generateQuestionsFromJob(Job job) {
        List<String> questions = new ArrayList<>();
        
        // Check if ChatGPT API is available
        if (!LLMService.isChatGPTAvailable()) {
            System.out.println("ChatGPT API not available, using fallback questions");
            questions = generateFallbackQuestions(job.getTitle());
        } else {
            // Generate questions using ChatGPT
            String prompt = String.format(
                "Bạn là một chuyên gia phỏng vấn IT. Dựa trên thông tin công việc sau, hãy tạo ra 5 câu hỏi phỏng vấn phù hợp:\n\n" +
                "Vị trí: %s\n" +
                "Công ty: %s\n" +
                "Kỹ năng yêu cầu: %s\n" +
                "Mô tả công việc: %s\n" +
                "Kinh nghiệm: %s\n\n" +
                "Hãy tạo ra 5 câu hỏi phỏng vấn cụ thể, thực tế và phù hợp với vị trí này. " +
                "Câu hỏi có thể về:\n" +
                "- Kỹ năng kỹ thuật liên quan\n" +
                "- Kinh nghiệm làm việc\n" +
                "- Tình huống thực tế\n" +
                "- Kiến thức về công nghệ\n" +
                "- Câu hỏi chung về nghề nghiệp\n\n" +
                "Trả về mỗi câu hỏi trên một dòng riêng, không đánh số.",
                job.getTitle(),
                job.getCompany(),
                job.getSkillRequired() != null ? job.getSkillRequired() : "Không yêu cầu cụ thể",
                job.getDescription() != null ? job.getDescription() : "Không có mô tả",
                job.getExperience() != null ? job.getExperience() : "Không yêu cầu"
            );
            
            try {
                String aiQuestions = LLMService.callChatGPT(prompt);
                if (aiQuestions != null && !aiQuestions.trim().isEmpty()) {
                    String[] lines = aiQuestions.split("\n");
                    for (String line : lines) {
                        String question = line.trim();
                        if (!question.isEmpty() && questions.size() < 5) {
                            questions.add(question);
                        }
                    }
                }
            } catch (Exception e) {
                System.out.println("ChatGPT API error, using fallback questions: " + e.getMessage());
            }
        }
        
        // Nếu không đủ 5 câu hỏi, bổ sung bằng fallback
        if (questions.size() < 5) {
            List<String> fallbackQuestions = generateFallbackQuestions(job.getTitle());
            for (String question : fallbackQuestions) {
                if (!questions.contains(question) && questions.size() < 5) {
                    questions.add(question);
                }
            }
        }
        
        return questions;
    }
    
    private List<String> generateFallbackQuestions(String jobTitle) {
        Map<String, List<String>> fallbackQuestions = new HashMap<>();
        
        fallbackQuestions.put("java", List.of(
            "Bạn có thể giải thích về tính đa hình trong Java không?",
            "Sự khác biệt giữa ArrayList và LinkedList là gì?",
            "Bạn hiểu gì về Garbage Collection trong Java?",
            "Làm thế nào để xử lý exception trong Java?",
            "Bạn có thể giải thích về Thread và Process không?"
        ));
        
        fallbackQuestions.put("python", List.of(
            "Bạn có thể giải thích về List Comprehension trong Python không?",
            "Sự khác biệt giữa List và Tuple là gì?",
            "Bạn hiểu gì về Decorator trong Python?",
            "Làm thế nào để xử lý file trong Python?",
            "Bạn có thể giải thích về Generator trong Python không?"
        ));
        
        fallbackQuestions.put("javascript", List.of(
            "Bạn có thể giải thích về Closure trong JavaScript không?",
            "Sự khác biệt giữa var, let và const là gì?",
            "Bạn hiểu gì về Promise và async/await?",
            "Làm thế nào để xử lý DOM trong JavaScript?",
            "Bạn có thể giải thích về Event Loop trong JavaScript không?"
        ));
        
        fallbackQuestions.put("frontend", List.of(
            "Bạn có thể giải thích về Virtual DOM trong React không?",
            "Sự khác biệt giữa state và props là gì?",
            "Bạn hiểu gì về CSS Grid và Flexbox?",
            "Làm thế nào để tối ưu hóa performance của React app?",
            "Bạn có thể giải thích về React Hooks không?"
        ));
        
        fallbackQuestions.put("backend", List.of(
            "Bạn có thể giải thích về RESTful API không?",
            "Sự khác biệt giữa GET và POST là gì?",
            "Bạn hiểu gì về authentication và authorization?",
            "Làm thế nào để xử lý database transactions?",
            "Bạn có thể giải thích về microservices architecture không?"
        ));
        
        fallbackQuestions.put("database", List.of(
            "Bạn có thể giải thích về ACID properties không?",
            "Sự khác biệt giữa INNER JOIN và LEFT JOIN là gì?",
            "Bạn hiểu gì về Index trong database?",
            "Làm thế nào để tối ưu hóa query?",
            "Bạn có thể giải thích về Normalization không?"
        ));
        
        fallbackQuestions.put("general", List.of(
            "Bạn có thể giới thiệu về bản thân và kinh nghiệm làm việc không?",
            "Tại sao bạn muốn làm việc tại công ty chúng tôi?",
            "Điểm mạnh và điểm yếu của bạn là gì?",
            "Bạn xử lý stress và áp lực công việc như thế nào?",
            "Mục tiêu nghề nghiệp của bạn trong 5 năm tới là gì?"
        ));
        
        // Determine category based on job title
        String category = "general";
        String titleLower = jobTitle.toLowerCase();
        
        if (titleLower.contains("java")) category = "java";
        else if (titleLower.contains("python")) category = "python";
        else if (titleLower.contains("javascript") || titleLower.contains("js")) category = "javascript";
        else if (titleLower.contains("frontend") || titleLower.contains("react") || titleLower.contains("vue") || titleLower.contains("angular")) category = "frontend";
        else if (titleLower.contains("backend") || titleLower.contains("api") || titleLower.contains("server")) category = "backend";
        else if (titleLower.contains("database") || titleLower.contains("sql") || titleLower.contains("db")) category = "database";
        
        return fallbackQuestions.getOrDefault(category, fallbackQuestions.get("general"));
    }
    
    private String evaluateCompleteInterview(List<String> questions, List<String> answers, String topic) {
        System.out.println("Evaluating complete interview for topic: " + topic);
        System.out.println("Number of questions: " + (questions != null ? questions.size() : 0));
        System.out.println("Number of answers: " + (answers != null ? answers.size() : 0));
        
        // Check if ChatGPT API is available
        if (!LLMService.isChatGPTAvailable()) {
            System.out.println("ChatGPT API not available, using fallback evaluation");
            return generateFallbackCompleteEvaluation(questions, answers, topic);
        }
        
        try {
            StringBuilder prompt = new StringBuilder();
            prompt.append("Bạn là một chuyên gia phỏng vấn IT có kinh nghiệm 10 năm. Hãy đánh giá chi tiết buổi phỏng vấn sau:\n\n");
            prompt.append("CHỦ ĐỀ PHỎNG VẤN: ").append(topic != null ? topic : "Phỏng vấn chung").append("\n\n");
            
            if (questions != null && answers != null) {
                for (int i = 0; i < questions.size() && i < answers.size(); i++) {
                    prompt.append("Câu hỏi ").append(i + 1).append(": ").append(questions.get(i)).append("\n");
                    prompt.append("Câu trả lời: ").append(answers.get(i) != null ? answers.get(i) : "Không có câu trả lời").append("\n\n");
                }
            }
            
            prompt.append("Hãy đánh giá chi tiết buổi phỏng vấn theo các tiêu chí sau:\n\n");
            prompt.append("1. NỘI DUNG CÂU TRẢ LỜI:\n");
            prompt.append("   - Độ chi tiết và đầy đủ của thông tin\n");
            prompt.append("   - Tính chính xác về mặt kỹ thuật\n");
            prompt.append("   - Sự liên quan đến câu hỏi\n\n");
            
            prompt.append("2. KỸ NĂNG TRÌNH BÀY:\n");
            prompt.append("   - Cách tổ chức ý tưởng\n");
            prompt.append("   - Khả năng giải thích rõ ràng\n");
            prompt.append("   - Sử dụng ví dụ minh họa\n\n");
            
            prompt.append("3. KIẾN THỨC CHUYÊN MÔN:\n");
            prompt.append("   - Mức độ hiểu biết về chủ đề\n");
            prompt.append("   - Kinh nghiệm thực tế\n");
            prompt.append("   - Cập nhật công nghệ mới\n\n");
            
            prompt.append("4. THÁI ĐỘ VÀ TÍNH CHUYÊN NGHIỆP:\n");
            prompt.append("   - Sự tự tin trong trả lời\n");
            prompt.append("   - Thái độ học hỏi\n");
            prompt.append("   - Tính chuyên nghiệp\n\n");
            
            prompt.append("Hãy trả về đánh giá theo format sau:\n");
            prompt.append("FEEDBACK: [Nhận xét tổng quan chi tiết về buổi phỏng vấn]\n");
            prompt.append("STRENGTHS: [Liệt kê 3-5 điểm mạnh cụ thể]\n");
            prompt.append("WEAKNESSES: [Liệt kê 3-5 điểm cần cải thiện]\n");
            prompt.append("SUGGESTIONS: [Gợi ý cụ thể để cải thiện trong tương lai]\n");
            prompt.append("OVERALL_RATING: [Đánh giá tổng thể: Xuất sắc/Tốt/Khá/Cần cải thiện/Yếu]");
            
            System.out.println("Sending detailed prompt to ChatGPT: " + prompt.toString());
            
            String aiEvaluation = LLMService.callChatGPT(prompt.toString());
            if (aiEvaluation != null && !aiEvaluation.trim().isEmpty()) {
                System.out.println("Received AI evaluation: " + aiEvaluation);
                return aiEvaluation;
            } else {
                System.err.println("AI evaluation is null or empty");
            }
        } catch (Exception e) {
            System.err.println("ChatGPT API error during complete evaluation: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Fallback evaluation
        System.out.println("Using fallback evaluation");
        return generateFallbackCompleteEvaluation(questions, answers, topic);
    }
    
    private String generateFallbackCompleteEvaluation(List<String> questions, List<String> answers, String topic) {
        System.out.println("Generating fallback evaluation for topic: " + topic);
        
        // Handle null inputs
        if (questions == null) questions = new ArrayList<>();
        if (answers == null) answers = new ArrayList<>();
        
        // Analyze answer quality
        int detailedAnswers = 0;
        int moderateAnswers = 0;
        int shortAnswers = 0;
        int emptyAnswers = 0;
        int totalAnswered = 0;
        
        for (String answer : answers) {
            if (answer != null && !answer.trim().isEmpty()) {
                int answerLength = answer.trim().length();
                if (answerLength > 100) {
                    detailedAnswers++;
                } else if (answerLength > 50) {
                    moderateAnswers++;
                } else if (answerLength > 10) {
                    shortAnswers++;
                } else {
                    emptyAnswers++;
                }
                totalAnswered++;
            } else {
                emptyAnswers++;
            }
        }
        
        // Generate comprehensive feedback
        String feedback = "Cảm ơn bạn đã tham gia buổi phỏng vấn về " + (topic != null ? topic : "chủ đề này") + ". ";
        
        if (detailedAnswers > moderateAnswers && detailedAnswers > shortAnswers) {
            feedback += "Bạn đã thể hiện rất tốt với những câu trả lời chi tiết và chuyên nghiệp. ";
        } else if (moderateAnswers > shortAnswers) {
            feedback += "Bạn đã có những câu trả lời khá tốt và thể hiện kiến thức cơ bản. ";
        } else if (shortAnswers > emptyAnswers) {
            feedback += "Bạn đã cố gắng trả lời các câu hỏi, nhưng cần cải thiện thêm về độ chi tiết. ";
        } else {
            feedback += "Bạn cần cải thiện đáng kể để có kết quả tốt hơn trong các buổi phỏng vấn tiếp theo. ";
        }
        
        // Generate strengths
        StringBuilder strengths = new StringBuilder();
        if (detailedAnswers > 0) {
            strengths.append("• Có khả năng trả lời chi tiết và đầy đủ thông tin\n");
        }
        if (totalAnswered == questions.size()) {
            strengths.append("• Hoàn thành tất cả câu hỏi phỏng vấn\n");
        }
        if (topic != null && !topic.trim().isEmpty()) {
            strengths.append("• Thể hiện sự quan tâm đến chủ đề phỏng vấn\n");
        }
        if (strengths.length() == 0) {
            strengths.append("• Có thái độ tích cực tham gia phỏng vấn\n");
        }
        
        // Generate weaknesses
        StringBuilder weaknesses = new StringBuilder();
        if (emptyAnswers > 0) {
            weaknesses.append("• Có " + emptyAnswers + " câu hỏi chưa được trả lời\n");
        }
        if (shortAnswers > detailedAnswers) {
            weaknesses.append("• Câu trả lời còn ngắn gọn, thiếu chi tiết\n");
        }
        if (totalAnswered < questions.size()) {
            weaknesses.append("• Chưa hoàn thành tất cả câu hỏi phỏng vấn\n");
        }
        if (weaknesses.length() == 0) {
            weaknesses.append("• Cần cải thiện thêm về cách trình bày ý tưởng\n");
        }
        
        // Generate suggestions
        StringBuilder suggestions = new StringBuilder();
        if (emptyAnswers > 0) {
            suggestions.append("• Cố gắng trả lời tất cả câu hỏi, ngay cả khi không chắc chắn\n");
        }
        if (shortAnswers > detailedAnswers) {
            suggestions.append("• Mở rộng câu trả lời với ví dụ cụ thể và giải thích chi tiết\n");
        }
        suggestions.append("• Rèn luyện kỹ năng giao tiếp và trình bày ý tưởng\n");
        suggestions.append("• Cập nhật kiến thức chuyên môn thường xuyên\n");
        suggestions.append("• Thực hành phỏng vấn thường xuyên để cải thiện kỹ năng\n");
        
        // Determine overall rating
        String overallRating;
        if (detailedAnswers > moderateAnswers && totalAnswered == questions.size()) {
            overallRating = "Tốt";
        } else if (moderateAnswers > shortAnswers && totalAnswered >= questions.size() * 0.8) {
            overallRating = "Khá";
        } else if (shortAnswers > emptyAnswers) {
            overallRating = "Cần cải thiện";
        } else {
            overallRating = "Yếu";
        }
        
        String result = String.format("FEEDBACK: %s\nSTRENGTHS: %s\nWEAKNESSES: %s\nSUGGESTIONS: %s\nOVERALL_RATING: %s", 
                feedback, strengths.toString().trim(), weaknesses.toString().trim(), 
                suggestions.toString().trim(), overallRating);
        
        System.out.println("Generated fallback evaluation: " + result);
        return result;
    }
    
    private Map<String, String> parseAIEvaluation(String evaluation) {
        Map<String, String> result = new HashMap<>();
        
        System.out.println("Parsing AI evaluation: " + evaluation);
        
        if (evaluation == null || evaluation.trim().isEmpty()) {
            System.err.println("Evaluation is null or empty");
            result.put("feedback", "Không thể đánh giá câu trả lời - Dữ liệu trống.");
            result.put("strengths", "• Có thái độ tích cực tham gia phỏng vấn");
            result.put("weaknesses", "• Cần cải thiện thêm về cách trình bày ý tưởng");
            result.put("suggestions", "• Rèn luyện kỹ năng giao tiếp và trình bày ý tưởng\n• Cập nhật kiến thức chuyên môn thường xuyên");
            result.put("overallRating", "Cần cải thiện");
            return result;
        }
        
        try {
            // Parse feedback
            int feedbackStart = evaluation.indexOf("FEEDBACK:");
            int feedbackEnd = evaluation.indexOf("STRENGTHS:");
            
            if (feedbackStart >= 0 && feedbackEnd > feedbackStart) {
                String feedback = evaluation.substring(feedbackStart + 9, feedbackEnd).trim();
                result.put("feedback", feedback);
                System.out.println("Parsed feedback: " + feedback);
            } else {
                System.err.println("Could not find FEEDBACK section");
                result.put("feedback", "Cảm ơn bạn đã tham gia buổi phỏng vấn. Hãy tiếp tục rèn luyện kỹ năng.");
            }
            
            // Parse strengths
            int strengthsStart = evaluation.indexOf("STRENGTHS:");
            int strengthsEnd = evaluation.indexOf("WEAKNESSES:");
            
            if (strengthsStart >= 0 && strengthsEnd > strengthsStart) {
                String strengths = evaluation.substring(strengthsStart + 10, strengthsEnd).trim();
                result.put("strengths", strengths);
                System.out.println("Parsed strengths: " + strengths);
            } else {
                System.err.println("Could not find STRENGTHS section");
                result.put("strengths", "• Có thái độ tích cực tham gia phỏng vấn");
            }
            
            // Parse weaknesses
            int weaknessesStart = evaluation.indexOf("WEAKNESSES:");
            int weaknessesEnd = evaluation.indexOf("SUGGESTIONS:");
            
            if (weaknessesStart >= 0 && weaknessesEnd > weaknessesStart) {
                String weaknesses = evaluation.substring(weaknessesStart + 11, weaknessesEnd).trim();
                result.put("weaknesses", weaknesses);
                System.out.println("Parsed weaknesses: " + weaknesses);
            } else {
                System.err.println("Could not find WEAKNESSES section");
                result.put("weaknesses", "• Cần cải thiện thêm về cách trình bày ý tưởng");
            }
            
            // Parse suggestions
            int suggestionsStart = evaluation.indexOf("SUGGESTIONS:");
            int suggestionsEnd = evaluation.indexOf("OVERALL_RATING:");
            
            if (suggestionsStart >= 0 && suggestionsEnd > suggestionsStart) {
                String suggestions = evaluation.substring(suggestionsStart + 12, suggestionsEnd).trim();
                result.put("suggestions", suggestions);
                System.out.println("Parsed suggestions: " + suggestions);
            } else {
                System.err.println("Could not find SUGGESTIONS section");
                result.put("suggestions", "• Rèn luyện kỹ năng giao tiếp và trình bày ý tưởng\n• Cập nhật kiến thức chuyên môn thường xuyên");
            }
            
            // Parse overall rating
            int ratingStart = evaluation.indexOf("OVERALL_RATING:");
            
            if (ratingStart >= 0) {
                String rating = evaluation.substring(ratingStart + 15).trim();
                result.put("overallRating", rating);
                System.out.println("Parsed overall rating: " + rating);
            } else {
                System.err.println("Could not find OVERALL_RATING section");
                result.put("overallRating", "Khá");
            }
            
        } catch (Exception e) {
            System.err.println("Error parsing AI evaluation: " + e.getMessage());
            e.printStackTrace();
            
            // Fallback values
            result.put("feedback", "Cảm ơn bạn đã tham gia buổi phỏng vấn. Hãy tiếp tục rèn luyện kỹ năng.");
            result.put("strengths", "• Có thái độ tích cực tham gia phỏng vấn");
            result.put("weaknesses", "• Cần cải thiện thêm về cách trình bày ý tưởng");
            result.put("suggestions", "• Rèn luyện kỹ năng giao tiếp và trình bày ý tưởng\n• Cập nhật kiến thức chuyên môn thường xuyên");
            result.put("overallRating", "Khá");
        }
        
        // Ensure all required fields are present
        if (!result.containsKey("feedback")) {
            result.put("feedback", "Cảm ơn bạn đã tham gia buổi phỏng vấn.");
        }
        if (!result.containsKey("strengths")) {
            result.put("strengths", "• Có thái độ tích cực tham gia phỏng vấn");
        }
        if (!result.containsKey("weaknesses")) {
            result.put("weaknesses", "• Cần cải thiện thêm về cách trình bày ý tưởng");
        }
        if (!result.containsKey("suggestions")) {
            result.put("suggestions", "• Rèn luyện kỹ năng giao tiếp và trình bày ý tưởng\n• Cập nhật kiến thức chuyên môn thường xuyên");
        }
        if (!result.containsKey("overallRating")) {
            result.put("overallRating", "Khá");
        }
        
        System.out.println("Final parsed result: " + result);
        return result;
    }
}
