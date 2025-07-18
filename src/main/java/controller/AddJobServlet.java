/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Job;
import dao.JobDAO;

/**
 *
 * @author hmqua
 */
@WebServlet(name = "AddJobServlet", urlPatterns = {"/AddJobServlet"})
public class AddJobServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddJobServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddJobServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String title = request.getParameter("title");
        String company = request.getParameter("company");
        String location = request.getParameter("location");
        String environment = request.getParameter("environment");
        String skillRequired = request.getParameter("skill_required");
        String cultureTags = request.getParameter("culture_tags");
        String description = request.getParameter("description");
        String recruiterEmail = request.getParameter("recruiter_email");
        String status = request.getParameter("status");
        String postedAtStr = request.getParameter("posted_at");
        java.util.Date postedAt = null;
        if (postedAtStr != null && !postedAtStr.isEmpty()) {
            try { postedAt = java.sql.Timestamp.valueOf(postedAtStr + ":00"); } catch (Exception ex) { postedAt = new java.util.Date(); }
        } else {
            postedAt = new java.util.Date();
        }
        String salaryStr = request.getParameter("salary");
        float salary = 0;
        try { salary = Float.parseFloat(salaryStr); } catch (Exception ex) {}
        String experience = request.getParameter("experience");
        Job job = new Job(0, title, company, location, environment, skillRequired, cultureTags, description, recruiterEmail, status, postedAt, salary, experience);
        try {
            JobDAO dao = new JobDAO();
            dao.addJob(job);
            response.sendRedirect("ViewJobsServlet");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi khi thêm công việc: " + e.getMessage());
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
