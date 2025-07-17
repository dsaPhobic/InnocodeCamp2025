<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
    <head>
        <title>Việc làm gợi ý</title>
        <style>
            table {
                border-collapse: collapse;
                width: 100%;
            }
            th, td {
                border: 1px solid #ccc;
                padding: 8px;
                text-align: left;
            }
            th {
                background: #f4f4f4;
            }
        </style>
    </head>
    <body>
        <h2>Việc làm phù hợp với kỹ năng của bạn</h2>
        <c:if test="${not empty message}">
            <div style="padding: 10px; margin-bottom: 15px;
                 color: ${fn:contains(message, '✅') ? 'green' : 'red'};
                 background-color: #f9f9f9; border-left: 4px solid ${fn:contains(message, '✅') ? 'green' : 'red'};">
                ${message}
            </div>
        </c:if>

        <p>Danh sách các công việc gợi ý cho bạn (dựa trên kỹ năng):</p>

        <!-- Thông báo nếu có -->
        <c:if test="${not empty message}">
            <div style="color: green;">${message}</div>
        </c:if>

        <table>
            <tr>
                <th>Vị trí</th>
                <th>Công ty</th>
                <th>% Phù hợp</th>
                <th>Apply</th>
            </tr>

            <!-- Lặp qua danh sách recommendations -->
            <c:forEach var="rec" items="${recommendations}">
                <tr>
                    <td>${rec.job.title}</td>
                    <td>${rec.job.company}</td>
                    <td>${rec.matchPercent}% (${rec.matchDetail})</td>
                    <td>
                        <!-- Form apply -->
                        <button type="button" class="apply-btn" data-job-id="${rec.job.id}">
                            Apply
                        </button>

                    </td>
                </tr>
            </c:forEach>

            <!-- Nếu không có gợi ý -->
            <c:if test="${empty recommendations}">
                <tr>
                    <td colspan="4"><em>Không có gợi ý công việc phù hợp.</em></td>
                </tr>
            </c:if>
        </table>

        <script>
            document.querySelectorAll('.apply-btn').forEach(button => {
                button.addEventListener('click', () => {
                    const jobId = button.getAttribute('data-job-id');

                    fetch('ApplyJobServlet', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                            'X-Requested-With': 'XMLHttpRequest'
                        },
                        body: 'jobId=' + jobId
                    })
                            .then(response => response.text())
                            .then(result => {
                                if (result.trim() === 'success') {
                                    button.disabled = true;
                                    button.innerText = "Đã ứng tuyển";
                                    button.style.backgroundColor = '#4CAF50';
                                    alert("✅ Ứng tuyển thành công!");
                                } else if (result.trim() === 'duplicate') {
                                    alert("⚠️ Bạn đã ứng tuyển công việc này trước đó.");
                                } else {
                                    alert("❌ Có lỗi xảy ra.");
                                }
                            })
                            .catch(error => {
                                console.error("Lỗi:", error);
                                alert("❌ Không thể kết nối máy chủ.");
                            });
                });
            });
        </script>

    </body>
</html>
