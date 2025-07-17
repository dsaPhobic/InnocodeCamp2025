package service;

import model.Skill;
import okhttp3.*;
import org.json.*;

import java.util.*;
import model.Message;
import com.theokanning.openai.completion.chat.ChatMessage;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.URI;

public class LLMService {

    private static final String API_KEY = ""; 
    private static final String ENDPOINT = "https://api.openai.com/v1/chat/completions";

    private static final OkHttpClient client = new OkHttpClient();

    // 👉 Dùng cho NLPService – phân tích kỹ năng (có JSON trả về)
    public static List<Skill> callGptWithPrompt(String prompt) throws Exception {
        String content = callChatGPT(prompt); // gọi chung

        // Parse JSON content trả về từ GPT thành List<Skill>
        JSONArray jsonArray = new JSONArray(content);
        List<Skill> skills = new ArrayList<>();

        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject obj = jsonArray.getJSONObject(i);
            String name = obj.getString("skill");
            int score = obj.getInt("score");
            skills.add(new Skill(name, score));
        }

        return skills;
    }

    // 👉 Hàm gọi GPT chung, có thể dùng trong ChatbotServlet hoặc nơi khác
    public static String callChatGPT(String prompt) throws Exception {
        JSONObject message = new JSONObject()
                .put("role", "user")
                .put("content", prompt);

        JSONObject body = new JSONObject()
                .put("model", "gpt-3.5-turbo")
                .put("messages", List.of(message))
                .put("temperature", 0.3);

        Request request = new Request.Builder()
                .url(ENDPOINT)
                .addHeader("Authorization", "Bearer " + API_KEY)
                .post(RequestBody.create(body.toString(), MediaType.parse("application/json")))
                .build();

        Response response = client.newCall(request).execute();
        if (!response.isSuccessful()) {
            throw new RuntimeException("GPT API error: " + response);
        }

        // Lấy nội dung trả về từ GPT
        return new JSONObject(response.body().string())
                .getJSONArray("choices")
                .getJSONObject(0)
                .getJSONObject("message")
                .getString("content")
                .trim();
    }

    public static String getResponse(List<Message> messages) {
        try {
            JSONObject requestBody = new JSONObject();
            requestBody.put("model", "gpt-4o");

            JSONArray jsonMessages = new JSONArray();
            for (Message msg : messages) {
                JSONObject msgObj = new JSONObject();
                msgObj.put("role", msg.getRole());

                if (msg.getBase64Image() != null && !msg.getBase64Image().isEmpty()) {
                    JSONArray contentArr = new JSONArray();
                    if (msg.getText() != null && !msg.getText().isEmpty()) {
                        JSONObject textPart = new JSONObject();
                        textPart.put("type", "text");
                        textPart.put("text", msg.getText());
                        contentArr.put(textPart);
                    }

                    JSONObject imagePart = new JSONObject();
                    imagePart.put("type", "image_url");
                    JSONObject imageObj = new JSONObject();
                    imageObj.put("url", "data:image/png;base64," + msg.getBase64Image());
                    imagePart.put("image_url", imageObj);
                    contentArr.put(imagePart);

                    msgObj.put("content", contentArr);
                } else {
                    msgObj.put("content", msg.getText() != null ? msg.getText() : "");
                }

                jsonMessages.put(msgObj);
            }

            requestBody.put("messages", jsonMessages);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(ENDPOINT))
                    .header("Authorization", "Bearer " + API_KEY)
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                    .build();

            HttpClient client = HttpClient.newHttpClient();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            JSONObject responseJson = new JSONObject(response.body());
            JSONArray choices = responseJson.getJSONArray("choices");
            JSONObject firstChoice = choices.getJSONObject(0);
            JSONObject message = firstChoice.getJSONObject("message");

            return message.getString("content").trim();
        } catch (Exception e) {
            return "[Error] " + e.getMessage();
        }
    }

    public static String getResponseFromChatMessages(List<ChatMessage> chatMessages) {
        List<Message> converted = new ArrayList<>();
        for (ChatMessage cm : chatMessages) {
            converted.add(new Message(cm.getRole(), cm.getContent()));
        }
        return getResponse(converted);
    }
}
