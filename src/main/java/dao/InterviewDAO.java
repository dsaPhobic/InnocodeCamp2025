package dao;

import model.Interview;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InterviewDAO {

    public boolean createInterview(Interview interview) {
        String sql = "INSERT INTO interviews (user_id, topic, question, created_at, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, interview.getUserId());
            stmt.setString(2, interview.getTopic());
            stmt.setString(3, interview.getQuestion() != null ? interview.getQuestion() : "");
            stmt.setTimestamp(4, Timestamp.valueOf(interview.getCreatedAt()));
            stmt.setString(5, interview.getStatus());

            System.out.println("Executing SQL: " + sql);
            System.out.println("Parameters: user_id=" + interview.getUserId() + ", topic=" + interview.getTopic() + ", question=" + interview.getQuestion());

            int affectedRows = stmt.executeUpdate();
            System.out.println("Affected rows: " + affectedRows);

            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int generatedId = rs.getInt(1);
                        interview.setId(generatedId);
                        System.out.println("Generated interview ID: " + generatedId);
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in createInterview: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateInterview(Interview interview) {
        String sql = "UPDATE interviews SET user_answer = ?, ai_feedback = ?, suggestions = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, interview.getUserAnswer());
            stmt.setString(2, interview.getAiFeedback());
            stmt.setString(3, interview.getSuggestions());
            stmt.setString(4, interview.getStatus());
            stmt.setInt(5, interview.getId());

            System.out.println("Updating interview with user_answer length: " + 
                (interview.getUserAnswer() != null ? interview.getUserAnswer().length() : 0));

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating interview: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public Interview getInterviewById(int id) {
        String sql = "SELECT * FROM interviews WHERE id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            System.out.println("Looking for interview with ID: " + id);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Interview interview = mapResultSetToInterview(rs);
                System.out.println("Found interview: ID=" + interview.getId() + ", UserID=" + interview.getUserId());
                return interview;
            } else {
                System.out.println("No interview found with ID: " + id);
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in getInterviewById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<Interview> getInterviewsByUserId(int userId) {
        List<Interview> interviews = new ArrayList<>();
        String sql = "SELECT * FROM interviews WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                interviews.add(mapResultSetToInterview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return interviews;
    }

    public List<Interview> getRecentInterviewsByUserId(int userId, int limit) {
        List<Interview> interviews = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM interviews WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                interviews.add(mapResultSetToInterview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return interviews;
    }

    public boolean checkTableExists() {
        String sql = "SELECT COUNT(*) FROM interviews";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("Interviews table exists with " + count + " records");
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Interviews table does not exist or error: " + e.getMessage());
            return false;
        }
        return false;
    }

    public void logTableStructure() {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement("SELECT TOP 1 * FROM interviews")) {

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                System.out.println("Table structure check - Found at least one record");
            } else {
                System.out.println("Table structure check - Table exists but is empty");
            }
        } catch (SQLException e) {
            System.err.println("Error checking table structure: " + e.getMessage());
        }
    }

    public boolean deleteEmptyInterviews() {
        String sql = "DELETE FROM interviews WHERE (user_answer IS NULL OR user_answer = '') AND status = 'completed'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            int affectedRows = stmt.executeUpdate();
            System.out.println("Deleted " + affectedRows + " empty interviews");
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteInterviewById(int interviewId) {
        String sql = "DELETE FROM interviews WHERE id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, interviewId);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Interview mapResultSetToInterview(ResultSet rs) throws SQLException {
        Interview interview = new Interview();
        interview.setId(rs.getInt("id"));
        interview.setUserId(rs.getInt("user_id"));
        interview.setTopic(rs.getString("topic"));
        interview.setQuestion(rs.getString("question"));
        interview.setUserAnswer(rs.getString("user_answer"));
        interview.setAiFeedback(rs.getString("ai_feedback"));
        interview.setScore(rs.getInt("score"));
        interview.setSuggestions(rs.getString("suggestions"));
        interview.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        interview.setStatus(rs.getString("status"));
        return interview;
    }
}
