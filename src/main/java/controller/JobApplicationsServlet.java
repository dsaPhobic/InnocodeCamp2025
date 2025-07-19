// File: src/main/java/controller/JobApplicationsServlet.java
package controller;

import dao.JobApplicationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.JobApplication;
import model.User;

@WebServlet(name = "JobApplicationsServlet", urlPatterns = {"/JobApplicationsServlet"})
public class JobApplicationsServlet extends HttpServlet {
    private JobApplicationDAO applicationDAO;
    @Override
    public void init() throws ServletException {
        applicationDAO = new JobApplicationDAO();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("view/login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");
        int userId = user.getId();
        List<JobApplication> applications = applicationDAO.getApplicationsByUser(userId);
        request.setAttribute("applications", applications);
        request.getRequestDispatcher("view/jobApplications.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 