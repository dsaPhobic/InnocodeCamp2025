package controller;

import dao.InterviewDAO;
import model.Interview;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/InterviewHistoryServlet")
public class InterviewHistoryServlet extends HttpServlet {
    
    private InterviewDAO interviewDAO;
    
    @Override
    public void init() throws ServletException {
        interviewDAO = new InterviewDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            // Handle delete action
            try {
                int interviewId = Integer.parseInt(request.getParameter("id"));
                boolean deleted = interviewDAO.deleteInterviewById(interviewId);
                
                if (deleted) {
                    response.setStatus(HttpServletResponse.SC_OK);
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
            return;
        }
        
        // Get interview history for the user
        List<Interview> interviews = interviewDAO.getInterviewsByUserId(user.getId());
        
        // Clean up empty interviews from database
        interviewDAO.deleteEmptyInterviews();
        
        // Filter out empty interviews (those without user answers or meaningful data)
        List<Interview> filteredInterviews = new ArrayList<>();
        for (Interview interview : interviews) {
            // Only include interviews that have user answers or are in progress
            if (interview.getStatus().equals("in_progress") || 
                (interview.getUserAnswer() != null && !interview.getUserAnswer().trim().isEmpty())) {
                filteredInterviews.add(interview);
            }
        }
        
        request.setAttribute("interviews", filteredInterviews);
        
        // Forward to history page
        request.getRequestDispatcher("/view/interviewHistory.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 