/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.SkillDAO;
import dao.RecommendationDAO;
import model.Skill;
import model.JobRecommendation;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import model.Job;
import service.LLMService;

/**
 *
 * @author hmqua
 */
@WebServlet(name = "SkillChartServlet", urlPatterns = {"/SkillChartServlet"})
public class SkillChartServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SkillChartServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SkillChartServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        System.out.println("[SkillChartServlet] Session ID: " + (session != null ? session.getId() : "null"));
        System.out.println("[SkillChartServlet] Session user: " + (session != null ? session.getAttribute("user") : "null"));
        model.User user = (session != null) ? (model.User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect("view/login.jsp");
            return;
        }
        int userId = user.getId();
        System.out.println("[SkillChartServlet] userId: " + userId);
        SkillDAO skillDAO = new SkillDAO();
        List<Skill> skills = skillDAO.getSkillsByUser(userId);
        System.out.println("[SkillChartServlet] Skills count: " + (skills != null ? skills.size() : 0));
        if (skills != null) {
            for (Skill s : skills) {
                System.out.println("Skill: " + s.getSkillName() + " - " + s.getScore());
            }
        }
        request.setAttribute("skills", skills);

        // Kiểm tra nếu user chưa có kỹ năng nào
        if (skills == null || skills.isEmpty()) {
            request.setAttribute("noSkills", true);
            request.getRequestDispatcher("/view/skillChart.jsp").forward(request, response);
            return;
        }

        // Lấy job recommendations để so sánh skill
        RecommendationDAO recommendationDAO = new RecommendationDAO();
        List<JobRecommendation> recommendations = recommendationDAO.generateRecommendationsForUser(userId);
        System.out.println("[SkillChartServlet] Recommendations count: " + (recommendations != null ? recommendations.size() : 0));
        
        // Debug: Kiểm tra từng recommendation
        if (recommendations != null) {
            for (int i = 0; i < recommendations.size(); i++) {
                JobRecommendation rec = recommendations.get(i);
                System.out.println("[SkillChartServlet] Recommendation " + i + ":");
                System.out.println("  - Job: " + (rec.getJob() != null ? rec.getJob().getTitle() : "null"));
                System.out.println("  - Company: " + (rec.getJob() != null ? rec.getJob().getCompany() : "null"));
                System.out.println("  - Skills Required: " + (rec.getJob() != null ? rec.getJob().getSkillRequired() : "null"));
                System.out.println("  - Match %: " + rec.getMatchPercent());
                System.out.println("  - Match Detail: " + rec.getMatchDetail());
            }
        }
        
        // Tạo map skill user để so sánh
        Map<String, Integer> userSkillMap = new HashMap<>();
        for (Skill skill : skills) {
            userSkillMap.put(skill.getSkillName().toLowerCase().trim(), skill.getScore());
        }
        System.out.println("[SkillChartServlet] User skill map: " + userSkillMap);
        
        // Lấy dữ liệu trung bình thị trường cho từng skill
        Map<String, Double> marketAverages = skillDAO.getMarketSkillAverages();
        System.out.println("[SkillChartServlet] Market averages: " + marketAverages);
        
        // Tạo dữ liệu cho biểu đồ cột so sánh
        List<Map<String, Object>> comparisonData = new java.util.ArrayList<>();
        for (Skill userSkill : skills) {
            Map<String, Object> skillData = new HashMap<>();
            skillData.put("skillName", userSkill.getSkillName());
            skillData.put("userScore", userSkill.getScore());
            
            Double marketAvg = marketAverages.get(userSkill.getSkillName().toLowerCase());
            if (marketAvg == null) {
                marketAvg = 50.0; // Default value if no market data
            }
            skillData.put("marketAverage", marketAvg);
            
            comparisonData.add(skillData);
        }
        
        request.setAttribute("comparisonData", comparisonData);
        
        // Gửi danh sách recommendations trực tiếp
        request.setAttribute("recommendations", recommendations);
        System.out.println("[SkillChartServlet] Total recommendations: " + recommendations.size());
        
        // Debug: Tạo test data nếu recommendations rỗng
        if (recommendations.isEmpty()) {
            System.out.println("[SkillChartServlet] Creating test recommendations...");
            List<JobRecommendation> testRecommendations = new java.util.ArrayList<>();
            
            Job testJob = new Job();
            testJob.setId(999);
            testJob.setTitle("Test Job - Java Developer");
            testJob.setCompany("Test Company");
            testJob.setLocation("Ho Chi Minh City");
            testJob.setSalary(20000000);
            testJob.setExperience("2-3 years");
            testJob.setSkillRequired("Java, Spring, MySQL");
            testJob.setDescription("Test job description for Java Developer position");
            
            JobRecommendation testRec = new JobRecommendation();
            testRec.setJob(testJob);
            testRec.setMatchPercent(85);
            testRec.setMatchDetail("85/300 điểm phù hợp");
            
            testRecommendations.add(testRec);
            request.setAttribute("recommendations", testRecommendations);
            System.out.println("[SkillChartServlet] Test recommendations created");
        }

        // Tìm skill yếu và sinh gợi ý học tập bằng LLMService
        List<String> weakSkillSuggestions = new java.util.ArrayList<>();
        if (skills != null && !skills.isEmpty()) {
            for (Skill s : skills) {
                if (s.getScore() < 60) {
                    String prompt = "Gợi ý tài liệu hoặc khóa học để cải thiện kỹ năng " + s.getSkillName() + " cho người mới bắt đầu. Trả về dưới dạng markdown với format:\n\n" +
                                  "## " + s.getSkillName() + " (" + s.getScore() + "/100)\n\n" +
                                  "### 📚 Sách học\n" +
                                  "- **Tên sách**: Mô tả chi tiết về sách và lợi ích.\n  [Link mua sách](url)\n\n" +
                                  "### 🎓 Khóa học online\n" +
                                  "- **Tên khóa học**: Mô tả chi tiết về khóa học và nội dung.\n  [Link khóa học](url)\n\n" +
                                  "### 💡 Tài liệu miễn phí\n" +
                                  "- **Tên tài liệu**: Mô tả chi tiết về tài liệu và cách sử dụng.\n  [Link tài liệu](url)\n\n" +
                                  "### 🛠️ Thực hành\n" +
                                  "- **Dự án thực hành**: Mô tả chi tiết về dự án và mục tiêu.\n  [Link dự án](url)";
                    
                    String suggestion;
                    try {
                        java.util.List<model.Message> chatHistory = new java.util.ArrayList<>();
                        chatHistory.add(new model.Message("user", prompt));
                        suggestion = service.LLMService.getResponse(chatHistory);
                        if (suggestion == null || suggestion.trim().isEmpty()) {
                                                    suggestion = "## " + s.getSkillName() + " (" + s.getScore() + "/100)\n\n" +
                                   "### 📚 Sách học\n" +
                                   "- **C++ Primer (5th Edition)**: Cuốn sách này là một trong những sách tiêu chuẩn dành cho người mới bắt đầu học C++. Nó cung cấp một cái nhìn tổng quát và sâu sắc về ngôn ngữ C++ cùng với các ví dụ và bài tập thực hành.\n  [Link mua sách](https://www.amazon.com/Primer-5th-Stanley-B-Lippman/dp/0321714113)\n\n" +
                                   "### 🎓 Khóa học online\n" +
                                   "- **Beginning C++ Programming - From Beginner to Beyond**: Khóa học này hướng dẫn từ cơ bản đến nâng cao trong C++, có nhiều bài tập và thách thức để rèn luyện kỹ năng.\n  [Link khóa học](https://www.udemy.com/course/beginning-c-plus-plus-programming/)\n\n" +
                                   "### 💡 Tài liệu miễn phí\n" +
                                   "- **LearnCpp.com**: Đây là một trang web miễn phí cung cấp nhiều bài viết và hướng dẫn từ cơ bản đến nâng cao về C++. Phù hợp cho người mới bắt đầu và người muốn nâng cao kỹ năng của mình.\n  [Link tài liệu](https://www.learncpp.com/)\n\n" +
                                   "### 🛠️ Thực hành\n" +
                                   "- **Build a simple text-based game**: Tạo một trò chơi đơn giản như \"Guess the Number\" hay \"Tic-Tac-Toe\" bằng C++. Đây là một dự án nhỏ giúp củng cố kiến thức về logic và cấu trúc chương trình.\n  [Link dự án](https://www.geeksforgeeks.org/building-a-basic-console-based-gaming-in-c-language/)";
                        }
                    } catch (Exception e) {
                        System.err.println("[SkillChartServlet] LLM Error for skill " + s.getSkillName() + ": " + e.getMessage());
                        suggestion = "## " + s.getSkillName() + " (" + s.getScore() + "/100)\n\n" +
                                   "### 📚 Sách học\n" +
                                   "- **C++ Primer (5th Edition)**: Cuốn sách này là một trong những sách tiêu chuẩn dành cho người mới bắt đầu học C++. Nó cung cấp một cái nhìn tổng quát và sâu sắc về ngôn ngữ C++ cùng với các ví dụ và bài tập thực hành.\n  [Link mua sách](https://www.amazon.com/Primer-5th-Stanley-B-Lippman/dp/0321714113)\n\n" +
                                   "### 🎓 Khóa học online\n" +
                                   "- **Beginning C++ Programming - From Beginner to Beyond**: Khóa học này hướng dẫn từ cơ bản đến nâng cao trong C++, có nhiều bài tập và thách thức để rèn luyện kỹ năng.\n  [Link khóa học](https://www.udemy.com/course/beginning-c-plus-plus-programming/)\n\n" +
                                   "### 💡 Tài liệu miễn phí\n" +
                                   "- **LearnCpp.com**: Đây là một trang web miễn phí cung cấp nhiều bài viết và hướng dẫn từ cơ bản đến nâng cao về C++. Phù hợp cho người mới bắt đầu và người muốn nâng cao kỹ năng của mình.\n  [Link tài liệu](https://www.learncpp.com/)\n\n" +
                                   "### 🛠️ Thực hành\n" +
                                   "- **Build a simple text-based game**: Tạo một trò chơi đơn giản như \"Guess the Number\" hay \"Tic-Tac-Toe\" bằng C++. Đây là một dự án nhỏ giúp củng cố kiến thức về logic và cấu trúc chương trình.\n  [Link dự án](https://www.geeksforgeeks.org/building-a-basic-console-based-gaming-in-c-language/)";
                    }
                    weakSkillSuggestions.add(suggestion);
                }
            }
        }
        request.setAttribute("weakSkillSuggestions", weakSkillSuggestions);

        request.getRequestDispatcher("/view/skillChart.jsp").forward(request, response);
    }



    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }


    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
