package dao;

import model.Skill;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SkillDAO {

    // Lưu danh sách kỹ năng vào bảng Skills
    public void saveSkills(int userId, List<Skill> skills) {
        String sql = "INSERT INTO Skills (user_id, skill_name, score) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            for (Skill s : skills) {
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, userId);
                    ps.setString(2, s.getSkillName());
                    ps.setInt(3, s.getScore());
                    ps.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy toàn bộ kỹ năng của 1 user
    public List<Skill> getSkillsByUser(int userId) {
        List<Skill> skills = new ArrayList<>();
        String sql = "SELECT skill_name, score FROM Skills WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String name = rs.getString("skill_name");
                int score = rs.getInt("score");
                skills.add(new Skill(name, score));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return skills;
    }

    // ✅ Hàm mới: Lấy n kỹ năng điểm cao nhất
    public List<Skill> getTopSkillsByUser(int userId, int limit) {
        List<Skill> topSkills = new ArrayList<>();
        String sql = "SELECT TOP (?) skill_name, score FROM Skills WHERE user_id = ? ORDER BY score DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String name = rs.getString("skill_name");
                int score = rs.getInt("score");
                topSkills.add(new Skill(name, score));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return topSkills;
    }

    public void deleteSkillsByUser(int userId) {
        String sql = "DELETE FROM Skills WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}