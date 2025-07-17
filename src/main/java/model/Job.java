/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class Job {
    private int id;
    private String title;
    private String company;
    private String location;
    private String environment;
    private String skillRequired;
    private String cultureTags;
    private String description;
    private String recruiterEmail;

    public Job() {}

    public Job(int id, String title, String company, String location, String environment, String skillRequired, String cultureTags, String description, String recruiterEmail) {
        this.id = id;
        this.title = title;
        this.company = company;
        this.location = location;
        this.environment = environment;
        this.skillRequired = skillRequired;
        this.cultureTags = cultureTags;
        this.description = description;
        this.recruiterEmail = recruiterEmail;
    }

    public Job(String title, String company, String location, String environment, String skillRequired, String cultureTags, String description, String recruiterEmail) {
        this.title = title;
        this.company = company;
        this.location = location;
        this.environment = environment;
        this.skillRequired = skillRequired;
        this.cultureTags = cultureTags;
        this.description = description;
        this.recruiterEmail = recruiterEmail;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getEnvironment() {
        return environment;
    }

    public void setEnvironment(String environment) {
        this.environment = environment;
    }

    public String getSkillRequired() {
        return skillRequired;
    }

    public void setSkillRequired(String skillRequired) {
        this.skillRequired = skillRequired;
    }

    public String getCultureTags() {
        return cultureTags;
    }

    public void setCultureTags(String cultureTags) {
        this.cultureTags = cultureTags;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getRecruiterEmail() {
        return recruiterEmail;
    }

    public void setRecruiterEmail(String recruiterEmail) {
        this.recruiterEmail = recruiterEmail;
    }
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getCompany() { return company; }
    public void setCompany(String company) { this.company = company; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getEnvironment() { return environment; }
    public void setEnvironment(String environment) { this.environment = environment; }
    public String getSkillRequired() { return skillRequired; }
    public void setSkillRequired(String skillRequired) { this.skillRequired = skillRequired; }
    public String getCultureTags() { return cultureTags; }
    public void setCultureTags(String cultureTags) { this.cultureTags = cultureTags; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getRecruiterEmail() { return recruiterEmail; }
    public void setRecruiterEmail(String recruiterEmail) { this.recruiterEmail = recruiterEmail; }
}
