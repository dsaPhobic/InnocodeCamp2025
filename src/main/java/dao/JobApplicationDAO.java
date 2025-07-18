package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.JobApplication;
import model.Job;

public class JobApplicationDAO {

    // Thêm một đơn ứng tuyển vào DB
    public boolean addApplication(int userId, int jobId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rsCheck = null;

        try {
            conn = DBConnection.getConnection();

            // Kiểm tra nếu đã apply trước đó
            String checkSql = "SELECT COUNT(*) FROM JobApplications WHERE user_id = ? AND job_id = ?";
            ps = conn.prepareStatement(checkSql);
            ps.setInt(1, userId);
            ps.setInt(2, jobId);
            rsCheck = ps.executeQuery();
            if (rsCheck.next() && rsCheck.getInt(1) > 0) {
                return false; // đã apply rồi
            }
            rsCheck.close();
            ps.close();

            // Thêm đơn ứng tuyển mới
            String insertSql = "INSERT INTO JobApplications(user_id, job_id, status) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(insertSql);
            ps.setInt(1, userId);
            ps.setInt(2, jobId);
            ps.setString(3, "Applied");
            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (rsCheck != null) rsCheck.close(); } catch (SQLException ignored) {}
            try { if (ps != null) ps.close(); } catch (SQLException ignored) {}
            DBConnection.closeConnection(conn);
        }
    }

    // Lấy danh sách các job mà user đã ứng tuyển
    public List<JobApplication> getApplicationsByUser(int userId) {
        List<JobApplication> applications = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            String sql = "SELECT a.job_id, a.status, a.applied_at, "
                       + "j.title, j.company, j.location, j.environment, j.recruiter_email "
                       + "FROM JobApplications a JOIN Jobs j ON a.job_id = j.id "
                       + "WHERE a.user_id = ? ORDER BY a.applied_at DESC";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                JobApplication app = new JobApplication();
                app.setUserId(userId);
                app.setJobId(rs.getInt("job_id"));
                app.setStatus(rs.getString("status"));

                Timestamp ts = rs.getTimestamp("applied_at");
                if (ts != null) {
                    app.setAppliedAt(new Date(ts.getTime()));
                }

                Job job = new Job();
                job.setId(rs.getInt("job_id"));
                job.setTitle(rs.getString("title"));
                job.setCompany(rs.getString("company"));
                job.setLocation(rs.getString("location"));
                job.setEnvironment(rs.getString("environment"));
                job.setRecruiterEmail(rs.getString("recruiter_email"));

                app.setJob(job);
                applications.add(app);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (ps != null) ps.close(); } catch (SQLException ignored) {}
            DBConnection.closeConnection(conn);
        }

        return applications;
    }
}
