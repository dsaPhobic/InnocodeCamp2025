    package controller;

    import dao.SkillDAO;
    import dao.UploadedCVDAO;
    import model.Skill;
    import model.User;
    import service.CVParserService;
    import service.NLPService;

    import jakarta.servlet.*;
    import jakarta.servlet.annotation.MultipartConfig;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.*;
    import java.io.*;
    import java.nio.file.*;
    import java.util.*;

    @WebServlet("/SkillAnalysisServlet")
    @MultipartConfig
    public class SkillAnalysisServlet extends HttpServlet {
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            System.out.println("[SkillAnalysisServlet] ▶️ Bắt đầu xử lý POST");

            // ✅ 1. Kiểm tra đăng nhập
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                System.out.println("[SkillAnalysisServlet] ❌ Chưa đăng nhập, chuyển hướng về login.jsp");
                response.sendRedirect("login.jsp");
                return;
            }
            System.out.println("[SkillAnalysisServlet] ✅ Đã đăng nhập với user ID: " + user.getId());

            // ✅ 2. Lấy file CV
            Part filePart = request.getPart("cvFile");
            if (filePart == null || filePart.getSize() == 0) {
                System.out.println("[SkillAnalysisServlet] ❌ Không có file được chọn");
                response.sendRedirect("upload-cv.jsp?error=Vui lòng chọn file");
                return;
            }
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            System.out.println("[SkillAnalysisServlet] ✅ Đã nhận file: " + fileName);

            // ✅ 3. Xử lý upload file
            String uploadDir = getServletContext().getRealPath("/") + "uploads";
            Files.createDirectories(Paths.get(uploadDir));
            String filePath = uploadDir + File.separator + fileName;
            filePart.write(filePath);
            System.out.println("[SkillAnalysisServlet] ✅ Đã lưu file vào: " + filePath);

            // ✅ 4. Lưu thông tin file vào DB
            UploadedCVDAO.save(user.getId(), fileName, filePath);
            System.out.println("[SkillAnalysisServlet] ✅ Đã lưu thông tin file vào DB");

            // ✅ 5. Parse nội dung CV
            String fullText = CVParserService.parseCV(filePath);
            System.out.println("[SkillAnalysisServlet] ✅ Đã parse CV, độ dài nội dung: " + fullText.length());

            // ✅ 6. Gọi GPT để phân tích kỹ năng
            List<Skill> skills;
            try {
                skills = NLPService.extractSkills(fullText);
                if (skills == null) {
                    skills = new ArrayList<>();
                }
                System.out.println("[SkillAnalysisServlet] ✅ Đã phân tích kỹ năng, số kỹ năng: " + skills.size());
            } catch (Exception e) {
                skills = new ArrayList<>();
                System.out.println("[SkillAnalysisServlet] ❌ Lỗi khi phân tích kỹ năng: " + e.getMessage());
                request.setAttribute("error", "Lỗi khi phân tích kỹ năng: " + e.getMessage());
            }

            // ✅ 7. Lưu kỹ năng vào DB nếu có
            if (!skills.isEmpty()) {
                SkillDAO dao = new SkillDAO();
                dao.saveSkills(user.getId(), skills);
                System.out.println("[SkillAnalysisServlet] ✅ Đã lưu kỹ năng vào DB");
            } else {
                System.out.println("[SkillAnalysisServlet] ⚠️ Không có kỹ năng nào được lưu");
            }

            // ✅ 8. Gửi sang view để hiển thị
            request.setAttribute("skills", skills);
            System.out.println("[SkillAnalysisServlet] ✅ Forward đến skillResult.jsp để hiển thị kết quả");
            request.getRequestDispatcher("view/skillResult.jsp").forward(request, response);
        }
    }   
