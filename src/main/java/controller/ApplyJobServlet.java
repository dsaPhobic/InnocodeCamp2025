package controller;

import dao.JobApplicationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import model.JobApplication;
import model.User;
import model.Job;
import service.MailService;

@WebServlet(name = "ApplyJobServlet", urlPatterns = {"/ApplyJobServlet"})
public class ApplyJobServlet extends HttpServlet {

    private JobApplicationDAO applicationDAO;

    @Override
    public void init() throws ServletException {
        applicationDAO = new JobApplicationDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("view/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        int userId = currentUser.getId();
        String jobIdStr = request.getParameter("jobId");

        if (jobIdStr == null) {
            response.getWriter().write("invalid");
            return;
        }

        int jobId = Integer.parseInt(jobIdStr);
        boolean success = applicationDAO.addApplication(userId, jobId);

        if (success) {
            // Gửi mail bất đồng bộ
            List<JobApplication> applications = applicationDAO.getApplicationsByUser(userId);

            for (JobApplication app : applications) {
                if (app.getJobId() == jobId) {
                    Job job = app.getJob();
                    String recruiterEmail = job.getRecruiterEmail();
                    String jobTitle = job.getTitle();
                    String subject = "Ứng viên mới cho vị trí: " + jobTitle;
                    String content = "Ứng viên " + currentUser.getFullname()
                            + " đã ứng tuyển công việc \"" + jobTitle + "\".";

                    // Thêm log trước khi gửi mail
                    System.out.println("===> Đang gửi mail tới: " + recruiterEmail);
                    System.out.println("===> Tiêu đề: " + subject);
                    System.out.println("===> Nội dung: " + content);

                    new Thread(() -> {
                        try {
                            MailService.sendEmail(recruiterEmail, subject, content);
                            System.out.println("===> Gửi mail thành công tới: " + recruiterEmail);
                        } catch (Exception e) {
                            System.err.println("===> Lỗi gửi mail:");
                            e.printStackTrace();
                        }
                    }).start();

                    break;
                }
            }

            // Gửi phản hồi (hỗ trợ AJAX hoặc redirect đều được)
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                // AJAX call
                response.setContentType("text/plain");
                response.getWriter().write("success");
            } else {
                // Form bình thường
                request.setAttribute("applications", applications);
                request.setAttribute("message", "✅ Ứng tuyển thành công!");
                request.getRequestDispatcher("view/jobApplications.jsp").forward(request, response);
            }
        } else {
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("text/plain");
                response.getWriter().write("duplicate");
            } else {
                request.setAttribute("recommendations", new dao.RecommendationDAO().generateRecommendationsForUser(userId));
                request.setAttribute("message", "⚠️ Bạn đã ứng tuyển công việc này trước đó.");
                request.getRequestDispatcher("view/jobSuggestions.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý Apply Job và gửi mail tới recruiter";
    }
}
