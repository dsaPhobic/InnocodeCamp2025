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
import service.LocationService;


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

        // Xử lý AJAX kiểm tra địa chỉ
        String action = request.getParameter("action");
        if ("checkAddress".equals(action)) {
            String address = request.getParameter("address");
            boolean found = false;
            if (address != null && !address.trim().isEmpty()) {
                LocationService locationService = new LocationService();
                found = locationService.isAddressFound(address.trim());
            }
            response.setContentType("text/plain; charset=UTF-8");
            response.getWriter().write(Boolean.toString(found));
            response.getWriter().flush();
            return;
        }

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

        // Lọc theo title nếu có tham số search
        String searchTitle = request.getParameter("title");
        if (searchTitle != null && !searchTitle.trim().isEmpty()) {
            String keyword = searchTitle.trim().toLowerCase();
            recommendations.removeIf(rec -> rec.getJob() == null || rec.getJob().getTitle() == null || !rec.getJob().getTitle().toLowerCase().contains(keyword));
        }

        // Lọc theo location + radius nếu có
        String searchLocation = request.getParameter("location");
        String radiusStr = request.getParameter("radiusKm");
        if (searchLocation != null && !searchLocation.trim().isEmpty() && radiusStr != null && !radiusStr.trim().isEmpty()) {
            LocationService locationService = new LocationService();
            String userGPS = locationService.getCoordinatesFromAddress(searchLocation.trim());
            final double radiusKm = 
                (radiusStr != null && !radiusStr.trim().isEmpty()) ? 
                Double.parseDouble(radiusStr) : 0;
            if (userGPS != null && userGPS.contains(",") && radiusKm > 0) {
                recommendations.removeIf(rec -> {
                    if (rec.getJob() == null || rec.getJob().getLocation() == null) return true;
                    String jobGPS = locationService.getCoordinatesFromAddress(rec.getJob().getLocation());
                    return !(jobGPS != null && jobGPS.contains(",") && LocationService.isWithinRadius(userGPS, jobGPS, radiusKm));
                });
            }
        }

// ✅ Convert mô tả Markdown sang HTML cho từng job
        for (JobRecommendation rec : recommendations) {
            if (rec.getJob() != null && rec.getJob().getDescription() != null) {
                String markdown = rec.getJob().getDescription();
                String html = MarkdownUtils.toHtml(markdown);
                rec.getJob().setDescription(html); // Gán lại nội dung đã render
            }
        }
        

        // Gửi danh sách sang JSP
        request.setAttribute("recommendations", recommendations);

        // Lấy jobId nếu có để truyền sang JSP
        String jobId = request.getParameter("jobId");
        if (jobId != null) {
            request.setAttribute("jobId", jobId);
        }

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
