package controller;

import dao.JobApplicationDAO;
import service.MailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.JobApplication;
import model.User;

@WebServlet(name = "ApplicationNotificationServlet", urlPatterns = {"/ApplicationNotificationServlet"})
public class ApplicationNotificationServlet extends HttpServlet {
    private JobApplicationDAO applicationDAO;
    private MailService mailService;
    
    @Override
    public void init() throws ServletException {
        applicationDAO = new JobApplicationDAO();
        mailService = new MailService();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        
        if ("sendReminder".equals(action)) {
            sendApplicationReminders(user);
            response.getWriter().write("success");
        } else if ("sendStatusUpdate".equals(action)) {
            String jobIdStr = request.getParameter("jobId");
            String status = request.getParameter("status");
            
            if (jobIdStr != null && status != null) {
                try {
                    int jobId = Integer.parseInt(jobIdStr);
                    sendStatusUpdateEmail(user, jobId, status);
                    response.getWriter().write("success");
                } catch (NumberFormatException e) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Job ID");
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    private void sendApplicationReminders(User user) {
        try {
            List<JobApplication> applications = applicationDAO.getApplicationsByUser(user.getId());
            
            if (!applications.isEmpty()) {
                StringBuilder emailContent = new StringBuilder();
                emailContent.append("<h2>Your Job Applications Summary</h2>");
                emailContent.append("<p>Hello ").append(user.getFullname()).append(",</p>");
                emailContent.append("<p>Here's a summary of your recent job applications:</p>");
                emailContent.append("<table border='1' style='border-collapse: collapse; width: 100%;'>");
                emailContent.append("<tr><th>Job Title</th><th>Company</th><th>Status</th><th>Applied Date</th></tr>");
                
                for (JobApplication app : applications) {
                    emailContent.append("<tr>");
                    emailContent.append("<td>").append(app.getJob().getTitle()).append("</td>");
                    emailContent.append("<td>").append(app.getJob().getCompany()).append("</td>");
                    emailContent.append("<td>").append(app.getStatus()).append("</td>");
                    emailContent.append("<td>").append(app.getAppliedAt()).append("</td>");
                    emailContent.append("</tr>");
                }
                
                emailContent.append("</table>");
                emailContent.append("<p>Keep track of your applications and follow up when necessary!</p>");
                
                mailService.sendEmail(user.getEmail(), "Your Job Applications Summary", emailContent.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void sendStatusUpdateEmail(User user, int jobId, String status) {
        try {
            List<JobApplication> applications = applicationDAO.getApplicationsByUser(user.getId());
            
            for (JobApplication app : applications) {
                if (app.getJobId() == jobId) {
                    String subject = "Application Status Update - " + app.getJob().getTitle();
                    StringBuilder emailContent = new StringBuilder();
                    emailContent.append("<h2>Application Status Update</h2>");
                    emailContent.append("<p>Hello ").append(user.getFullname()).append(",</p>");
                    emailContent.append("<p>Your application status has been updated:</p>");
                    emailContent.append("<ul>");
                    emailContent.append("<li><strong>Job:</strong> ").append(app.getJob().getTitle()).append("</li>");
                    emailContent.append("<li><strong>Company:</strong> ").append(app.getJob().getCompany()).append("</li>");
                    emailContent.append("<li><strong>New Status:</strong> ").append(status).append("</li>");
                    emailContent.append("</ul>");
                    
                    if ("Accepted".equals(status)) {
                        emailContent.append("<p style='color: green;'><strong>🎉 Congratulations!</strong> Your application has been accepted!</p>");
                    } else if ("Rejected".equals(status)) {
                        emailContent.append("<p style='color: orange;'>Don't worry, there are many other opportunities out there!</p>");
                    }
                    
                    mailService.sendEmail(user.getEmail(), subject, emailContent.toString());
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
} 