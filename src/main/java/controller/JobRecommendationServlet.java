package controller;

import dao.RecommendationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
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

        // Debug: Hiển thị tất cả dữ liệu jobs
        String debug = request.getParameter("debug");
        if ("true".equals(debug)) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<html><body>");
            response.getWriter().println("<h2>DEBUG: Tất cả dữ liệu Jobs</h2>");
            response.getWriter().println("<table border='1'>");
            response.getWriter().println("<tr><th>ID</th><th>Title</th><th>Company</th><th>Experience</th><th>Environment</th><th>Salary</th></tr>");
            
            // Kiểm tra session đăng nhập
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect("view/login.jsp");
                return;
            }

            // Lấy user từ session
            User currentUser = (User) session.getAttribute("user");
            int userId = currentUser.getId();

            List<JobRecommendation> allJobs = recommendationDAO.generateRecommendationsForUser(userId);
            for (JobRecommendation rec : allJobs) {
                if (rec.getJob() != null) {
                    response.getWriter().println("<tr>");
                    response.getWriter().println("<td>" + rec.getJob().getId() + "</td>");
                    response.getWriter().println("<td>" + rec.getJob().getTitle() + "</td>");
                    response.getWriter().println("<td>" + rec.getJob().getCompany() + "</td>");
                    response.getWriter().println("<td>'" + rec.getJob().getExperience() + "'</td>");
                    response.getWriter().println("<td>'" + rec.getJob().getEnvironment() + "'</td>");
                    response.getWriter().println("<td>" + rec.getJob().getSalary() + "</td>");
                    response.getWriter().println("</tr>");
                }
            }
            response.getWriter().println("</table>");
            response.getWriter().println("</body></html>");
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

        // Lọc theo kinh nghiệm (experience)
        String experience = request.getParameter("experience");
        if (experience != null && !experience.trim().isEmpty()) {
            System.out.println("=== DEBUG: Filtering by experience: " + experience + " ===");
            
            // Tạo list mới chỉ chứa jobs phù hợp
            List<JobRecommendation> filteredRecommendations = new ArrayList<>();
            
            for (JobRecommendation rec : recommendations) {
                if (rec.getJob() == null || rec.getJob().getExperience() == null) {
                    System.out.println("Job " + rec.getJob().getId() + " has no experience data");
                    continue;
                }
                
                String jobExp = rec.getJob().getExperience().toLowerCase().trim();
                System.out.println("Job " + rec.getJob().getId() + " experience: '" + jobExp + "'");
                
                boolean shouldKeep = false;
                switch (experience) {
                    case "0-1":
                        // Giữ jobs có kinh nghiệm 0-1 năm
                        shouldKeep = jobExp.contains("0") || jobExp.contains("1") || 
                                   jobExp.contains("fresher") || jobExp.contains("intern") ||
                                   jobExp.contains("mới") || jobExp.contains("junior") ||
                                   jobExp.equals("1 năm") || jobExp.equals("0 năm");
                        break;
                    case "1-3":
                        // Giữ jobs có kinh nghiệm 1-3 năm
                        shouldKeep = jobExp.contains("1") || jobExp.contains("2") || jobExp.contains("3") ||
                                   jobExp.equals("1 năm") || jobExp.equals("2 năm") || jobExp.equals("3 năm");
                        break;
                    case "3-5":
                        // Giữ jobs có kinh nghiệm 3-5 năm
                        shouldKeep = jobExp.contains("3") || jobExp.contains("4") || jobExp.contains("5") ||
                                   jobExp.equals("3 năm") || jobExp.equals("4 năm") || jobExp.equals("5 năm");
                        break;
                    case "5-7":
                        // Giữ jobs có kinh nghiệm 5-7 năm
                        shouldKeep = jobExp.contains("5") || jobExp.contains("6") || jobExp.contains("7") ||
                                   jobExp.equals("5 năm") || jobExp.equals("6 năm") || jobExp.equals("7 năm");
                        break;
                    case "7+":
                        // Giữ jobs có kinh nghiệm 7+ năm
                        shouldKeep = jobExp.contains("7") || jobExp.contains("8") || 
                                   jobExp.contains("9") || jobExp.contains("10") ||
                                   jobExp.contains("senior") || jobExp.contains("lead") ||
                                   jobExp.equals("7 năm") || jobExp.equals("8 năm") || jobExp.equals("9 năm") || jobExp.equals("10 năm");
                        break;
                    default:
                        shouldKeep = false;
                }
                
                System.out.println("Job " + rec.getJob().getId() + " should keep: " + shouldKeep);
                if (shouldKeep) {
                    filteredRecommendations.add(rec);
                }
            }
            
            // Thay thế recommendations bằng filtered list
            recommendations = filteredRecommendations;
            System.out.println("=== DEBUG: After experience filtering, " + recommendations.size() + " jobs remain ===");
        }

        // Lọc theo mức lương tối thiểu
        String minSalaryStr = request.getParameter("minSalary");
        if (minSalaryStr != null && !minSalaryStr.trim().isEmpty()) {
            try {
                double minSalary = Double.parseDouble(minSalaryStr) * 1000000; // Chuyển triệu thành VND
                recommendations.removeIf(rec -> {
                    if (rec.getJob() == null || rec.getJob().getSalary() <= 0) return true;
                    return rec.getJob().getSalary() < minSalary;
                });
            } catch (NumberFormatException e) {
                // Bỏ qua nếu không parse được số
            }
        }

        // Lọc theo mức lương tối đa
        String maxSalaryStr = request.getParameter("maxSalary");
        if (maxSalaryStr != null && !maxSalaryStr.trim().isEmpty()) {
            try {
                double maxSalary = Double.parseDouble(maxSalaryStr) * 1000000; // Chuyển triệu thành VND
                recommendations.removeIf(rec -> {
                    if (rec.getJob() == null || rec.getJob().getSalary() <= 0) return true;
                    return rec.getJob().getSalary() > maxSalary;
                });
            } catch (NumberFormatException e) {
                // Bỏ qua nếu không parse được số
            }
        }

        // Lọc theo môi trường làm việc
        String workEnvironment = request.getParameter("workEnvironment");
        if (workEnvironment != null && !workEnvironment.trim().isEmpty()) {
            System.out.println("=== DEBUG: Filtering by work environment: " + workEnvironment + " ===");
            
            // Tạo list mới chỉ chứa jobs phù hợp
            List<JobRecommendation> filteredRecommendations = new ArrayList<>();
            
            for (JobRecommendation rec : recommendations) {
                if (rec.getJob() == null || rec.getJob().getEnvironment() == null) {
                    System.out.println("Job " + rec.getJob().getId() + " has no environment data");
                    continue;
                }
                
                String jobEnvironment = rec.getJob().getEnvironment().toLowerCase();
                System.out.println("Job " + rec.getJob().getId() + " environment: '" + jobEnvironment + "'");
                
                boolean shouldKeep = false;
                switch (workEnvironment) {
                    case "Onsite":
                        // So sánh chính xác với giá trị trong database (chữ hoa đầu)
                        shouldKeep = jobEnvironment.equals("onsite") || jobEnvironment.equals("Onsite");
                        break;
                    case "Remote":
                        // So sánh chính xác với giá trị trong database (chữ hoa đầu)
                        shouldKeep = jobEnvironment.equals("remote") || jobEnvironment.equals("Remote");
                        break;
                    case "Hybrid":
                        // So sánh chính xác với giá trị trong database (chữ hoa đầu)
                        shouldKeep = jobEnvironment.equals("hybrid") || jobEnvironment.equals("Hybrid");
                        break;
                    default:
                        shouldKeep = false;
                }
                
                System.out.println("Job " + rec.getJob().getId() + " should keep: " + shouldKeep);
                if (shouldKeep) {
                    filteredRecommendations.add(rec);
                }
            }
            
            // Thay thế recommendations bằng filtered list
            recommendations = filteredRecommendations;
            System.out.println("=== DEBUG: After filtering, " + recommendations.size() + " jobs remain ===");
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
        
        // Debug: In ra tất cả environment values
        if (workEnvironment != null && !workEnvironment.trim().isEmpty()) {
            System.out.println("=== ALL ENVIRONMENT VALUES ===");
            for (JobRecommendation rec : recommendations) {
                if (rec.getJob() != null && rec.getJob().getEnvironment() != null) {
                    System.out.println("Job " + rec.getJob().getId() + ": '" + rec.getJob().getEnvironment() + "'");
                }
            }
        }

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
