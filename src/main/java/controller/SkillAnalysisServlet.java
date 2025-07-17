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

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String description = request.getParameter("description");
        Part filePart = request.getPart("cvFile");

        String fullText = "";

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadDir = getServletContext().getRealPath("/") + "uploads";
            Files.createDirectories(Paths.get(uploadDir));
            String filePath = uploadDir + File.separator + fileName;
            filePart.write(filePath);

            // Lưu CV vào bảng UploadedCVs
            UploadedCVDAO.save(user.getId(), fileName, filePath);

            // Parse nội dung CV
            fullText = CVParserService.parseCV(filePath);
        } else if (description != null && !description.trim().isEmpty()) {
            fullText = description;
        }

        // Tách kỹ năng
        List<Skill> skills = NLPService.extractSkills(fullText);

        // Lưu kỹ năng vào DB
        SkillDAO dao = new SkillDAO();
        dao.saveSkills(user.getId(), skills);

        request.setAttribute("skills", skills);
        request.getRequestDispatcher("view/skillResult.jsp").forward(request, response);
    }
}
