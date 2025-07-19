<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Reset Password</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Login.css" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
                position: relative;
                overflow-x: hidden;
            }

            .container {
                display: flex;
                justify-content: center;
                align-items: center;
                width: 100%;
                height: 100vh;
            }

            body::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="50" cy="10" r="0.5" fill="rgba(255,255,255,0.1)"/><circle cx="10" cy="60" r="0.5" fill="rgba(255,255,255,0.1)"/><circle cx="90" cy="40" r="0.5" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
                pointer-events: none;
            }

            .reset-password-container {
                max-width: 450px;
                width: 100%;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 24px;
                box-shadow: 
                    0 20px 40px rgba(0, 0, 0, 0.1),
                    0 8px 16px rgba(0, 0, 0, 0.05),
                    inset 0 1px 0 rgba(255, 255, 255, 0.8);
                padding: 48px 40px;
                position: relative;
                animation: slideUp 0.6s ease-out;
                border: 1px solid rgba(255, 255, 255, 0.2);
                display: flex;
                flex-direction: column;
                align-items: center;
                text-align: center;
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .form-title {
                text-align: center;
                margin-bottom: 40px;
                color: #1a202c;
                font-size: 32px;
                font-weight: 700;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                position: relative;
            }

            .form-title::after {
                content: '';
                position: absolute;
                bottom: -12px;
                left: 50%;
                transform: translateX(-50%);
                width: 60px;
                height: 4px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 2px;
            }

            .form-group {
                margin-bottom: 28px;
                position: relative;
                width: 100%;
                max-width: 350px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #4a5568;
                font-weight: 500;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .form-control {
                width: 100%;
                padding: 16px 20px;
                border: 2px solid #e2e8f0;
                border-radius: 12px;
                font-size: 16px;
                font-family: 'Inter', sans-serif;
                background: rgba(255, 255, 255, 0.9);
                transition: all 0.3s ease;
                position: relative;
            }

            .form-control:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                background: rgba(255, 255, 255, 1);
                transform: translateY(-2px);
            }

            .form-control::placeholder {
                color: #a0aec0;
                font-weight: 400;
            }

            .btn-primary {
                width: 100%;
                max-width: 350px;
                padding: 16px 24px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none;
                border-radius: 12px;
                color: white;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
                font-family: 'Inter', sans-serif;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .btn-primary::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                transition: left 0.5s;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
            }

            .btn-primary:hover::before {
                left: 100%;
            }

            .btn-primary:active {
                transform: translateY(0);
            }

            .back-link {
                text-align: center;
                margin-top: 32px;
                padding-top: 24px;
                border-top: 1px solid #e2e8f0;
                width: 100%;
            }

            .back-link a {
                color: #667eea;
                text-decoration: none;
                font-weight: 500;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .back-link a:hover {
                color: #764ba2;
                transform: translateX(-4px);
            }

            .back-link a::before {
                content: '';
            }

            .alert {
                padding: 16px 20px;
                margin-bottom: 24px;
                border-radius: 12px;
                border: none;
                font-size: 14px;
                font-weight: 500;
                position: relative;
                animation: slideIn 0.4s ease-out;
                backdrop-filter: blur(10px);
            }

            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .alert-success {
                background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
                color: white;
                box-shadow: 0 4px 12px rgba(72, 187, 120, 0.3);
            }

            .alert-danger {
                background: linear-gradient(135deg, #f56565 0%, #e53e3e 100%);
                color: white;
                box-shadow: 0 4px 12px rgba(245, 101, 101, 0.3);
            }

            .alert-info {
                background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%);
                color: white;
                box-shadow: 0 4px 12px rgba(66, 153, 225, 0.3);
            }

            .password-requirements {
                font-size: 12px;
                color: #718096;
                margin-top: 8px;
                padding: 8px 12px;
                background: rgba(102, 126, 234, 0.1);
                border-radius: 8px;
                border-left: 3px solid #667eea;
                font-weight: 400;
            }

            /* Password strength indicator */
            .password-strength {
                margin-top: 8px;
                height: 4px;
                background: #e2e8f0;
                border-radius: 2px;
                overflow: hidden;
            }

            .strength-bar {
                height: 100%;
                width: 0%;
                transition: all 0.3s ease;
                border-radius: 2px;
            }

            .strength-weak { background: linear-gradient(90deg, #f56565, #e53e3e); }
            .strength-medium { background: linear-gradient(90deg, #ed8936, #dd6b20); }
            .strength-strong { background: linear-gradient(90deg, #48bb78, #38a169); }

            /* Floating particles animation */
            .particles {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                overflow: hidden;
                pointer-events: none;
            }

            .particle {
                position: absolute;
                width: 4px;
                height: 4px;
                background: rgba(255, 255, 255, 0.6);
                border-radius: 50%;
                animation: float 6s ease-in-out infinite;
            }

            .particle:nth-child(1) { left: 10%; animation-delay: 0s; }
            .particle:nth-child(2) { left: 20%; animation-delay: 2s; }
            .particle:nth-child(3) { left: 30%; animation-delay: 4s; }
            .particle:nth-child(4) { left: 70%; animation-delay: 1s; }
            .particle:nth-child(5) { left: 80%; animation-delay: 3s; }
            .particle:nth-child(6) { left: 90%; animation-delay: 5s; }

            @keyframes float {
                0%, 100% {
                    transform: translateY(100vh) scale(0);
                    opacity: 0;
                }
                10% {
                    opacity: 1;
                }
                90% {
                    opacity: 1;
                }
                100% {
                    transform: translateY(-100px) scale(1);
                    opacity: 0;
                }
            }

            /* Responsive design */
            @media (max-width: 480px) {
                .reset-password-container {
                    padding: 32px 24px;
                    margin: 20px;
                }
                
                .form-title {
                    font-size: 28px;
                }
                
                .form-control {
                    padding: 14px 16px;
                }
                
                .btn-primary {
                    padding: 14px 20px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Floating particles -->
        <div class="particles">
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
        </div>

        <div class="container">
            <div class="reset-password-container">
                <h2 class="form-title">Reset Password</h2>
                
                <div id="successAlert" class="alert alert-success" style="display: none;">
                    <span id="successMessage"></span>
                </div>
                
                <div id="errorAlert" class="alert alert-danger" style="display: none;">
                    <span id="errorMessage"></span>
                </div>
                
                <form action="${pageContext.request.contextPath}/ResetPasswordServlet" method="post">
                    <input type="hidden" name="token" value="${param.token}">
                    
                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <input type="password" 
                               class="form-control" 
                               id="newPassword" 
                               name="newPassword" 
                               placeholder="Enter new password"
                               required>
                        <div class="password-requirements">
                            Password must be at least 8 characters long
                        </div>
                        <div class="password-strength">
                            <div class="strength-bar" id="strengthBar"></div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" 
                               class="form-control" 
                               id="confirmPassword" 
                               name="confirmPassword" 
                               placeholder="Confirm new password"
                               required>
                    </div>
                    
                    <button type="submit" class="btn-primary">Reset Password</button>
                </form>
                
                <div class="back-link">
                    <a href="${pageContext.request.contextPath}/view/login.jsp">Back to Login</a>
                </div>
            </div>
        </div>
        
        <script>
            const urlParams = new URLSearchParams(window.location.search);
            const success = urlParams.get('success');
            const error = urlParams.get('error');
            const token = urlParams.get('token');
            
            if (success) {
                document.getElementById('successMessage').textContent = decodeURIComponent(success);
                document.getElementById('successAlert').style.display = 'block';
            }
            
            if (error) {
                document.getElementById('errorMessage').textContent = decodeURIComponent(error);
                document.getElementById('errorAlert').style.display = 'block';
            }
            
            // Set token value if available
            if (token) {
                document.querySelector('input[name="token"]').value = token;
            }
            
            // Password strength checker
            function checkPasswordStrength(password) {
                let strength = 0;
                const strengthBar = document.getElementById('strengthBar');
                
                if (password.length >= 8) strength += 25;
                if (password.match(/[a-z]/)) strength += 25;
                if (password.match(/[A-Z]/)) strength += 25;
                if (password.match(/[0-9]/)) strength += 25;
                
                strengthBar.style.width = strength + '%';
                strengthBar.className = 'strength-bar';
                
                if (strength <= 25) {
                    strengthBar.classList.add('strength-weak');
                } else if (strength <= 50) {
                    strengthBar.classList.add('strength-medium');
                } else {
                    strengthBar.classList.add('strength-strong');
                }
            }
            
            // Password confirmation validation
            document.getElementById('confirmPassword').addEventListener('input', function() {
                const password = document.getElementById('newPassword').value;
                const confirmPassword = this.value;
                
                if (password !== confirmPassword) {
                    this.setCustomValidity('Passwords do not match');
                    this.style.borderColor = '#f56565';
                } else {
                    this.setCustomValidity('');
                    this.style.borderColor = '#48bb78';
                }
            });
            
            document.getElementById('newPassword').addEventListener('input', function() {
                checkPasswordStrength(this.value);
                const confirmPassword = document.getElementById('confirmPassword');
                if (confirmPassword.value) {
                    if (this.value !== confirmPassword.value) {
                        confirmPassword.setCustomValidity('Passwords do not match');
                        confirmPassword.style.borderColor = '#f56565';
                    } else {
                        confirmPassword.setCustomValidity('');
                        confirmPassword.style.borderColor = '#48bb78';
                    }
                }
            });

            // Add input focus effects
            document.querySelectorAll('.form-control').forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'scale(1.02)';
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'scale(1)';
                });
            });
        </script>
    </body>
</html> 