<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    model.User user = (model.User) session.getAttribute("user");
%>
<html>
<head>
    <title>User Settings</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <style>
        body {
            background: #f3f4f6;
            font-family: 'Inter', system-ui, sans-serif;
            font-size: 1.7rem;
        }
        .settings-container {
            max-width: 540px;
            margin: 60px auto 0 auto;
            background: #fff;
            border-radius: 1rem;
            box-shadow: 0 2px 8px 0 rgba(16, 30, 54, 0.08), 0 1.5px 4px 0 rgba(16, 30, 54, 0.04);
            padding: 36px 32px 28px 32px;
        }
        h2 {
            color: #2563eb;
            font-weight: 800;
            text-align: center;
            margin-bottom: 32px;
            letter-spacing: 1px;
            font-size: 3.2rem;
        }
        .form-label {
            color: #334155;
            font-weight: 600;
            font-size: 1.7rem;
        }
        .form-control {
            border-radius: 0.75rem;
            border: 1px solid #e5e7eb;
            font-size: 1.55rem;
            background: #f9fafb;
            color: #222;
            margin-bottom: 0.7rem;
            transition: border 0.2s, box-shadow 0.2s;
            padding: 1.2rem 1.4rem;
        }
        .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 2px #2563eb22;
            background: #fff;
        }
        .btn-primary {
            background: linear-gradient(90deg, #2563eb, #7c3aed);
            border: none;
            font-weight: 700;
            border-radius: 1.5rem;
            padding: 18px 40px;
            transition: background 0.2s, transform 0.2s;
            font-size: 1.7rem;
        }
        .btn-primary:hover {
            background: linear-gradient(90deg, #7c3aed, #2563eb);
            transform: translateY(-2px) scale(1.03);
        }
        .btn-link {
            color: #7c3aed;
            font-weight: 600;
            font-size: 1.25rem;
            text-decoration: underline;
            border: none;
            background: none;
            padding: 0 0.5rem;
            transition: color 0.2s;
            margin-left: auto;
        }
        .btn-link:disabled {
            color: #cbd5e1;
            text-decoration: none;
        }
        .btn-link:hover:not(:disabled) {
            color: #2563eb;
        }
        .alert-info {
            border-radius: 0.75rem;
            font-weight: 600;
            color: #2563eb;
            background: #eff6ff;
            border: 1px solid #dbeafe;
            font-size: 2.1rem;
            padding: 1.1rem 1.5rem;
        }
        #location-status {
            min-width: 1.5em;
            display: inline-block;
            margin-left: 0.75rem;
            margin-right: 0;
        }
        .mb-3.d-flex.align-items-center {
            display: flex;
            align-items: center;
            justify-content: flex-start;
        }
        .edit-icon-btn svg {
            vertical-align: middle;
            pointer-events: none;
        }
        .edit-icon-btn {
            background: none;
            border: none;
            padding: 0;
            margin-left: auto;
            cursor: pointer;
            display: flex;
            align-items: center;
        }
    </style>
</head>
<body>
    <div class="settings-container">
        <h2>User Settings</h2>
        <form action="SettingsServlet" method="post" id="settingsForm" onsubmit="return submitSettingsForm(event)">
            <div class="mb-3 d-flex align-items-center">
                <label class="form-label flex-grow-1">Full Name</label>
                <button type="button" class="btn btn-link p-0 ms-2 edit-icon-btn" onclick="enableEdit(this, 'fullName')" title="Edit">
                    <svg xmlns="http://www.w3.org/2000/svg" width="1.5em" height="1.5em" fill="none" viewBox="0 0 24 24"><path stroke="#7c3aed" stroke-width="2" d="M16.475 5.408a2.2 2.2 0 0 1 3.112 3.112l-9.1 9.1a2 2 0 0 1-.707.44l-3.2 1.067a.5.5 0 0 1-.633-.633l1.067-3.2a2 2 0 0 1 .44-.707l9.1-9.1Z"/><path stroke="#7c3aed" stroke-width="2" stroke-linecap="round" d="M15.5 7.5l1 1"/></svg>
                </button>
            </div>
            <div class="mb-3">
                <input type="text" id="fullName" name="fullName" class="form-control" value="${user.fullname}" readonly required>
            </div>
            <div class="mb-3 d-flex align-items-center">
                <label class="form-label flex-grow-1">Description</label>
                <button type="button" class="btn btn-link p-0 ms-2 edit-icon-btn" onclick="enableEdit(this, 'description')" title="Edit">
                    <svg xmlns="http://www.w3.org/2000/svg" width="1.5em" height="1.5em" fill="none" viewBox="0 0 24 24"><path stroke="#7c3aed" stroke-width="2" d="M16.475 5.408a2.2 2.2 0 0 1 3.112 3.112l-9.1 9.1a2 2 0 0 1-.707.44l-3.2 1.067a.5.5 0 0 1-.633-.633l1.067-3.2a2 2 0 0 1 .44-.707l9.1-9.1Z"/><path stroke="#7c3aed" stroke-width="2" stroke-linecap="round" d="M15.5 7.5l1 1"/></svg>
                </button>
            </div>
            <div class="mb-3">
                <textarea id="description" name="description" class="form-control" rows="2" readonly>${user.description}</textarea>
            </div>
            <div class="mb-3 d-flex align-items-center">
                <label class="form-label flex-grow-1">Gender</label>
                <button type="button" class="btn btn-link p-0 ms-2 edit-icon-btn" onclick="enableEdit(this, 'gender')" title="Edit">
                    <svg xmlns="http://www.w3.org/2000/svg" width="1.5em" height="1.5em" fill="none" viewBox="0 0 24 24"><path stroke="#7c3aed" stroke-width="2" d="M16.475 5.408a2.2 2.2 0 0 1 3.112 3.112l-9.1 9.1a2 2 0 0 1-.707.44l-3.2 1.067a.5.5 0 0 1-.633-.633l1.067-3.2a2 2 0 0 1 .44-.707l9.1-9.1Z"/><path stroke="#7c3aed" stroke-width="2" stroke-linecap="round" d="M15.5 7.5l1 1"/></svg>
                </button>
            </div>
            <div class="mb-3">
                <input type="text" id="gender" name="gender" class="form-control" value="${user.gender}" readonly>
            </div>
            <div class="mb-3 d-flex align-items-center">
                <label class="form-label flex-grow-1">Location</label>
                <span id="location-status" style="margin-left:8px;"></span>
                <button type="button" class="btn btn-link p-0 ms-2 edit-icon-btn" onclick="enableEdit(this, 'location')" title="Edit">
                    <svg xmlns="http://www.w3.org/2000/svg" width="1.5em" height="1.5em" fill="none" viewBox="0 0 24 24"><path stroke="#7c3aed" stroke-width="2" d="M16.475 5.408a2.2 2.2 0 0 1 3.112 3.112l-9.1 9.1a2 2 0 0 1-.707.44l-3.2 1.067a.5.5 0 0 1-.633-.633l1.067-3.2a2 2 0 0 1 .44-.707l9.1-9.1Z"/><path stroke="#7c3aed" stroke-width="2" stroke-linecap="round" d="M15.5 7.5l1 1"/></svg>
                </button>
            </div>
            <div class="mb-3">
                <input type="text" id="location" name="location" class="form-control" value="${user.location}" readonly oninput="checkLocationValid()">
            </div>
            <div class="mb-3 d-flex align-items-center">
                <label class="form-label flex-grow-1">Date of Birth</label>
                <button type="button" class="btn btn-link p-0 ms-2 edit-icon-btn" onclick="enableEdit(this, 'dateOfBirth')" title="Edit">
                    <svg xmlns="http://www.w3.org/2000/svg" width="1.5em" height="1.5em" fill="none" viewBox="0 0 24 24"><path stroke="#7c3aed" stroke-width="2" d="M16.475 5.408a2.2 2.2 0 0 1 3.112 3.112l-9.1 9.1a2 2 0 0 1-.707.44l-3.2 1.067a.5.5 0 0 1-.633-.633l1.067-3.2a2 2 0 0 1 .44-.707l9.1-9.1Z"/><path stroke="#7c3aed" stroke-width="2" stroke-linecap="round" d="M15.5 7.5l1 1"/></svg>
                </button>
            </div>
            <div class="mb-3">
                <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-control" value="${user.dateOfBirth}" readonly required onkeydown="return false;">
            </div>
            <div class="mb-3 d-flex align-items-center">
                <label class="form-label flex-grow-1">Password</label>
                <button type="button" class="btn btn-link p-0 ms-2 edit-icon-btn" onclick="enableEdit(this, 'password')" title="Edit">
                    <svg xmlns="http://www.w3.org/2000/svg" width="1.5em" height="1.5em" fill="none" viewBox="0 0 24 24"><path stroke="#7c3aed" stroke-width="2" d="M16.475 5.408a2.2 2.2 0 0 1 3.112 3.112l-9.1 9.1a2 2 0 0 1-.707.44l-3.2 1.067a.5.5 0 0 1-.633-.633l1.067-3.2a2 2 0 0 1 .44-.707l9.1-9.1Z"/><path stroke="#7c3aed" stroke-width="2" stroke-linecap="round" d="M15.5 7.5l1 1"/></svg>
                </button>
            </div>
            <div class="mb-3">
                <input type="password" id="password" name="password" class="form-control" value="${user.password}" readonly required>
            </div>
            <!-- Các trường không cho chỉnh sửa đưa xuống cuối -->
            <div class="mb-3">
                <label class="form-label">User ID</label>
                <input type="text" class="form-control" value="${user.id}" readonly>
            </div>
            <div class="mb-3 d-flex align-items-center">
                <label class="form-label flex-grow-1">Email</label>
            </div>
            <div class="mb-3">
                <input type="email" id="email" name="email" class="form-control" value="${user.email}" readonly required>
            </div>
            <div class="mb-3">
                <label class="form-label">Role</label>
                <input type="text" class="form-control" value="${user.role}" readonly>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-primary mt-2">Update</button>
            </div>
        </form>
        <div id="update-message"></div>
        <script>
            function enableEdit(btn, fieldId) {
                var input = document.getElementById(fieldId);
                if (input) {
                    input.removeAttribute('readonly');
                    if (input.type === 'date') {
                        input.onkeydown = null;
                    }
                    input.focus();
                }
                btn.disabled = true;
            }

            let locationDebounceTimeout;
            function checkLocationValid() {
                clearTimeout(locationDebounceTimeout);
                locationDebounceTimeout = setTimeout(() => {
                    var locationInput = document.getElementById('location');
                    var statusSpan = document.getElementById('location-status');
                    var value = locationInput.value;
                    if (!value || locationInput.readOnly) {
                        statusSpan.innerHTML = '';
                        return;
                    }
                    statusSpan.innerHTML = '<span style="color:gray;">Đang kiểm tra...</span>';
                    fetch('SettingsServlet?action=checkLocation&location=' + encodeURIComponent(value))
                        .then(res => {
                            const contentType = res.headers.get('content-type');
                            if (!contentType || !contentType.includes('application/json')) {
                                throw new Error('Response is not JSON');
                            }
                            return res.json();
                        })
                        .then(data => {
                            if (data && data.found === true) {
                                statusSpan.innerHTML = '<span style="color:green;font-size:1.2em;">&#10003;</span>';
                            } else {
                                statusSpan.innerHTML = '<span style="color:red;font-size:1.2em;">&#10007;</span>';
                            }
                        })
                        .catch(() => {
                            statusSpan.innerHTML = '<span style="color:red;">Lỗi!</span>';
                        });
                }, 500);
            }

            function submitSettingsForm(event) {
                event.preventDefault();
                var form = document.getElementById('settingsForm');
                var formData = new FormData(form);
                var params = new URLSearchParams();
                for (const [key, value] of formData.entries()) {
                    params.append(key, value);
                }
                fetch('SettingsServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: params.toString()
                })
                .then(res => res.text())
                .then(html => {
                    // Lấy message từ response (nếu có)
                    var parser = new DOMParser();
                    var doc = parser.parseFromString(html, 'text/html');
                    var msg = doc.querySelector('.alert-info');
                    var updateMsg = document.getElementById('update-message');
                    if (msg) {
                        updateMsg.innerHTML = msg.outerHTML;
                    } else {
                        updateMsg.innerHTML = '<div class="alert alert-info mt-3 text-center">Cập nhật thành công!</div>';
                    }
                })
                .catch(() => {
                    document.getElementById('update-message').innerHTML = '<div class="alert alert-info mt-3 text-center">Cập nhật thất bại!</div>';
                });
                return false;
            }
        </script>
    </div>
</body>
</html> 