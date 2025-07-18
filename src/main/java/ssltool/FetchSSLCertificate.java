package ssltool;

import javax.net.ssl.*;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.security.cert.X509Certificate;

public class FetchSSLCertificate {

    public static void main(String[] args) {
        try {
            String host = "smtp.gmail.com";
            int port = 465;

            // ⚠️ Tạm bỏ qua xác minh chứng chỉ để có thể bắt tay TLS
            TrustManager[] trustAll = new TrustManager[]{
                new X509TrustManager() {
                    public X509Certificate[] getAcceptedIssuers() { return null; }
                    public void checkClientTrusted(X509Certificate[] certs, String authType) {}
                    public void checkServerTrusted(X509Certificate[] certs, String authType) {}
                }
            };

            SSLContext context = SSLContext.getInstance("TLS");
            context.init(null, trustAll, new java.security.SecureRandom());
            SSLSocketFactory factory = context.getSocketFactory();

            System.out.println("⏳ Đang kết nối đến " + host + ":" + port + " để lấy chứng chỉ...");
            try (SSLSocket socket = (SSLSocket) factory.createSocket(host, port)) {
                socket.startHandshake();
                SSLSession session = socket.getSession();
                X509Certificate cert = (X509Certificate) session.getPeerCertificates()[0];

                try (OutputStream os = new FileOutputStream("gmail.crt")) {
                    os.write("-----BEGIN CERTIFICATE-----\n".getBytes());
                    os.write(java.util.Base64.getMimeEncoder(64, new byte[]{'\n'}).encode(cert.getEncoded()));
                    os.write("\n-----END CERTIFICATE-----\n".getBytes());
                    System.out.println("✅ Đã lưu chứng chỉ vào file gmail.crt");
                }
            }

        } catch (Exception e) {
            System.err.println("❌ Lỗi khi lấy chứng chỉ:");
            e.printStackTrace();
        }
    }
}
