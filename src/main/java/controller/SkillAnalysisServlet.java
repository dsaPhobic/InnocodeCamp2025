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

        // Kiểm tra đăng nhập
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy file CV
        Part filePart = request.getPart("cvFile");
        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect("upload-cv.jsp?error=Vui lòng chọn file");
            return;
        }

        // Xử lý upload
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String uploadDir = getServletContext().getRealPath("/") + "uploads";
        Files.createDirectories(Paths.get(uploadDir));
        String filePath = uploadDir + File.separator + fileName;
        filePart.write(filePath);

        // Lưu thông tin file vào DB
        UploadedCVDAO.save(user.getId(), fileName, filePath);

        // Parse nội dung CV
        String fullText = CVParserService.parseCV(filePath);

        // Gọi GPT để trích xuất kỹ năng + score
        List<Skill> skills = new ArrayList<>();
        try {
            skills = NLPService.extractSkills(fullText);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi phân tích kỹ năng: " + e.getMessage());
            request.getRequestDispatcher("view/skillResult.jsp").forward(request, response);
            return;
        }

        // Lưu kỹ năng vào DB
        SkillDAO dao = new SkillDAO();
        dao.saveSkills(user.getId(), skills);

        // Gửi sang view hiển thị
        request.setAttribute("skills", skills);
        request.getRequestDispatcher("view/skillResult.jsp").forward(request, response);
    }
}
