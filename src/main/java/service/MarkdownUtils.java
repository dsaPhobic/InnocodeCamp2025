/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import com.vladsch.flexmark.html.HtmlRenderer;
import com.vladsch.flexmark.parser.Parser;
import com.vladsch.flexmark.util.data.MutableDataSet;

public class MarkdownUtils {

    private static final Parser parser;
    private static final HtmlRenderer renderer;

    static {
        MutableDataSet options = new MutableDataSet();
        parser = Parser.builder(options).build();
        renderer = HtmlRenderer.builder(options).build();
    }

    public static String toHtml(String markdownText) {
        return renderer.render(parser.parse(markdownText));
    }

    public static void main(String[] args) {
        String markdown = "## Mô tả công việc\n\n- Phát triển và tối ưu hóa giao diện người dùng sử dụng HTML, CSS và JavaScript.\n- Làm việc với Git để quản lý mã nguồn hiệu quả.\n\n## Yêu cầu ứng viên\n\n- Thành thạo HTML, CSS và JavaScript.\n- Biết sử dụng Git và hiểu về quản lý version control.";
        String html = toHtml(markdown);
        System.out.println("[TEST] Markdown gốc:\n" + markdown);
        System.out.println("[TEST] HTML sau khi chuyển đổi:\n" + html);
    }
}