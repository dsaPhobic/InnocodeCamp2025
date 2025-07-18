package model;  // giả sử các entity nằm trong package model

public class JobRecommendation {

    private int id;
    private int userId;
    private int jobId;
    private int matchPercent;
    private Job job;  // Có thể thêm thuộc tính Job để tiện truy cập thông tin công việc
    private String matchDetail;

    // Constructor không tham số
    public JobRecommendation() {
    }

    // Constructor đầy đủ (không bao gồm id vì id tự tăng trong DB)
    public JobRecommendation(int userId, int jobId, int matchPercent) {
        this.userId = userId;
        this.jobId = jobId;
        this.matchPercent = matchPercent;
    }

    // Getter và Setter cho các thuộc tính
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

    public int getMatchPercent() {
        return matchPercent;
    }

    public void setMatchPercent(int matchPercent) {
        this.matchPercent = matchPercent;
    }

    public Job getJob() {
        return job;
    }

    public void setJob(Job job) {
        this.job = job;
    }

    public String getMatchDetail() {
    return matchDetail;
}

public void setMatchDetail(String matchDetail) {
    this.matchDetail = matchDetail;
}
    
}
