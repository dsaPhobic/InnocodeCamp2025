package dao;

import java.sql.*;
import java.util.*;
import model.JobRecommendation;
import model.Job;

public class RecommendationDAO {

    public List<JobRecommendation> generateRecommendationsForUser(int userId) {
        List<JobRecommendation> recommendations = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // B1: Lấy kỹ năng + điểm của user
            String getSkillsSql = "SELECT skill_name, score FROM Skills WHERE user_id = ?";
            ps = conn.prepareStatement(getSkillsSql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            Map<String, Integer> userSkillMap = new HashMap<>();
            while (rs.next()) {
                String skillName = rs.getString("skill_name").toLowerCase().trim();
                int score = rs.getInt("score");
                userSkillMap.put(skillName, score);
            }
            rs.close();
            ps.close();

            // B2: Lấy tất cả công việc
            String getJobsSql = "SELECT id, title, company, location, environment, skill_required, recruiter_email, salary, experience FROM Jobs";
            ps = conn.prepareStatement(getJobsSql);
            rs = ps.executeQuery();

            // Xoá các gợi ý cũ
            String deleteOld = "DELETE FROM JobRecommendations WHERE user_id = ?";
            PreparedStatement psDelete = conn.prepareStatement(deleteOld);
            psDelete.setInt(1, userId);
            psDelete.executeUpdate();
            psDelete.close();

            // B3: Tính toán % match và insert
            String insertRecSql = "INSERT INTO JobRecommendations(user_id, job_id, match_percent) VALUES (?, ?, ?)";
            PreparedStatement psInsert = conn.prepareStatement(insertRecSql);

            // Lưu tạm matchDetail
            Map<Integer, String> matchDetailMap = new HashMap<>();

            while (rs.next()) {
                int jobId = rs.getInt("id");
                String skillsRequired = rs.getString("skill_required");

                if (skillsRequired == null || skillsRequired.isEmpty()) continue;

                String[] requiredSkills = skillsRequired.toLowerCase().split("[,;]");
                int totalRequiredScore = 0;
                int matchedScore = 0;

                for (String req : requiredSkills) {
                    req = req.trim();
                    totalRequiredScore += 100; // mỗi kỹ năng cần 100 điểm

                    if (userSkillMap.containsKey(req)) {
                        matchedScore += userSkillMap.get(req); // điểm người dùng có
                    }
                }

                if (totalRequiredScore > 0 && matchedScore > 0) {
                    int matchPercent = (int) Math.round((matchedScore * 100.0) / totalRequiredScore);

                    psInsert.setInt(1, userId);
                    psInsert.setInt(2, jobId);
                    psInsert.setInt(3, matchPercent);
                    psInsert.addBatch();

                    matchDetailMap.put(jobId, matchedScore + "/" + totalRequiredScore + " điểm phù hợp");
                }
            }
            rs.close();
            psInsert.executeBatch();
            psInsert.close();

            // B4: Truy vấn kết quả để hiển thị
            String joinSql = "SELECT r.match_percent, j.id, j.title, j.company, j.location, j.environment, j.recruiter_email, j.description, j.salary, j.experience " +
                             "FROM JobRecommendations r JOIN Jobs j ON r.job_id = j.id " +
                             "WHERE r.user_id = ? ORDER BY r.match_percent DESC";
            ps = conn.prepareStatement(joinSql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                int jobId = rs.getInt("id");
                int matchPercent = rs.getInt("match_percent");

                JobRecommendation rec = new JobRecommendation();
                rec.setUserId(userId);
                rec.setJobId(jobId);
                rec.setMatchPercent(matchPercent);
                rec.setMatchDetail(matchDetailMap.getOrDefault(jobId, ""));

                Job job = new Job();
                job.setId(jobId);
                job.setTitle(rs.getString("title"));
                job.setCompany(rs.getString("company"));
                job.setLocation(rs.getString("location"));
                job.setEnvironment(rs.getString("environment"));
                job.setRecruiterEmail(rs.getString("recruiter_email"));
                job.setDescription(rs.getString("description")); // mapping description
                job.setSalary(rs.getFloat("salary")); // mapping salary
                job.setExperience(rs.getString("experience")); // mapping experience

                rec.setJob(job);
                recommendations.add(rec);
            }

            conn.commit();

        } catch (SQLException e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (SQLException ignored) {}
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (ps != null) ps.close(); } catch (SQLException ignored) {}
            DBConnection.closeConnection(conn);
        }

        return recommendations;
    }
}
