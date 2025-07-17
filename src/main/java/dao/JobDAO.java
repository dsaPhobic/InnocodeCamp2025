/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Job;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author hmqua
 */
public class JobDAO {
    public void addJob(Job job) {
        String sql = "INSERT INTO Jobs (title, company, location, environment, skill_required, culture_tags, description, recruiter_email) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
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
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateJob(Job job) {
        String sql = "UPDATE Jobs SET title=?, company=?, location=?, environment=?, skill_required=?, culture_tags=?, description=?, recruiter_email=? WHERE id=?";
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
            ps.setInt(9, job.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteJob(int id) {
        String sql = "DELETE FROM Jobs WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Job> getAllJobs() {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT * FROM Jobs";
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
                    rs.getString("recruiter_email")
                );
                jobs.add(job);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return jobs;
    }

    public Job getJobById(int id) {
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
                        rs.getString("recruiter_email")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
