package model;

public class User {
    private int id;
    private String fullname;
    private String email;
    private String password;
    private String description;
    private boolean isAdmin;

    public User() {
    }

    public User(int id, String fullname, String email, String password, String description, boolean isAdmin) {
        this.id = id;
        this.fullname = fullname;
        this.email = email;
        this.password = password;
        this.description = description;
        this.isAdmin = isAdmin;
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

    public boolean isAdmin() {
        return isAdmin;
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

    public void setAdmin(boolean isAdmin) {
        this.isAdmin = isAdmin;
    }
}