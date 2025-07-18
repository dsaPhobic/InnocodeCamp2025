package service;

import model.Skill;
import java.util.*;

public class NLPService {
    public static List<Skill> extractSkills(String fullText) throws Exception {
        List<Skill> gptSkills = LLMService.callGptWithPrompt(buildPrompt(fullText));

        List<Skill> scoredSkills = new ArrayList<>();
        for (Skill skill : gptSkills) {
            String name = skill.getSkillName();
            int gptScore = skill.getScore();
            int freqScore = countFrequency(fullText, name);       // f2
            int positionScore = estimatePositionScore(fullText, name); // f3

            int finalScore = computeScore(gptScore, freqScore, positionScore); // main formula
            scoredSkills.add(new Skill(name, finalScore));
        }

        return scoredSkills;
    }

    private static String buildPrompt(String text) {
        return "Từ đoạn mô tả sau, hãy trích xuất các kỹ năng và đánh giá mức độ phù hợp từ 1 đến 100.\n"
             + "Trả về JSON theo định dạng:\n"
             + "[{\"skill\": \"Java\", \"score\": 90}, {\"skill\": \"Spring Boot\", \"score\": 80}]\n\n"
             + "Đoạn văn:\n" + text;
    }

    private static int computeScore(int gptScore, int freqScore, int positionScore) {
        double finalScore = gptScore * 0.5 + freqScore * 0.3 + positionScore * 0.2;
        return (int) Math.round(finalScore);
    }

    private static int countFrequency(String text, String keyword) {
        String[] parts = text.toLowerCase().split("\\b" + keyword.toLowerCase() + "\\b");
        int count = parts.length - 1;
        return Math.min(count * 20, 100); 
    }

    private static int estimatePositionScore(String text, String skill) {
        String lower = text.toLowerCase();
        if (lower.contains("skills") && lower.indexOf(skill.toLowerCase()) < 300) {
            return 100;
        }
        return 60; 
    }
}
