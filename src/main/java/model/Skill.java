/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class Skill {
    private String skillName;
    private int score;

    public Skill(String skillName, int score) {
        this.skillName = skillName;
        this.score = score;
    }

    public String getSkillName() {
        return skillName;
    }

    public int getScore() {
        return score;
    }
}
