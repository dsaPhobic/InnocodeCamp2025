package dao;

import java.sql.*;

public class UploadedCVDAO {
    public static void save(int userId, String fileName, String filePath) {
        String sql = "INSERT INTO UploadedCVs (user_id, file_name, file_path) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, fileName);
            ps.setString(3, filePath);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
