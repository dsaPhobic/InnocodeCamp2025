package controller;

import dao.RecommendationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.JobRecommendation;
import model.User;
import service.MarkdownUtils;


@WebServlet(name = "JobRecommendationServlet", urlPatterns = {"/JobRecommendationServlet"})
public class JobRecommendationServlet extends HttpServlet {

    private RecommendationDAO recommendationDAO;

    @Override
    public void init() throws ServletException {
        recommendationDAO = new RecommendationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Kiểm tra session đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("view/login.jsp");
            return;
        }

        // Lấy user từ session
        User currentUser = (User) session.getAttribute("user");
        int userId = currentUser.getId();

        // Gọi DAO để lấy danh sách job được gợi ý
        List<JobRecommendation> recommendations = recommendationDAO.generateRecommendationsForUser(userId);

// ✅ Convert mô tả Markdown sang HTML cho từng job
        for (JobRecommendation rec : recommendations) {
            if (rec.getJob() != null && rec.getJob().getDescription() != null) {
                String markdown = rec.getJob().getDescription();
                System.out.println("[LOG] JobID: " + rec.getJob().getId() + " - Markdown: " + markdown);
                String html = MarkdownUtils.toHtml(markdown);
                System.out.println("[LOG] JobID: " + rec.getJob().getId() + " - HTML: " + html);
                rec.getJob().setDescription(html); // Gán lại nội dung đã render
            }
        }
        

        // Gửi danh sách sang JSP
        request.setAttribute("recommendations", recommendations);

        // Chuyển đến trang hiển thị gợi ý
        request.getRequestDispatcher("view/jobSuggestions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // POST dùng chung xử lý như GET
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý gợi ý việc làm theo kỹ năng (theo score) của người dùng";
    }
}
