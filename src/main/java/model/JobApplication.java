package model;

import java.util.Date;

public class JobApplication {

    private int id;
    private int userId;
    private int jobId;
    private String status;
    private Date appliedAt;
    private Job job; // Có thể gắn đối tượng Job để tiện hiển thị thông tin 

    public JobApplication() {
    }

    public JobApplication(int userId, int jobId, String status) {
        this.userId = userId;
        this.jobId = jobId;
        this.status = status;
        // appliedAt có thể lấy thời gian hiện tại hoặc để DB tự động thêm
    }
    // Getter/Setter các thuộc tính

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getJobId() {
        return jobId;
    }

    public void setJobId(int jobId) {
        this.jobId = jobId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getAppliedAt() {
        return appliedAt;
    }

    public void setAppliedAt(Date appliedAt) {
        this.appliedAt = appliedAt;
    }

    public Job getJob() {
        return job;
    }

    public void setJob(Job job) {
        this.job = job;
    }
    // (các getter/setter cho id và các field còn lại tương tự)
}
