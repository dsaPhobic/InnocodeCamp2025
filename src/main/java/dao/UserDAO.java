/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.User;
import java.sql.*;

/**
 *
 * @author hmqua
 */
public class UserDAO {

    public static boolean updateUser(User user) {
        try (java.sql.Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE users SET fullname=?, email=? WHERE id=?";
            java.sql.PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getFullname());
            ps.setString(2, user.getEmail());
            ps.setInt(3, user.getId());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    // Authenticate user by email and password
    public User getUserByEmailAndPassword(String email, String password) {
        String sql = "SELECT * FROM Users WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Check if user exists by email
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Register new user (with all fields)
    public boolean registerUser(User user) {
        String sql = "INSERT INTO Users (fullname, email, password, description, role, gender) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getFullname());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getDescription());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getGender());
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    user.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Overloaded registerUser for registration with extra fields (if needed)
    public boolean registerUser(String fullName, String email, String password, String gender, java.sql.Date dateOfBirth) {
        String sql = "INSERT INTO Users (fullname, email, password, gender, date_of_birth) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setString(2, email);
            stmt.setString(3, password); // TODO: hash password in production
            stmt.setString(4, gender);
            stmt.setDate(5, dateOfBirth);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Static method for login (used in LoginServlet)
    public static User checkLogin(String email, String password) {
        return new UserDAO().getUserByEmailAndPassword(email, password);
    }

    // Static method to check if user exists by email (used in RegisterServlet)
    public static boolean userExistsByEmail(String email) {
        return new UserDAO().getUserByEmail(email) != null;
    }

    // Helper to extract User from ResultSet
    private User extractUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setFullname(rs.getString("fullname"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setDescription(rs.getString("description"));
        user.setRole(rs.getString("role"));
        user.setGender(rs.getString("gender"));
        return user;
    }
}