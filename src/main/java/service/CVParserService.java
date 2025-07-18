package service;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;

import java.io.*;
import java.util.List;

public class CVParserService {

    public static String parseCV(String filePath) {
        try {
            if (filePath.endsWith(".pdf")) {
                return extractTextFromPDF(filePath);
            } else if (filePath.endsWith(".docx")) {
                return extractTextFromDOCX(filePath);
            } else if (filePath.endsWith(".txt")) {
                return extractTextFromTXT(filePath);
            } else {
                return "Không hỗ trợ định dạng file này.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    private static String extractTextFromPDF(String filePath) throws IOException {
        try (PDDocument document = PDDocument.load(new File(filePath))) {
            PDFTextStripper stripper = new PDFTextStripper();
            return stripper.getText(document);
        }
    }

    private static String extractTextFromDOCX(String filePath) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (FileInputStream fis = new FileInputStream(filePath); XWPFDocument document = new XWPFDocument(fis)) {
            List<XWPFParagraph> paragraphs = document.getParagraphs();
            for (XWPFParagraph para : paragraphs) {
                sb.append(para.getText()).append("\n");
            }
        }
        return sb.toString();
    }

    private static String extractTextFromTXT(String filePath) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line).append("\n");
            }
        }
        return sb.toString();
    }

    public static void main(String[] args) {
        // Đường dẫn đến thư mục test trong Sources/test
        String basePath = "./Sources/test/";

        String pdfPath = basePath + "cv.pdf";
        String docxPath = basePath + "sample_cv.docx";
        String txtPath = basePath + "sample_cv.txt";
        String unknownPath = basePath + "sample_cv.xls";

        // Test PDF
        System.out.println("=== PDF CV ===");
            System.out.println(CVParserService.parseCV(pdfPath));

    //        // Test DOCX
    //        System.out.println("=== DOCX CxV ===");
    //        System.out.println(CVParserService.parseCV(docxPath));
    //
    //        // Test TXT
    //        System.out.println("=== TXT CV ===");
    //        System.out.println(CVParserService.parseCV(txtPath));
    //
    //        // Test unsupported
    //        System.out.println("=== Unsupported Format ===");
    //        System.out.println(CVParserService.parseCV(unknownPath));
    }

}
