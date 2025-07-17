package service;

import model.Message;
import com.theokanning.openai.completion.chat.ChatMessage;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.List;
import java.util.ArrayList;

public class LLM {
    private static final String API_KEY = "open ai api key";
    private static final String ENDPOINT = "https://api.openai.com/v1/chat/completions";

    /**
     * Gọi GPT-4o với danh sách message (text/image).
     */
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
