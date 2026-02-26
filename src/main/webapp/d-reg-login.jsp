<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Portal - Login & Register - MediCare Booking</title>
    <link rel="stylesheet" href="css/d-reg-login.css"/>
</head>
<body>
    <button class="back-btn" onclick="window.history.back()">←</button>
    <div class="professional-badge">👨‍⚕️ Medical Professional</div>
    
    <div class="floating-elements">
        <div class="floating-stethoscope">🩺</div>
        <div class="floating-stethoscope">🩺</div>
        <div class="floating-stethoscope">🩺</div>
    </div>

    <div class="auth-container">
        <div class="side-panel">
            <div class="doctor-icon">👨‍⚕️</div>
            <h2>Doctor Portal</h2>
            <p>Join our network of healthcare professionals. Manage your practice efficiently, connect with patients, and provide quality care through our advanced platform.</p>
        </div>

        <div class="form-container">
            <div class="form-wrapper">
                <div class="form-toggle">
                    <button class="toggle-btn active" onclick="switchForm('login')">Login</button>
                    <button class="toggle-btn" onclick="switchForm('register')">Register</button>
                    <div class="toggle-slider" id="toggleSlider"></div>
                </div>

                <!-- Doctor Login Form -->
                <form class="auth-form active" id="loginForm" method="post" action="DoctorLoginServlet">
                    <div class="form-group">
                        <input type="email" id="loginEmail" name="loginEmail" placeholder=" " required>
                        <label for="loginEmail">Medical Email Address</label>
                    </div>
                    
                    <div class="form-group">
                        <input type="password" id="loginPassword" name="loginPassword" placeholder=" " required>
                        <label for="loginPassword">Password</label>
                        <span class="password-toggle" onclick="togglePassword('loginPassword', this)">👁️</span>
                    </div>

                    <button type="submit" class="submit-btn">Access Portal</button>
                    
                    <div class="forgot-password">
                        <a href="#" onclick="alert('Password reset for medical professionals will be implemented with additional security verification')">Forgot Password?</a>
                    </div>
                </form>

                <!-- Doctor Register Form -->
                <form class="auth-form" id="registerForm" method="post" action="DoctorRegisterServlet">
                    <div class="form-row">
                        <div class="form-group">
                            <input type="text" id="firstName" name="firstName" placeholder=" " required>
                            <label for="firstName">First Name</label>
                        </div>
                        <div class="form-group">
                            <input type="text" id="lastName" name="lastName" placeholder=" " required>
                            <label for="lastName">Last Name</label>
                        </div>
                    </div>

                    <div class="form-group">
                        <input type="email" id="registerEmail" name="registerEmail" placeholder=" " required>
                        <label for="registerEmail">Professional Email</label>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <input type="tel" id="phoneNumber" name="phoneNumber" placeholder=" " required>
                            <label for="phoneNumber">Phone Number</label>
                        </div>
                        <div class="form-group">
                            <input type="text" id="medicalLicense" name="medicalLicense" placeholder=" " required>
                            <label for="medicalLicense">Medical License No.</label>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <select id="specialization" name="specialization" required>
                                <option value="">Select Specialization</option>
                                <option value="general">General Medicine</option>
                                <option value="cardiology">Cardiology</option>
                                <option value="dermatology">Dermatology</option>
                                <option value="neurology">Neurology</option>
                                <option value="orthopedics">Orthopedics</option>
                                <option value="pediatrics">Pediatrics</option>
                                <option value="psychiatry">Psychiatry</option>
                                <option value="gynecology">Gynecology</option>
                                <option value="ent">ENT</option>
                                <option value="ophthalmology">Ophthalmology</option>
                                <option value="dentistry">Dentistry</option>
                                <option value="other">Other</option>
                            </select>
                            <label for="specialization">Medical Specialization</label>
                        </div>
                        <div class="form-group">
                            <input type="number" id="experience" name="experience" placeholder=" " required min="0" max="50">
                            <label for="experience">Years of Experience</label>
                        </div>
                    </div>

                    <div class="form-group">
                        <input type="text" id="hospitalAffiliation" name="hospitalAffiliation" placeholder=" " required>
                        <label for="hospitalAffiliation">Hospital/Clinic Affiliation</label>
                    </div>
                    
                    <div class="form-group">
                        <input type="password" id="registerPassword" name="registerPassword" placeholder=" " required>
                        <label for="registerPassword">Password</label>
                        <span class="password-toggle" onclick="togglePassword('registerPassword', this)">👁️</span>
                    </div>
                    
                    <div class="form-group">
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder=" " required>
                        <label for="confirmPassword">Confirm Password</label>
                        <span class="password-toggle" onclick="togglePassword('confirmPassword', this)">👁️</span>
                    </div>

                    <button type="submit" class="submit-btn">Join Medical Network</button>
                </form>
            </div>
        </div>
    </div>

     <script>
        function switchForm(formType) {
            const loginForm = document.getElementById('loginForm');
            const registerForm = document.getElementById('registerForm');
            const toggleSlider = document.getElementById('toggleSlider');
            const toggleBtns = document.querySelectorAll('.toggle-btn');

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

        function togglePassword(fieldId, toggleElement) {
            const passwordField = document.getElementById(fieldId);
            const isPassword = passwordField.type === 'password';
            
            passwordField.type = isPassword ? 'text' : 'password';
            toggleElement.textContent = isPassword ? '🙈' : '👁️';
            
            toggleElement.style.position = 'absolute';
            toggleElement.style.top = '50%';
            toggleElement.style.transform = 'translateY(-50%)';
        }

        /* document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const email = document.getElementById('loginEmail').value;
            const password = document.getElementById('loginPassword').value;
            
            alert(`Doctor login attempt for: ${email}`);
        });

        document.getElementById('registerForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const firstName = document.getElementById('firstName').value;
            const lastName = document.getElementById('lastName').value;
            const email = document.getElementById('registerEmail').value;
            const phone = document.getElementById('phoneNumber').value;
            const license = document.getElementById('medicalLicense').value;
            const specialization = document.getElementById('specialization').value;
            const experience = document.getElementById('experience').value;
            const hospital = document.getElementById('hospitalAffiliation').value;
            const password = document.getElementById('registerPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                alert('Passwords do not match!');
                return;
            }

            if (!specialization) {
                alert('Please select a medical specialization!');
                return;
            }
            
            alert(`Doctor registration attempt for: Dr. ${firstName} ${lastName} (${specialization})`);
        }); */

        document.getElementById('specialization').addEventListener('change', function() {
            const label = this.nextElementSibling;
            if (this.value) {
                label.style.top = '-10px';
                label.style.fontSize = '0.85rem';
                label.style.color = '#2c5aa0';
                label.style.background = 'white';
                label.style.fontWeight = '700';
                label.style.textTransform = 'uppercase';
                label.style.letterSpacing = '0.5px';
            }
        });

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