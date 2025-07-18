package controller;

import dao.JobDAO;
import dao.SkillDAO;
import model.Skill;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;

@WebServlet(name = "HomeServlet", urlPatterns = {"/HomeServlet"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[HomeServlet] ▶️ Bắt đầu xử lý doGet");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("[HomeServlet] ❌ Chưa đăng nhập, chuyển hướng về login.jsp");
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        System.out.println("[HomeServlet] ✅ Đã đăng nhập, user ID: " + user.getId());

        SkillDAO skillDAO = new SkillDAO();
        List<Skill> topSkills = skillDAO.getTopSkillsByUser(user.getId(), 4);

        if (topSkills == null) {
            System.out.println("[HomeServlet] ⚠️ topSkills == null");
        } else if (topSkills.isEmpty()) {
            System.out.println("[HomeServlet] ⚠️ topSkills rỗng");
        } else {
            System.out.println("[HomeServlet] ✅ Đã lấy " + topSkills.size() + " kỹ năng:");
            for (Skill skill : topSkills) {
                System.out.println("   - " + skill.getSkillName() + ": " + skill.getScore());
            }
        }

        request.setAttribute("userSkills", topSkills);
        System.out.println("[HomeServlet] ✅ Forward đến view/home.jsp");
        request.getRequestDispatcher("view/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Home page controller showing dashboard with user stats and skills";
    }
}
