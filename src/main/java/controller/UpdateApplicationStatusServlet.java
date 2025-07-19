package controller;

import dao.JobApplicationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;

@WebServlet(name = "UpdateApplicationStatusServlet", urlPatterns = {"/UpdateApplicationStatusServlet"})
public class UpdateApplicationStatusServlet extends HttpServlet {
    private JobApplicationDAO applicationDAO;
    
    @Override
    public void init() throws ServletException {
        applicationDAO = new JobApplicationDAO();
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
        String jobIdStr = request.getParameter("jobId");
        String newStatus = request.getParameter("status");
        
        if (jobIdStr == null || jobIdStr.trim().isEmpty() || 
            newStatus == null || newStatus.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Job ID and status are required");
            return;
        }
        
        // Validate status
        String[] validStatuses = {"Applied", "Pending", "Accepted", "Rejected"};
        boolean validStatus = false;
        for (String status : validStatuses) {
            if (status.equals(newStatus)) {
                validStatus = true;
                break;
            }
        }
        
        if (!validStatus) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid status");
            return;
        }
        
        try {
            int jobId = Integer.parseInt(jobIdStr);
            int userId = user.getId();
            
            // Cập nhật status
            boolean success = applicationDAO.updateApplicationStatus(userId, jobId, newStatus);
            
            if (success) {
                response.getWriter().write("success");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Application not found or cannot be updated");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Job ID format");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error occurred");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
} 