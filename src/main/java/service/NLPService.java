package service;

import model.Skill;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class NLPService {

    public static List<Skill> extractSkills(String fullText) throws Exception {
        String gptResponse = LLMService.callChatGPT(buildPrompt(fullText));
        System.out.println("[DEBUG] GPT raw content:\n" + gptResponse);

        // 👉 Tìm mảng JSON trong chuỗi trả về
        int startIdx = gptResponse.indexOf("[");
        int endIdx = gptResponse.lastIndexOf("]");
        if (startIdx == -1 || endIdx == -1 || endIdx <= startIdx) {
            throw new Exception("GPT không trả về định dạng JSON hợp lệ:\n" + gptResponse);
        }

        String jsonArrayStr = gptResponse.substring(startIdx, endIdx + 1);
        JSONArray jsonArray = new JSONArray(jsonArrayStr);
        List<Skill> scoredSkills = new ArrayList<>();

        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject obj = jsonArray.getJSONObject(i);
            String name = obj.getString("skill");
            int gptScore = obj.getInt("score");

            int freqScore = countFrequency(fullText, name);
            int positionScore = estimatePositionScore(fullText, name);
            int finalScore = computeScore(gptScore, freqScore, positionScore);

            // 🔍 Log từng kỹ năng
            System.out.printf("[NLPService] Skill: %-15s | GPT: %3d | Freq: %3d | Pos: %3d | Final: %3d%n",
                    name, gptScore, freqScore, positionScore, finalScore);

            scoredSkills.add(new Skill(name, finalScore));
        }

        return scoredSkills;
    }

    private static String buildPrompt(String text) {
        return "You are a strict JSON generator.\n"
                + "From the following resume content, extract a list of actual technical skills mentioned in the text, each with a relevance score from 1 to 100.\n"
                + "Return only a JSON array like this:\n"
                + "[{\"skill\": \"example_skill\", \"score\": 80}]\n\n"
                + "CV content:\n" + text;
    }

    // ⚠️ Đã điều chỉnh trọng số ưu tiên GPT hơn
    private static int computeScore(int gptScore, int freqScore, int positionScore) {
        double finalScore = gptScore * 0.7 + freqScore * 0.2 + positionScore * 0.1;
        return (int) Math.round(finalScore);
    }

    // ⚠️ Điều chỉnh tăng trọng số mỗi lần xuất hiện
    private static int countFrequency(String text, String keyword) {
        String[] parts = text.toLowerCase().split("\\b" + keyword.toLowerCase() + "\\b");
        int count = parts.length - 1;
        return Math.min(count * 35, 100); // mỗi lần +35
    }

    // ⚠️ Làm mượt vị trí xuất hiện
    private static int estimatePositionScore(String text, String skill) {
        String lower = text.toLowerCase();
        int index = lower.indexOf(skill.toLowerCase());

        if (index == -1) {
            return 50;
        }

        if (index < 200) {
            return 100;
        } else if (index < 500) {
            return 80;
        } else {
            return 60;
        }
    }
}
