package service;

import com.sun.mail.util.MailSSLSocketFactory;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMultipart;
import jakarta.mail.internet.MimeUtility;
import jakarta.activation.DataHandler;
import jakarta.activation.DataSource;
import jakarta.activation.FileDataSource;
import java.io.File;

import javax.net.ssl.*;
import java.security.SecureRandom;
import java.security.cert.X509Certificate;
import java.util.Properties;

public class MailService {

    // ⚠️ Bỏ qua xác thực SSL (cho môi trường test/demo)
    static {
        try {
            TrustManager[] trustAllCerts = new TrustManager[]{
                new X509TrustManager() {
                    public X509Certificate[] getAcceptedIssuers() { return null; }
                    public void checkClientTrusted(X509Certificate[] certs, String authType) {}
                    public void checkServerTrusted(X509Certificate[] certs, String authType) {}
                }
            };

            SSLContext sc = SSLContext.getInstance("TLS");
            sc.init(null, trustAllCerts, new SecureRandom());

            // Áp dụng factory và hostname verifier mặc định
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
            HttpsURLConnection.setDefaultHostnameVerifier((hostname, session) -> true);

            // Cho SMTP (port 587)
            MailSSLSocketFactory sf = new MailSSLSocketFactory();
            sf.setTrustAllHosts(true);
            System.setProperty("mail.smtp.ssl.socketFactory", sf.getClass().getName());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Cấu hình tài khoản Gmail gửi
    private static final String FROM_EMAIL = "hohieudn2005@gmail.com";
    private static final String PASSWORD = "ifnunxnimdoxappi";

    public static void sendEmail(String toEmail, String subject, String content) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // Bật STARTTLS
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        // Tạo phiên gửi có xác thực
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        // Tạo nội dung email
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setText(content);

        // Gửi email
        Transport.send(message);
    }

    public static void sendEmailWithAttachment(String toEmail, String subject, String content, File attachment) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);

        // Body text
        MimeBodyPart textPart = new MimeBodyPart();
        textPart.setText(content, "utf-8");

        // Attachment
        MimeBodyPart attachPart = new MimeBodyPart();
        DataSource source = new FileDataSource(attachment);
        attachPart.setDataHandler(new DataHandler(source));
        try {
            attachPart.setFileName(MimeUtility.encodeText(attachment.getName(), "utf-8", null));
        } catch (java.io.UnsupportedEncodingException e) {
            attachPart.setFileName(attachment.getName());
        }

        // Multipart
        MimeMultipart multipart = new MimeMultipart();
        multipart.addBodyPart(textPart);
        multipart.addBodyPart(attachPart);

        message.setContent(multipart);

        Transport.send(message);
    }

    public static void main(String[] args) {
        try {
            sendEmail("mew3dk@gmail.com", "📧 Test TLS", "✅ Gửi thành công từ Java Maven với STARTTLS!");
            System.out.println("✅ Email đã được gửi thành công!");
        } catch (Exception e) {
            System.err.println("❌ Gửi email thất bại:");
            e.printStackTrace();
        }
    }
}
