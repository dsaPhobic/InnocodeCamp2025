package service;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.logging.Logger;
import java.util.logging.Level;

public class EmailUtil {
    private static final Logger LOGGER = Logger.getLogger(EmailUtil.class.getName());
    
    // Email configuration - you can modify these values
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String FROM_EMAIL = "nhatquang1223@gmail.com"; // Change this
    private static final String FROM_PASSWORD = "mavk mlax jmbf wbdh"; // Change this
    
    // Set to true to actually send emails, false to just log to console
    private static final boolean SEND_REAL_EMAIL = true;
    
    public static void sendPasswordResetEmail(String toEmail, String resetLink) {
        String subject = "Password Reset Request";
        String body = createPasswordResetEmailBody(resetLink);
        
        if (SEND_REAL_EMAIL) {
            sendRealEmail(toEmail, subject, body);
        } else {
            logEmailToConsole(toEmail, subject, body);
        }
    }
    
    private static String createPasswordResetEmailBody(String resetLink) {
        return "Hello,\n\n" +
               "You have requested to reset your password.\n\n" +
               "Please click the following link to reset your password:\n" +
               resetLink + "\n\n" +
               "This link will expire in 1 hour.\n\n" +
               "If you did not request this password reset, please ignore this email.\n\n" +
               "Best regards,\n" +
               "Your Application Team";
    }
    
    private static void sendRealEmail(String toEmail, String subject, String body) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
                }
            });
            
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(body);
            
            Transport.send(message);
            LOGGER.info("Password reset email sent successfully to: " + toEmail);
            
        } catch (MessagingException e) {
            LOGGER.log(Level.SEVERE, "Failed to send email to: " + toEmail, e);
            // Fallback to console logging
            logEmailToConsole(toEmail, subject, body);
        }
    }
    
    private static void logEmailToConsole(String toEmail, String subject, String body) {
        System.out.println("=== EMAIL SENT (Console Log) ===");
        System.out.println("To: " + toEmail);
        System.out.println("Subject: " + subject);
        System.out.println("Body:");
        System.out.println(body);
        System.out.println("=== END EMAIL ===");
        LOGGER.info("Password reset email logged to console for: " + toEmail);
    }
    
    // Method to validate email format
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        
        // Simple email validation
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        return email.matches(emailRegex);
    }
} 