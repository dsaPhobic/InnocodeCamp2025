package controller;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String token = request.getParameter("token");
        
        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Invalid reset link");
            request.getRequestDispatcher("/view/reset-password.jsp").forward(request, response);
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        
        // Check if token is valid
        if (!userDAO.isTokenValid(token)) {
            request.setAttribute("error", "Invalid or expired reset link. Please request a new password reset.");
            request.getRequestDispatcher("/view/reset-password.jsp").forward(request, response);
            return;
        }
        
        // Token is valid, show reset form
        request.setAttribute("token", token);
        request.getRequestDispatcher("/view/reset-password.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate inputs
        if (token == null || token.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/view/reset-password.jsp?error=" + 
                               java.net.URLEncoder.encode("Invalid reset link", "UTF-8"));
            return;
        }
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/view/reset-password.jsp?error=" + 
                               java.net.URLEncoder.encode("New password is required", "UTF-8") + 
                               "&token=" + java.net.URLEncoder.encode(token, "UTF-8"));
            return;
        }
        
        if (newPassword.length() < 8) {
            response.sendRedirect(request.getContextPath() + "/view/reset-password.jsp?error=" + 
                               java.net.URLEncoder.encode("Password must be at least 8 characters long", "UTF-8") + 
                               "&token=" + java.net.URLEncoder.encode(token, "UTF-8"));
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/view/reset-password.jsp?error=" + 
                               java.net.URLEncoder.encode("Passwords do not match", "UTF-8") + 
                               "&token=" + java.net.URLEncoder.encode(token, "UTF-8"));
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        
        // Check if token is still valid
        if (!userDAO.isTokenValid(token)) {
            response.sendRedirect(request.getContextPath() + "/view/reset-password.jsp?error=" + 
                               java.net.URLEncoder.encode("Invalid or expired reset link. Please request a new password reset.", "UTF-8"));
            return;
        }
        
        // Update password
        if (userDAO.updatePasswordByToken(token, newPassword)) {
            response.sendRedirect(request.getContextPath() + "/view/reset-password.jsp?success=" + 
                               java.net.URLEncoder.encode("Password has been reset successfully. You can now login with your new password.", "UTF-8"));
            // Redirect to login page after a short delay
            response.setHeader("Refresh", "3;URL=" + request.getContextPath() + "/view/login.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/view/reset-password.jsp?error=" + 
                               java.net.URLEncoder.encode("Failed to reset password. Please try again.", "UTF-8") + 
                               "&token=" + java.net.URLEncoder.encode(token, "UTF-8"));
        }
    }
} 