package controller;

import com.google.gson.Gson;
import com.theokanning.openai.completion.chat.ChatMessage;
import model.Message;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.util.*;
import service.LLMService;

@WebServlet("/ChatbotServlet")
@MultipartConfig(
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 12 * 1024 * 1024
)
public class ChatbotServlet extends HttpServlet {

   

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        // Lưu cho giao diện
        List<Message> chatHistory = (List<Message>) session.getAttribute("chatHistory");
        if (chatHistory == null) {
            chatHistory = new ArrayList<>();
        }

        // Lưu cho LLM memory
        List<ChatMessage> chatMemory = (List<ChatMessage>) session.getAttribute("chatMemory");
        if (chatMemory == null) {
            chatMemory = new ArrayList<>();
        }

       

        String userMessage = request.getParameter("message");
        String base64Image = null;

        try {
            Part imagePart = request.getPart("imageFile");
            if (imagePart != null && imagePart.getSize() > 0) {
                try (InputStream is = imagePart.getInputStream()) {
                    byte[] imageBytes = is.readAllBytes();
                    base64Image = Base64.getEncoder().encodeToString(imageBytes);
                }
            }
        } catch (Exception ex) {
            // Ignore image errors
        }

        // Nếu không có file upload, thử lấy từ prefillImageBase64
        if (base64Image == null || base64Image.isEmpty()) {
            String prefillImageBase64 = request.getParameter("prefillImageBase64");
            if (prefillImageBase64 != null && !prefillImageBase64.isEmpty()) {
                base64Image = prefillImageBase64;
            }
        }

        boolean hasText = userMessage != null && !userMessage.trim().isEmpty();
        boolean hasImage = base64Image != null;

        if (hasText || hasImage) {
            chatHistory.add(new Message("user", userMessage, base64Image));

            String userMemoryContent = "";
            if (hasText) {
                userMemoryContent = userMessage.trim();
            }
            if (hasImage) {
                userMemoryContent += userMemoryContent.isEmpty() ? "[Image attached]" : " [Image attached]";
            }
            chatMemory.add(new ChatMessage("user", userMemoryContent));

            // Changed here: use chatHistory for LLM.getResponse to support images
            String llmResponse = LLMService.getResponse(chatHistory);

            chatHistory.add(new Message("assistant", llmResponse));
            chatMemory.add(new ChatMessage("assistant", llmResponse));
        }

        session.setAttribute("chatHistory", chatHistory);
        session.setAttribute("chatMemory", chatMemory);

        String fromPage = request.getParameter("fromPage");
        String ajax = request.getParameter("ajax");

        if ("1".equals(ajax)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            Map<String, Object> result = new HashMap<>();
            result.put("chatHistory", chatHistory);

            response.getWriter().write(new Gson().toJson(result));
        } else {
            if ("chat1.jsp".equals(fromPage) || "chat2.jsp".equals(fromPage)) {
                response.sendRedirect(fromPage);
            } else {
                response.sendRedirect("chat1.jsp");
            }
        }
    }
}