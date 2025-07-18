package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import service.LocationService;

@WebServlet(name = "SettingsServlet", urlPatterns = {"/SettingsServlet"})
public class SettingServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("checkLocation".equals(action)) {
            resp.setContentType("application/json; charset=UTF-8");
            resp.setCharacterEncoding("UTF-8");
            String location = req.getParameter("location");
            boolean found = false;
            try {
                if (location != null && !location.trim().isEmpty()) {
                    service.LocationService locationService = new service.LocationService();
                    found = locationService.isAddressFound(location);
                }
                String json = "{\"found\":" + found + "}";
                resp.getWriter().write(json);
            } catch (Exception e) {
                e.printStackTrace(); // Log error
                resp.getWriter().write("{\"found\":false}");
            }
            return;
        }
        req.getRequestDispatcher("view/settings.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect("view/login.jsp");
            return;
        }
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String description = req.getParameter("description");
        String gender = req.getParameter("gender");
        String location = req.getParameter("location");
        String dateOfBirthStr = req.getParameter("dateOfBirth");
        java.sql.Date dateOfBirth = null;
        if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
            dateOfBirth = java.sql.Date.valueOf(dateOfBirthStr);
        }
        user.setFullname(fullName);
        user.setEmail(email);
        user.setPassword(password);
        user.setDescription(description);
        user.setGender(gender);
        user.setLocation(location);
        user.setDateOfBirth(dateOfBirth);
        boolean success = UserDAO.updateUser(user);
        if (success) {
            session.setAttribute("user", user);
            req.setAttribute("message", "Cập nhật thành công!");
        } else {
            req.setAttribute("message", "Cập nhật thất bại!");
        }
        req.getRequestDispatcher("view/settings.jsp").forward(req, resp);
    }
} 