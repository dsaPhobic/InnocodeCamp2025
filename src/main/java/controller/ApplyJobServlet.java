package controller;

import dao.JobApplicationDAO;
import dao.SkillDAO;
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
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.io.File;

@WebServlet(name = "ApplyJobServlet", urlPatterns = {"/ApplyJobServlet"})
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)
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

        System.out.println("[ApplyJobServlet] ▶️ Bắt đầu xử lý apply cho jobId=" + jobIdStr);

        if (jobIdStr == null) {
            System.out.println("[ApplyJobServlet] ❌ jobIdStr null");
            response.getWriter().write("invalid");
            return;
        }

        int jobId = Integer.parseInt(jobIdStr);
        boolean success = applicationDAO.addApplication(userId, jobId);
        System.out.println("[ApplyJobServlet] addApplication result: " + success);

        if (success) {
            // Nhận coverLetter và file PDF (nếu có)
            String coverLetter = request.getParameter("coverLetter");
            System.out.println("[ApplyJobServlet] coverLetter: " + (coverLetter != null ? coverLetter.substring(0, Math.min(coverLetter.length(), 100)) : "null"));
            Part cvPart = null;
            File tempFile = null;
            try {
                cvPart = request.getPart("cvFile");
                System.out.println("[ApplyJobServlet] cvPart: " + (cvPart != null ? cvPart.getSubmittedFileName() : "null"));
                if (cvPart != null && cvPart.getSize() > 0) {
                    String fileName = java.nio.file.Paths.get(cvPart.getSubmittedFileName()).getFileName().toString();
                    String ext = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
                    System.out.println("[ApplyJobServlet] fileName: " + fileName + ", ext: " + ext);
                    if (!"pdf".equals(ext)) {
                        System.out.println("[ApplyJobServlet] ❌ File không phải PDF");
                        response.getWriter().write("invalid");
                        return;
                    }
                    tempFile = File.createTempFile("cv_", ".pdf");
                    cvPart.write(tempFile.getAbsolutePath());
                    System.out.println("[ApplyJobServlet] Đã lưu file tạm: " + tempFile.getAbsolutePath());
                }
            } catch (Exception ex) {
                System.out.println("[ApplyJobServlet] ❌ Lỗi khi nhận file PDF");
                ex.printStackTrace();
            }

            List<JobApplication> applications = applicationDAO.getApplicationsByUser(userId);
            for (JobApplication app : applications) {
                if (app.getJobId() == jobId) {
                    Job job = app.getJob();
                    String recruiterEmail = job.getRecruiterEmail();
                    String jobTitle = job.getTitle();
                    String companyName = job.getCompany();
                    String subject = "Ứng tuyển vị trí " + jobTitle + " tại " + companyName;

                    String content = (coverLetter != null && !coverLetter.trim().isEmpty()) ? coverLetter :
                        ("Kính gửi Anh/Chị,\n\n"
                        + "Tôi tên là " + currentUser.getFullname() + ", hiện tại tôi đang quan tâm và mong muốn ứng tuyển vào vị trí " + jobTitle + " tại " + companyName + ".\n"
                        + "Tôi đã đính kèm CV để Anh/Chị tham khảo thêm về quá trình học tập và làm việc của mình. Rất mong có cơ hội được trao đổi thêm với Anh/Chị về vị trí này.\n\n"
                        + "Xin cảm ơn Anh/Chị đã dành thời gian xem xét hồ sơ của tôi.\n"
                        + "Trân trọng,\n"
                        + currentUser.getFullname() + "\n")
                        + (currentUser.getEmail() != null ? currentUser.getEmail() + "\n" : "")
                        + (currentUser.getDescription() != null ? currentUser.getDescription() + "\n" : "");

                    System.out.println("[ApplyJobServlet] Gửi mail tới: " + recruiterEmail + ", subject: " + subject);
                    File finalFile = tempFile;
                    new Thread(() -> {
                        try {
                            if (finalFile != null && finalFile.exists()) {
                                System.out.println("[ApplyJobServlet] Đính kèm file: " + finalFile.getAbsolutePath());
                                service.MailService.sendEmailWithAttachment(recruiterEmail, subject, content, finalFile);
                                finalFile.delete();
                            } else {
                                service.MailService.sendEmail(recruiterEmail, subject, content);
                            }
                            System.out.println("[ApplyJobServlet] Đã gửi mail thành công!");
                        } catch (Exception e) {
                            System.out.println("[ApplyJobServlet] ❌ Lỗi gửi mail:");
                            e.printStackTrace();
                        }
                    }).start();
                    break;
                }
            }

            // Gửi phản hồi (hỗ trợ AJAX hoặc redirect đều được)
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("text/plain; charset=UTF-8");
                response.getWriter().write("success");
                response.getWriter().flush();
                return;
            } else {
                // Form bình thường
                request.setAttribute("applications", applications);
                request.setAttribute("message", "✅ Ứng tuyển thành công!");
                request.getRequestDispatcher("view/jobApplications.jsp").forward(request, response);
                return;
            }
        } else {
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("text/plain; charset=UTF-8");
                response.getWriter().write("duplicate");
                response.getWriter().flush();
                return;
            } else {
                request.setAttribute("recommendations", new dao.RecommendationDAO().generateRecommendationsForUser(userId));
                request.setAttribute("message", "⚠️ Bạn đã ứng tuyển công việc này trước đó.");
                request.getRequestDispatcher("view/jobSuggestions.jsp").forward(request, response);
                return;
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
