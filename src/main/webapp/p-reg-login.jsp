<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Login & Register - MediCare Booking</title>
    <link rel="stylesheet" href="css/p-reg-login.css"/>
</head>
<body>
    <button class="back-btn" onclick="window.history.back()">←</button>
    
    <div class="floating-elements">
        <div class="floating-pill"></div>
        <div class="floating-pill"></div>
        <div class="floating-pill"></div>
    </div>

    <div class="auth-container">
        <div class="side-panel">
            <div class="medical-icon">🏥</div>
            <h2>Welcome to MediCare</h2>
            <p>Your health is our priority. Join thousands of patients who trust us for their healthcare needs. Book appointments, manage your health records, and get the care you deserve.</p>
        </div>

        <div class="form-container">
            <div class="form-wrapper">
                <div class="form-toggle">
                    <button class="toggle-btn active" onclick="switchForm('login')">Login</button>
                    <button class="toggle-btn" onclick="switchForm('register')">Register</button>
                    <div class="toggle-slider" id="toggleSlider"></div>
                </div>

                <!-- Login Form -->
                <form action="patientLoginServlet" method="post" class="auth-form active" id="loginForm">
                    <div class="form-group">
                        <input type="email" id="loginEmail" name="email" placeholder=" " required>
                        <label for="loginEmail">Email Address</label>
                    </div>
                    
                    <div class="form-group">
                        <input type="password" id="loginPassword" name="password" placeholder=" " required>
                        <label for="loginPassword">Password</label>
                        <span class="password-toggle" onclick="togglePassword('loginPassword', this)">👁️</span>
                    </div>

                    <button type="submit" class="submit-btn">Sign In</button>
                    
                    <div class="forgot-password">
                        <a href="#" onclick="alert('Password reset functionality will be implemented')">Forgot Password?</a>
                    </div>
                </form>

                <!-- Register Form -->
                <form  action="patientRegisterServlet" method="post" class="auth-form" id="registerForm">
                    <div class="form-group">
                        <input type="text" id="fullName" name="name" placeholder=" " required>
                        <label for="fullName">Full Name</label>
                    </div>

                    <div class="form-group">
                        <input type="email" id="registerEmail" name="email" placeholder=" " required>
                        <label for="registerEmail">Email Address</label>
                    </div>
                    
                    <div class="form-group">
                        <input type="tel" id="phoneNumber" name="phone" placeholder=" " required>
                        <label for="phoneNumber">Phone Number</label>
                    </div>

                    <div class="form-group">
                        <input type="date" id="dateOfBirth" name="dob" placeholder=" " required>
                        <label for="dateOfBirth">Date of Birth</label>
                    </div>
                    
                    <div class="form-group">
                        <input type="password" id="registerPassword" name="password" placeholder=" " required>
                        <label for="registerPassword">Password</label>
                        <span class="password-toggle" onclick="togglePassword('registerPassword', this)">👁️</span>
                    </div>
                    
                    <div class="form-group">
                        <input type="password" id="confirmPassword" name="conpass" placeholder=" " required>
                        <label for="confirmPassword">Confirm Password</label>
                        <span class="password-toggle" onclick="togglePassword('confirmPassword', this)">👁️</span>
                    </div>

                    <button type="submit" class="submit-btn">Create Account</button>
                </form>
            </div>
        </div>
    </div>
    
    <%
   
	String s = (String)session.getAttribute("success");
    String f = (String) session.getAttribute("fail");

	if(s!=null) {
		%>
		<h3><%= s %></h3>
		<%
	}
	
	if(f!=null) {
		%>
		<h3><%= f %></h3>
		<%
	}

%>

    <script>
        function switchForm(formType) {
            const loginForm = document.getElementById('loginForm');
            const registerForm = document.getElementById('registerForm');
            const toggleSlider = document.getElementById('toggleSlider');
            const toggleBtns = document.querySelectorAll('.toggle-btn');

            // Reset active states
            toggleBtns.forEach(btn => btn.classList.remove('active'));
            loginForm.classList.remove('active');
            registerForm.classList.remove('active');

            if (formType === 'login') {
                loginForm.classList.add('active');
                toggleSlider.classList.remove('register');
                toggleBtns[0].classList.add('active');
            } else {
                registerForm.classList.add('active');
                toggleSlider.classList.add('register');
                toggleBtns[1].classList.add('active');
            }
        }

        // Password toggle functionality
        function togglePassword(fieldId, toggleElement) {
            const passwordField = document.getElementById(fieldId);
            const isPassword = passwordField.type === 'password';
            
            passwordField.type = isPassword ? 'text' : 'password';
            toggleElement.textContent = isPassword ? '🙈' : '👁️';
            
            // Keep the toggle element position fixed
            toggleElement.style.position = 'absolute';
            toggleElement.style.top = '50%';
            toggleElement.style.transform = 'translateY(-50%)';
        }

        /* // Form submission handlers
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const email = document.getElementById('loginEmail').value;
            const password = document.getElementById('loginPassword').value;
            
            // Add your login logic here
            alert(`Login attempt for: ${email}`);
        });

        document.getElementById('registerForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const fullName = document.getElementById('fullName').value;
            const email = document.getElementById('registerEmail').value;
            const phone = document.getElementById('phoneNumber').value;
            const dob = document.getElementById('dateOfBirth').value;
            const password = document.getElementById('registerPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                alert('Passwords do not match!');
                return;
            }
            
            // Add your registration logic here
            alert(`Registration attempt for: ${fullName} (${email})`);
        }); */

        // Add floating label animation
        document.querySelectorAll('input').forEach(input => {
            input.addEventListener('blur', function() {
                if (this.value === '') {
                    this.classList.remove('has-value');
                } else {
                    this.classList.add('has-value');
                }
            });
        });
    </script>
</body>
</html>