/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.*;
import model.Job;

/**
 *
 * @author hmqua
 */
public class JobDAO {
    private Connection getConnection() throws SQLException {
        // Sửa lại chuỗi kết nối cho phù hợp với cấu hình của bạn
        String url = "jdbc:mysql://localhost:3306/your_db_name";
        String user = "root";
        String pass = "";
        return DriverManager.getConnection(url, user, pass);
    }

    public void addJob(Job job) throws SQLException {
        String sql = "INSERT INTO Jobs (title, company, location, environment, skill_required, culture_tags, description, recruiter_email) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, job.getTitle());
            ps.setString(2, job.getCompany());
            ps.setString(3, job.getLocation());
            ps.setString(4, job.getEnvironment());
            ps.setString(5, job.getSkillRequired());
            ps.setString(6, job.getCultureTags());
            ps.setString(7, job.getDescription());
            ps.setString(8, job.getRecruiterEmail());
            ps.executeUpdate();
        }
    }

    public void updateJob(Job job) throws SQLException {
        String sql = "UPDATE Jobs SET title=?, company=?, location=?, environment=?, skill_required=?, culture_tags=?, description=?, recruiter_email=? WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, job.getTitle());
            ps.setString(2, job.getCompany());
            ps.setString(3, job.getLocation());
            ps.setString(4, job.getEnvironment());
            ps.setString(5, job.getSkillRequired());
            ps.setString(6, job.getCultureTags());
            ps.setString(7, job.getDescription());
            ps.setString(8, job.getRecruiterEmail());
            ps.setInt(9, job.getId());
            ps.executeUpdate();
        }
    }

    public void deleteJob(int id) throws SQLException {
        String sql = "DELETE FROM Jobs WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public List<Job> getAllJobs() throws SQLException {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT * FROM Jobs";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Job job = new Job(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("company"),
                    rs.getString("location"),
                    rs.getString("environment"),
                    rs.getString("skill_required"),
                    rs.getString("culture_tags"),
                    rs.getString("description"),
                    rs.getString("recruiter_email")
                );
                jobs.add(job);
            }
        }
        return jobs;
    }

    public Job getJobById(int id) throws SQLException {
        String sql = "SELECT * FROM Jobs WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Job(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("company"),
                        rs.getString("location"),
                        rs.getString("environment"),
                        rs.getString("skill_required"),
                        rs.getString("culture_tags"),
                        rs.getString("description"),
                        rs.getString("recruiter_email")
                    );
                }
            }
        }
        return null;
    }
}
