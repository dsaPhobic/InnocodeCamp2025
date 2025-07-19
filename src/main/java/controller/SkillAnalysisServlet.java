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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Skill> existingSkills = new SkillDAO().getSkillsByUser(user.getId());
        request.setAttribute("skills", existingSkills);

        request.getRequestDispatcher("view/inputDescription.jsp").forward(request, response);
    }

    // ✅ Xử lý khi user submit CV
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("[SkillAnalysisServlet] ▶️ Bắt đầu xử lý POST");

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Part filePart = request.getPart("cvFile");
        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect("upload-cv.jsp?error=Vui lòng chọn file");
            return;
        }

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String uploadDir = getServletContext().getRealPath("/") + "uploads";
        Files.createDirectories(Paths.get(uploadDir));
        String filePath = uploadDir + File.separator + fileName;
        filePart.write(filePath);

        UploadedCVDAO.save(user.getId(), fileName, filePath);

        String fullText = CVParserService.parseCV(filePath);

        List<Skill> skills;
        try {
            skills = NLPService.extractSkills(fullText);
        } catch (Exception e) {
            skills = new ArrayList<>();
            request.setAttribute("error", "Lỗi khi phân tích kỹ năng: " + e.getMessage());
        }

        if (skills != null && !skills.isEmpty()) {
            new SkillDAO().saveSkills(user.getId(), skills); // now upserts
        }

        request.setAttribute("skills", skills);
        request.getRequestDispatcher("view/skillResult.jsp").forward(request, response);
    }
}