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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/page-animations.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    <style>
        body {
            background: #f3f4f6;
            font-family: 'Inter', system-ui, sans-serif;
            font-size: 1.7rem;
        }
        .settings-container {
            max-width: 540px;
            margin: 20px auto 0 auto;
            background: #fff;
            border-radius: 1rem;
            box-shadow: 0 2px 8px 0 rgba(16, 30, 54, 0.08), 0 1.5px 4px 0 rgba(16, 30, 54, 0.04);
            padding: 36px 32px 28px 32px;
            transition: all 0.3s ease;
        }

        /* Loading screen */
        .page-loading {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 4px solid rgba(255, 255, 255, 0.3);
            border-top: 4px solid #ffffff;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
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
            text-decoration: none;
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
        .location-selector {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border-radius: 1rem;
            padding: 2rem;
            border: 2px solid #e2e8f0;
            margin-top: 1rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }
        .location-selector select {
            border-radius: 0.75rem;
            border: 2px solid #e5e7eb;
            font-size: 1.45rem;
            line-height: 1.4;
            padding: 0.8rem 1.2rem;
            background: #fff !important;
            color: #1f2937 !important;
            transition: all 0.3s ease;
            width: 100%;
            display: block;
            box-sizing: border-box;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
            font-weight: 500;
            height: auto;
            min-height: 2.8rem;
        }
        .location-selector select option {
            background: #fff !important;
            color: #1f2937 !important;
            padding: 0.6rem 1rem;
            font-size: 1.4rem;
            line-height: 1.3;
            font-weight: 400;
        }
        .location-selector select:disabled {
            background: #f9fafb !important;
            color: #9ca3af !important;
            cursor: not-allowed;
            border-color: #d1d5db !important;
        }
        .location-selector select:not(:disabled) {
            background: #fff !important;
            color: #1f2937 !important;
        }
        
        /* Mobile optimization */
        @media (max-width: 768px) {
            .location-selector select {
                font-size: 1.4rem;
                padding: 0.7rem 1rem;
                min-height: 2.6rem;
            }
            .location-selector select option {
                font-size: 1.3rem;
                padding: 0.5rem 0.8rem;
            }
        }
        .location-selector select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            background: #f8fafc;
        }
        .location-selector select:disabled {
            background: #f9fafb;
            color: #9ca3af;
            cursor: not-allowed;
            border-color: #d1d5db;
        }
        .location-selector select:hover:not(:disabled) {
            border-color: #cbd5e1;
            background: #f8fafc;
        }
        .location-display {
            transition: opacity 0.3s ease;
        }
        .field-display {
            transition: opacity 0.3s ease;
        }
        .location-selector .btn {
            font-size: 1.5rem;
            padding: 1rem 2rem;
            border-radius: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            border-width: 2px;
            min-width: 140px;
        }
        .location-selector .btn svg {
            vertical-align: middle;
        }
        .location-selector .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        .location-selector .btn:active {
            transform: translateY(0);
        }
    </style>
