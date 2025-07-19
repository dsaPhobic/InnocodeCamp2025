package controller;

import dao.UserDAO;
import service.EmailUtil;
import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final int TOKEN_LENGTH = 32;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect to forgot password page
        response.sendRedirect(request.getContextPath() + "/view/forgot-password.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        
        // Validate email
        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/view/forgot-password.jsp?error=" + 
                               java.net.URLEncoder.encode("Email is required", "UTF-8"));
            return;
        }
        
        if (!EmailUtil.isValidEmail(email)) {
            response.sendRedirect(request.getContextPath() + "/view/forgot-password.jsp?error=" + 
                               java.net.URLEncoder.encode("Please enter a valid email address", "UTF-8") + 
                               "&email=" + java.net.URLEncoder.encode(email, "UTF-8"));
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        
        // Check if user exists
        if (userDAO.findByEmail(email) == null) {
            // Don't reveal if email exists or not for security
            response.sendRedirect(request.getContextPath() + "/view/forgot-password.jsp?success=" + 
                               java.net.URLEncoder.encode("If an account with this email exists, a password reset link has been sent.", "UTF-8"));
            return;
        }
        
        // Generate reset token
        String token = generateResetToken();
        
        // Save token to database
        if (userDAO.saveResetToken(email, token)) {
            // Create reset link
            String resetLink = request.getScheme() + "://" + request.getServerName() + 
                             ":" + request.getServerPort() + 
                             request.getContextPath() + "/view/reset-password.jsp?token=" + token;
            
            // Send email
            EmailUtil.sendPasswordResetEmail(email, resetLink);
            
            response.sendRedirect(request.getContextPath() + "/view/forgot-password.jsp?success=" + 
                               java.net.URLEncoder.encode("If an account with this email exists, a password reset link has been sent.", "UTF-8"));
        } else {
            response.sendRedirect(request.getContextPath() + "/view/forgot-password.jsp?error=" + 
                               java.net.URLEncoder.encode("An error occurred. Please try again later.", "UTF-8") + 
                               "&email=" + java.net.URLEncoder.encode(email, "UTF-8"));
        }
    }
    
    private String generateResetToken() {
        byte[] tokenBytes = new byte[TOKEN_LENGTH];
        RANDOM.nextBytes(tokenBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(tokenBytes);
    }
} 