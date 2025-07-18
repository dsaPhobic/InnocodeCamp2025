package model;

public class User {

    private int id;
    private String fullname;
    private String email;
    private String password;
    private String description;
    private String role;
    private String gender;
    private String location;
    private java.sql.Date dateOfBirth;
    

    public User() {
    }

    public User(int id, String fullname, String email, String password, String description, String role, String gender, String location, java.sql.Date dateOfBirth) {
        this.id = id;
        this.fullname = fullname;
        this.email = email;
        this.password = password;
        this.description = description;
        this.role = role;
        this.gender = gender;
        this.location = location;
        this.dateOfBirth = dateOfBirth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

   

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    

    // Getters
    public int getId() {
        return id;
    }

    public String getFullname() {
        return fullname;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getDescription() {
        return description;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public java.sql.Date getDateOfBirth() {
        return dateOfBirth;
    }
    public void setDateOfBirth(java.sql.Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    // Setters
    public void setId(int id) {
        this.id = id;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
}