package dao;

import model.Skill;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class SkillDAO {

    // Lưu danh sách kỹ năng vào bảng Skills
    public void saveSkills(int userId, List<Skill> skills) {
        for (Skill s : skills) {
            upsertSkill(userId, s);
        }
    }

    // Thêm mới hoặc cập nhật điểm kỹ năng nếu đã tồn tại
    public void upsertSkill(int userId, Skill skill) {
        String checkSql = "SELECT COUNT(*) FROM Skills WHERE user_id = ? AND skill_name = ?";
        String insertSql = "INSERT INTO Skills (user_id, skill_name, score) VALUES (?, ?, ?)";
        String updateSql = "UPDATE Skills SET score = ? WHERE user_id = ? AND skill_name = ?";
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setInt(1, userId);
                checkPs.setString(2, skill.getSkillName());
                ResultSet rs = checkPs.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    // Đã có, update
                    try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                        updatePs.setInt(1, skill.getScore());
                        updatePs.setInt(2, userId);
                        updatePs.setString(3, skill.getSkillName());
                        updatePs.executeUpdate();
                    }
                } else {
                    // Chưa có, insert
                    try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                        insertPs.setInt(1, userId);
                        insertPs.setString(2, skill.getSkillName());
                        insertPs.setInt(3, skill.getScore());
                        insertPs.executeUpdate();
                    }
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
        String sql = "SELECT skill_name, score FROM Skills WHERE user_id = ? ORDER BY score DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
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
    
    // ✅ Hàm mới: Lấy trung bình điểm skill của thị trường
    public Map<String, Double> getMarketSkillAverages() {
        Map<String, Double> averages = new java.util.HashMap<>();
        String sql = "SELECT skill_name, AVG(score) as avg_score FROM Skills GROUP BY skill_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String skillName = rs.getString("skill_name").toLowerCase();
                double avgScore = rs.getDouble("avg_score");
                averages.put(skillName, avgScore);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return averages;
    }
}