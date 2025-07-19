// File: src/main/java/controller/DeleteApplicationServlet.java
package controller;

import dao.JobApplicationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "DeleteApplicationServlet", urlPatterns = {"/DeleteApplicationServlet"})
public class DeleteApplicationServlet extends HttpServlet {
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
            response.getWriter().write("fail");
            return;
        }
        model.User user = (model.User) session.getAttribute("user");
        int userId = user.getId();
        String jobIdStr = request.getParameter("jobId");
        if (jobIdStr == null) {
            response.getWriter().write("fail");
            return;
        }
        int jobId = Integer.parseInt(jobIdStr);
        boolean ok = applicationDAO.deleteApplication(userId, jobId);
        response.setContentType("text/plain; charset=UTF-8");
        response.getWriter().write(ok ? "success" : "fail");
    }
} 