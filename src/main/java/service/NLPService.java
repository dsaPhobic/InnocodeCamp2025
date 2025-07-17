/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;



import model.Skill;
import java.util.*;

public class NLPService {
    private static final List<String> KNOWN_SKILLS = Arrays.asList(
        "Java", "Python", "SQL", "Spring", "React", "Docker", "HTML", "CSS"
    );

    public static List<Skill> extractSkills(String text) {
        List<Skill> result = new ArrayList<>();
        for (String skill : KNOWN_SKILLS) {
            if (text.toLowerCase().contains(skill.toLowerCase())) {
                result.add(new Skill(skill, 70)); // Điểm giả định
            }
        }
        return result;
    }
}
