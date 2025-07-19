package controller;

import dao.JobDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import model.Job;
import model.User;
import com.google.gson.Gson;

@WebServlet("/JobListServlet")
public class JobListServlet extends HttpServlet {
    
    private JobDAO jobDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        jobDAO = new JobDAO();
        gson = new Gson();
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
        
        String action = request.getParameter("action");
        
        if ("getJobs".equals(action)) {
            try {
                // Lấy danh sách tất cả công việc
                List<Job> jobs = jobDAO.getAllJobs();
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                // Trả về array rỗng nếu không có jobs
                if (jobs == null) {
                    jobs = new ArrayList<>();
                }
                
                response.getWriter().write(gson.toJson(jobs));
                response.getWriter().flush();
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"error\": \"Không thể lấy danh sách công việc: " + e.getMessage() + "\"}");
            }
        } else {
            // Chuyển đến trang chọn công việc phỏng vấn
            request.getRequestDispatcher("view/jobInterviewSelection.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 