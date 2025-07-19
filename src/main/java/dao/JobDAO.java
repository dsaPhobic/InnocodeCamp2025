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

    public void addJob(Job job) throws SQLException {
        String sql = "INSERT INTO Jobs (title, company, location, environment, skill_required, culture_tags, description, recruiter_email, status, posted_at, salary, experience) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, job.getTitle());
            ps.setString(2, job.getCompany());
            ps.setString(3, job.getLocation());
            ps.setString(4, job.getEnvironment());
            ps.setString(5, job.getSkillRequired());
            ps.setString(6, job.getCultureTags());
            ps.setString(7, job.getDescription());
            ps.setString(8, job.getRecruiterEmail());
            ps.setString(9, job.getStatus());
            if (job.getPostedAt() != null) {
                ps.setTimestamp(10, new java.sql.Timestamp(job.getPostedAt().getTime()));
            } else {
                ps.setTimestamp(10, new java.sql.Timestamp(System.currentTimeMillis()));
            }
            ps.setFloat(11, job.getSalary());
            ps.setString(12, job.getExperience());
            ps.executeUpdate();
        }
    }

    public void updateJob(Job job) throws SQLException {
        String sql = "UPDATE Jobs SET title=?, company=?, location=?, environment=?, skill_required=?, culture_tags=?, description=?, recruiter_email=?, status=?, posted_at=?, salary=?, experience=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, job.getTitle());
            ps.setString(2, job.getCompany());
            ps.setString(3, job.getLocation());
            ps.setString(4, job.getEnvironment());
            ps.setString(5, job.getSkillRequired());
            ps.setString(6, job.getCultureTags());
            ps.setString(7, job.getDescription());
            ps.setString(8, job.getRecruiterEmail());
            ps.setString(9, job.getStatus());
            if (job.getPostedAt() != null) {
                ps.setTimestamp(10, new java.sql.Timestamp(job.getPostedAt().getTime()));
            } else {
                ps.setTimestamp(10, new java.sql.Timestamp(System.currentTimeMillis()));
            }
            ps.setFloat(11, job.getSalary());
            ps.setString(12, job.getExperience());
            ps.setInt(13, job.getId());
            ps.executeUpdate();
        }
    }

    public void deleteJob(int id) throws SQLException {
        String sql = "DELETE FROM Jobs WHERE id=?";
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public List<Job> getAllJobs() throws SQLException {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT * FROM Jobs ORDER BY posted_at DESC";
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
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
                    rs.getString("recruiter_email"),
                    rs.getString("status"),
                    rs.getTimestamp("posted_at"),
                    rs.getFloat("salary"),
                    rs.getString("experience")
                );
                jobs.add(job);
            }
        }
        return jobs;
    }

    public Job getJobById(int id) throws SQLException {
        String sql = "SELECT * FROM Jobs WHERE id=?";
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
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
                        rs.getString("recruiter_email"),
                        rs.getString("status"),
                        rs.getTimestamp("posted_at"),
                        rs.getFloat("salary"),
                        rs.getString("experience")
                    );
                }
            }
        }
        return null;
    }
}