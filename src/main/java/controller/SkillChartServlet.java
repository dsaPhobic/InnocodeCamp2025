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
import dao.SkillDAO;
import model.Skill;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author hmqua
 */
@WebServlet(name = "SkillChartServlet", urlPatterns = {"/SkillChartServlet"})
public class SkillChartServlet extends HttpServlet {

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
            out.println("<title>Servlet SkillChartServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SkillChartServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession(false);
        System.out.println("[SkillChartServlet] Session ID: " + (session != null ? session.getId() : "null"));
        System.out.println("[SkillChartServlet] Session user: " + (session != null ? session.getAttribute("user") : "null"));
        model.User user = (session != null) ? (model.User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect("view/login.jsp");
            return;
        }
        int userId = user.getId();
        System.out.println("[SkillChartServlet] userId: " + userId);
        SkillDAO skillDAO = new SkillDAO();
        List<Skill> skills = skillDAO.getSkillsByUser(userId);
        System.out.println("[SkillChartServlet] Skills count: " + (skills != null ? skills.size() : 0));
        if (skills != null) {
            for (Skill s : skills) {
                System.out.println("Skill: " + s.getSkillName() + " - " + s.getScore());
            }
        }
        request.setAttribute("skills", skills);
        RequestDispatcher rd = request.getRequestDispatcher("view/skillChart.jsp");
        rd.forward(request, response);
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
        processRequest(request, response);
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