</head>
<body>
    <!-- Loading Screen -->
    <div class="page-loading" id="loadingScreen">
        <div class="loading-spinner"></div>
    </div>

    <!-- Include Navbar -->
    <jsp:include page="includes/navbar.jsp" />

    <div class="settings-container">
        <h2 class="settings-title">User Settings</h2>
        <form action="SettingsServlet" method="post" id="settingsForm" class="settings-form" onsubmit="return submitSettingsForm(event)">
            <div class="mb-3 d-flex align-items-center form-group">
                <label class="form-label flex-grow-1">Full Name</label>
                <button type="button" class="btn btn-link p-0 ms-2 edit-icon-btn" onclick="enableEdit(this, 'fullName')" title="Edit">
                    <svg xmlns="http://www.w3.org/2000/svg" width="1.5em" height="1.5em" fill="none" viewBox="0 0 24 24"><path stroke="#7c3aed" stroke-width="2" d="M16.475 5.408a2.2 2.2 0 0 1 3.112 3.112l-9.1 9.1a2 2 0 0 1-.707.44l-3.2 1.067a.5.5 0 0 1-.633-.633l1.067-3.2a2 2 0 0 1 .44-.707l9.1-9.1Z"/><path stroke="#7c3aed" stroke-width="2" stroke-linecap="round" d="M15.5 7.5l1 1"/></svg>
                </button>
            </div>
            <div class="mb-3 form-group">
                <div class="field-display" id="fullName-display" style="pointer-events: none; opacity: 0.6;">
                    <input type="text" id="fullName" name="fullName" class="form-control" value="${user.fullname}" readonly required>
                </div>
            </div>
            <div class="mb-3 d-flex align-items-center form-group">
                <label class="form-label flex-grow-1">Description</label>
                <button type="button" class="btn btn-link p-0 ms-2 edit-icon-btn" onclick="enableEdit(this, 'description')" title="Edit">
                    <svg xmlns="http://www.w3.org/2000/svg" width="1.5em" height="1.5em" fill="none" viewBox="0 0 24 24"><path stroke="#7c3aed" stroke-width="2" d="M16.475 5.408a2.2 2.2 0 0 1 3.112 3.112l-9.1 9.1a2 2 0 0 1-.707.44l-3.2 1.067a.5.5 0 0 1-.633-.633l1.067-3.2a2 2 0 0 1 .44-.707l9.1-9.1Z"/><path stroke="#7c3aed" stroke-width="2" stroke-linecap="round" d="M15.5 7.5l1 1"/></svg>
                </button>
            </div>
            <div class="mb-3 form-group">
                <div class="field-display" id="description-display" style="pointer-events: none; opacity: 0.6;">
                    <textarea id="description" name="description" class="form-control" rows="2" readonly>${user.description}</textarea>
                </div>
            </div>
            <div class="mb-3 d-flex align-items-center">
                <label class="form-label flex-grow-1">Gender</label>
                <button type="button" class="btn btn-link p-0 ms-2 edit-icon-btn" onclick="enableEdit(this, 'gender')" title="Edit">
                    <svg xmlns="http://www.w3.org/2000/svg" width="1.5em" height="1.5em" fill="none" viewBox="0 0 24 24"><path stroke="#7c3aed" stroke-width="2" d="M16.475 5.408a2.2 2.2 0 0 1 3.112 3.112l-9.1 9.1a2 2 0 0 1-.707.44l-3.2 1.067a.5.5 0 0 1-.633-.633l1.067-3.2a2 2 0 0 1 .44-.707l9.1-9.1Z"/><path stroke="#7c3aed" stroke-width="2" stroke-linecap="round" d="M15.5 7.5l1 1"/></svg>
                </button>
            </div>
            <div class="mb-3">
                <div class="field-display" id="gender-display" style="pointer-events: none; opacity: 0.6;">
                    <input type="text" id="gender" name="gender" class="form-control" value="${user.gender}" readonly>
                </div>
            </div>
            <div class="mb-3 d-flex align-items-center">
                <label class="form-label flex-grow-1">Location</label>
                <button type="button" class="btn btn-link p-0 ms-2 edit-icon-btn" onclick="enableLocationEdit(this)" title="Edit">
                    <svg xmlns="http://www.w3.org/2000/svg" width="1.5em" height="1.5em" fill="none" viewBox="0 0 24 24"><path stroke="#7c3aed" stroke-width="2" d="M16.475 5.408a2.2 2.2 0 0 1 3.112 3.112l-9.1 9.1a2 2 0 0 1-.707.44l-3.2 1.067a.5.5 0 0 1-.633-.633l1.067-3.2a2 2 0 0 1 .44-.707l9.1-9.1Z"/><path stroke="#7c3aed" stroke-width="2" stroke-linecap="round" d="M15.5 7.5l1 1"/></svg>
                </button>
            </div>
            <div class="mb-3" id="location-section">
                <div class="location-display" id="location-display" style="pointer-events: none; opacity: 0.6;">
                    <input type="text" id="location" name="location" class="form-control" value="${user.location}" readonly>
                </div>
                <div class="location-selector" id="location-selector" style="display: none;">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-bold text-dark mb-2">Tỉnh/Thành phố</label>
                            <select id="province-select" class="form-control" disabled>
                                <option value="">Chọn Tỉnh/Thành phố</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold text-dark mb-2">Quận/Huyện</label>
                            <select id="district-select" class="form-control" disabled>
                                <option value="">Chọn Quận/Huyện</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold text-dark mb-2">Phường/Xã</label>
                            <select id="ward-select" class="form-control" disabled>
                                <option value="">Chọn Phường/Xã</option>
                            </select>
                        </div>
                    </div>
                    <div class="row mt-4">
                        <div class="col-12 text-center">
                            <button type="button" class="btn btn-primary me-3 px-4 py-2" onclick="saveLocation()">
                                <svg xmlns="http://www.w3.org/2000/svg" width="1.3em" height="1.3em" fill="none" viewBox="0 0 24 24" style="margin-right: 0.7rem;">
                                    <path stroke="currentColor" stroke-width="2" d="M5 13l4 4L19 7"/>
                                </svg>
                                Lưu địa chỉ
                            </button>
                            <button type="button" class="btn btn-outline-secondary px-4 py-2" onclick="cancelLocationEdit()">
                                <svg xmlns="http://www.w3.org/2000/svg" width="1.3em" height="1.3em" fill="none" viewBox="0 0 24 24" style="margin-right: 0.7rem;">
                                    <path stroke="currentColor" stroke-width="2" d="M18 6L6 18M6 6l12 12"/>
                                </svg>
                                Hủy
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="mb-3 d-flex align-items-center">
                <label class="form-label flex-grow-1">Date of Birth</label>
                <button type="button" class="btn btn-link p-0 ms-2 edit-icon-btn" onclick="enableEdit(this, 'dateOfBirth')" title="Edit">
                    <svg xmlns="http://www.w3.org/2000/svg" width="1.5em" height="1.5em" fill="none" viewBox="0 0 24 24"><path stroke="#7c3aed" stroke-width="2" d="M16.475 5.408a2.2 2.2 0 0 1 3.112 3.112l-9.1 9.1a2 2 0 0 1-.707.44l-3.2 1.067a.5.5 0 0 1-.633-.633l1.067-3.2a2 2 0 0 1 .44-.707l9.1-9.1Z"/><path stroke="#7c3aed" stroke-width="2" stroke-linecap="round" d="M15.5 7.5l1 1"/></svg>
                </button>
            </div>
            <div class="mb-3">
                <div class="field-display" id="dateOfBirth-display" style="pointer-events: none; opacity: 0.6;">
                    <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-control" value="${user.dateOfBirth}" readonly required onkeydown="return false;">
                </div>
            </div>
            <div class="mb-3 d-flex align-items-center">
                <label class="form-label flex-grow-1">Password</label>
                <button type="button" class="btn btn-link p-0 ms-2 edit-icon-btn" onclick="enableEdit(this, 'password')" title="Edit">
                    <svg xmlns="http://www.w3.org/2000/svg" width="1.5em" height="1.5em" fill="none" viewBox="0 0 24 24"><path stroke="#7c3aed" stroke-width="2" d="M16.475 5.408a2.2 2.2 0 0 1 3.112 3.112l-9.1 9.1a2 2 0 0 1-.707.44l-3.2 1.067a.5.5 0 0 1-.633-.633l1.067-3.2a2 2 0 0 1 .44-.707l9.1-9.1Z"/><path stroke="#7c3aed" stroke-width="2" stroke-linecap="round" d="M15.5 7.5l1 1"/></svg>
                </button>
            </div>
            <div class="mb-3">
                <div class="field-display" id="password-display" style="pointer-events: none; opacity: 0.6;">
                    <input type="password" id="password" name="password" class="form-control" value="${user.password}" readonly required>
                </div>
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

        <script src="${pageContext.request.contextPath}/js/page-transitions.js"></script>
        <script>
            function enableEdit(btn, fieldId) {
                var input = document.getElementById(fieldId);
                var fieldDisplay = document.getElementById(fieldId + '-display');
                
                if (input) {
                    input.removeAttribute('readonly');
                    if (input.type === 'date') {
                        input.onkeydown = null;
                    }
                    input.focus();
                }
                
                if (fieldDisplay) {
                    fieldDisplay.style.pointerEvents = 'auto';
                    fieldDisplay.style.opacity = '1';
                }
                
                btn.disabled = true;
            }

            // Location selector functionality
            let provincesData = [];
            let currentProvince = null;
            let currentDistrict = null;
            let currentWard = null;

            function enableLocationEdit(btn) {
                var locationDisplay = document.getElementById('location-display');
                var locationSelector = document.getElementById('location-selector');
                
                console.log('Enabling location edit...');
                
                // Show selector and hide display
                locationDisplay.style.display = 'none';
                locationSelector.style.display = 'block';
                
                // Load provinces data if not loaded
                if (provincesData.length === 0) {
                    loadProvincesData();
                } else {
                    populateProvinces();
                }
                
                btn.disabled = true;
                
                // Debug: check if elements exist
                setTimeout(() => {
                    const provinceSelect = document.getElementById('province-select');
                    const districtSelect = document.getElementById('district-select');
                    const wardSelect = document.getElementById('ward-select');
                    
                    console.log('Province select:', provinceSelect);
                    console.log('District select:', districtSelect);
                    console.log('Ward select:', wardSelect);
                    
                    if (provinceSelect) {
                        console.log('Province select options:', provinceSelect.options.length);
                        console.log('Province select disabled:', provinceSelect.disabled);
                    }
                }, 100);
            }

            function loadProvincesData() {
                console.log('Loading provinces data...');
                fetch('${pageContext.request.contextPath}/js/provinces_districts.json')
                    .then(response => {
                        if (!response.ok) {
                            throw new Error(`HTTP error! status: ${response.status}`);
                        }
                        return response.json();
                    })
                    .then(data => {
                        console.log('Provinces data loaded:', data.length, 'provinces');
                        provincesData = data;
                        populateProvinces();
                    })
                    .catch(error => {
                        console.error('Error loading provinces data:', error);
                        // Fallback: create some sample data for testing
                        provincesData = [
                            {Id: "01", Name: "Thành phố Hà Nội", Districts: []},
                            {Id: "02", Name: "Tỉnh Hà Giang", Districts: []},
                            {Id: "04", Name: "Tỉnh Cao Bằng", Districts: []}
                        ];
                        populateProvinces();
                    });
            }

            function populateProvinces() {
                const provinceSelect = document.getElementById('province-select');
                if (!provinceSelect) {
                    console.error('Province select not found');
                    return;
                }
                
                provinceSelect.innerHTML = '<option value="">Chọn Tỉnh/Thành phố</option>';
                
                if (provincesData && provincesData.length > 0) {
                    provincesData.forEach(province => {
                        const option = document.createElement('option');
                        option.value = province.Id;
                        option.textContent = province.Name;
                        option.style.color = '#1f2937';
                        option.style.background = '#fff';
                        provinceSelect.appendChild(option);
                    });
                } else {
                    console.error('No provinces data available');
                }
                
                provinceSelect.disabled = false;
                console.log('Provinces populated:', provinceSelect.options.length);
            }

            function populateDistricts(provinceId) {
                const districtSelect = document.getElementById('district-select');
                const wardSelect = document.getElementById('ward-select');
                
                // Reset district and ward selects
                districtSelect.innerHTML = '<option value="">Chọn Quận/Huyện</option>';
                wardSelect.innerHTML = '<option value="">Chọn Phường/Xã</option>';
                districtSelect.disabled = true;
                wardSelect.disabled = true;
                
                if (!provinceId) return;
                
                const province = provincesData.find(p => p.Id === provinceId);
                if (province && province.Districts) {
                    province.Districts.forEach(district => {
                        const option = document.createElement('option');
                        option.value = district.Id;
                        option.textContent = district.Name;
                        districtSelect.appendChild(option);
                    });
                    districtSelect.disabled = false;
                }
            }

            function populateWards(districtId) {
                const wardSelect = document.getElementById('ward-select');
                wardSelect.innerHTML = '<option value="">Chọn Phường/Xã</option>';
                
                if (!districtId || !currentProvince) return;
                
                const province = provincesData.find(p => p.Id === currentProvince);
                if (province && province.Districts) {
                    const district = province.Districts.find(d => d.Id === districtId);
                    if (district && district.Wards) {
                        district.Wards.forEach(ward => {
                            const option = document.createElement('option');
                            option.value = ward.Id;
                            option.textContent = ward.Name;
                            wardSelect.appendChild(option);
                        });
                        wardSelect.disabled = false;
                    }
                }
            }

            function updateLocationDisplay() {
                const provinceSelect = document.getElementById('province-select');
                const districtSelect = document.getElementById('district-select');
                const wardSelect = document.getElementById('ward-select');
                const locationInput = document.getElementById('location');
                
                const province = provinceSelect.options[provinceSelect.selectedIndex];
                const district = districtSelect.options[districtSelect.selectedIndex];
                const ward = wardSelect.options[wardSelect.selectedIndex];
                
                let locationText = '';
                if (province && province.value) {
                    locationText = province.textContent;
                    if (district && district.value) {
                        locationText += ', ' + district.textContent;
                        if (ward && ward.value) {
                            locationText += ', ' + ward.textContent;
                        }
                    }
                }
                
                locationInput.value = locationText;
            }

            // Event listeners for location selects
            document.addEventListener('DOMContentLoaded', function() {
                const provinceSelect = document.getElementById('province-select');
                const districtSelect = document.getElementById('district-select');
                const wardSelect = document.getElementById('ward-select');
                
                if (provinceSelect) {
                    provinceSelect.addEventListener('change', function() {
                        currentProvince = this.value;
                        populateDistricts(this.value);
                        updateLocationDisplay();
                    });
                }
                
                if (districtSelect) {
                    districtSelect.addEventListener('change', function() {
                        currentDistrict = this.value;
                        populateWards(this.value);
                        updateLocationDisplay();
                    });
                }
                
                if (wardSelect) {
                    wardSelect.addEventListener('change', function() {
                        currentWard = this.value;
                        updateLocationDisplay();
                    });
                }
            });

            function saveLocation() {
                const locationInput = document.getElementById('location');
                const locationDisplay = document.getElementById('location-display');
                const locationSelector = document.getElementById('location-selector');
                const editButton = document.querySelector('[onclick="enableLocationEdit(this)"]');
                
                // Validate that at least province is selected
                const provinceSelect = document.getElementById('province-select');
                if (!provinceSelect.value) {
                    alert('Vui lòng chọn ít nhất một Tỉnh/Thành phố!');
                    return;
                }
                
                // Show success message
                const updateMsg = document.getElementById('update-message');
                updateMsg.innerHTML = '<div class="alert alert-success mt-3 text-center">Địa chỉ đã được cập nhật thành công!</div>';
                
                // Hide selector and show display
                locationDisplay.style.display = 'block';
                locationSelector.style.display = 'none';
                
                // Re-enable edit button
                editButton.disabled = false;
                
                // Clear the form after a short delay
                setTimeout(() => {
                    updateMsg.innerHTML = '';
                }, 3000);
            }

            function cancelLocationEdit() {
                const locationDisplay = document.getElementById('location-display');
                const locationSelector = document.getElementById('location-selector');
                const editButton = document.querySelector('[onclick="enableLocationEdit(this)"]');
                
                // Reset selects to original state
                const provinceSelect = document.getElementById('province-select');
                const districtSelect = document.getElementById('district-select');
                const wardSelect = document.getElementById('ward-select');
                
                provinceSelect.selectedIndex = 0;
                districtSelect.selectedIndex = 0;
                wardSelect.selectedIndex = 0;
                
                // Reset location input to original value
                const locationInput = document.getElementById('location');
                locationInput.value = '${user.location}';
                
                // Hide selector and show display
                locationDisplay.style.display = 'block';
                locationSelector.style.display = 'none';
                
                // Re-enable edit button
                editButton.disabled = false;
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