<%@page import="com.doctorconsult.model.Patient"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
if (session == null || session.getAttribute("user") == null) {
    response.sendRedirect("index.jsp");
    return;
}

Patient p = (Patient) session.getAttribute("user");
String name = p.getName();
%>

<!DOCTYPE html>
<html>



<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
* {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        
        /* Navigation Bar */
        .navbar {
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 0;
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        
        .nav-container {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
        }
        
        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 24px;
            font-weight: bold;
            color: #667eea;
            text-decoration: none;
        }
        
        .logo-icon {
            font-size: 32px;
        }
        
        /* Search Bar in Center */
        .search-container {
            flex: 1;
            max-width: 500px;
            margin: 0 40px;
        }
        
        .search-form {
            position: relative;
            width: 100%;
        }
        
        .search-input {
            width: 100%;
            padding: 12px 50px 12px 20px;
            border: 2px solid #e0e0e0;
            border-radius: 25px;
            font-size: 15px;
            outline: none;
            transition: all 0.3s;
        }
        
        .search-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .search-btn {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: #667eea;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
        }
        
        .search-btn:hover {
            background: #5568d3;
        }
        
        /* Profile Dropdown */
        .profile-section {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .profile-link {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            color: #333;
            padding: 8px 15px;
            border-radius: 25px;
            transition: background 0.3s;
        }
        
        .profile-link:hover {
            background: #f5f5f5;
        }
        
        .profile-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
            font-weight: bold;
        }
        
        .profile-name {
            font-weight: 600;
            color: #333;
        }
        
        .logout-btn {
            background: #ff4757;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            transition: background 0.3s;
        }
        
        .logout-btn:hover {
            background: #ee5a6f;
        }
        
        /* Main Content */
        .main-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 30px;
        }
        
        .hero-section {
            background: white;
            border-radius: 20px;
            padding: 40px;
            margin-bottom: 40px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .hero-section h1 {
            font-size: 36px;
            margin-bottom: 10px;
        }
        
        .hero-section p {
            font-size: 18px;
            opacity: 0.9;
        }
        
        /* Quick Stats */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .stat-icon {
            font-size: 40px;
            margin-bottom: 10px;
        }
        
        .stat-number {
            font-size: 32px;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        
        /* Services Grid */
        .section-title {
            font-size: 28px;
            color: #333;
            margin-bottom: 25px;
            font-weight: 600;
        }
        
        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .service-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            text-decoration: none;
            color: #333;
            transition: all 0.3s;
            border: 2px solid transparent;
        }
        
        .service-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.2);
            border-color: #667eea;
        }
        
        .service-icon {
            font-size: 50px;
            margin-bottom: 15px;
            display: block;
        }
        
        .service-card h3 {
            font-size: 20px;
            margin-bottom: 12px;
            color: #333;
        }
        
        .service-card p {
            color: #666;
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 15px;
        }
        
        .service-arrow {
            color: #667eea;
            font-weight: bold;
            font-size: 18px;
        }
        
        /* Recent Appointments */
        .appointments-section {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
        }
        
        .appointment-item {
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .appointment-item:last-child {
            border-bottom: none;
        }
        
        .appointment-info h4 {
            color: #333;
            margin-bottom: 5px;
        }
        
        .appointment-info p {
            color: #666;
            font-size: 14px;
        }
        
        .appointment-status {
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }
        
        .status-upcoming {
            background: #e3f2fd;
            color: #1976d2;
        }
        
        .view-all-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 30px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            transition: background 0.3s;
        }
        
        .view-all-btn:hover {
            background: #5568d3;
        }
        </style>
</head>
<body>


	 
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="patientDashboard.jsp" class="logo">
                <span class="logo-icon">🏥</span>
                <span>Doctor's Consultation System</span>
            </a>
            
            <div class="search-container">
                <form action="searchDoctors.jsp" method="GET" class="search-form">
                    <input type="text" name="query" class="search-input" 
                           placeholder="Search doctors by name, specialization, or location...">
                    <button type="submit" class="search-btn">Search</button>
                </form>
            </div>
            
            <div class="profile-section">
                <a href="patientProfile.jsp" class="profile-link">
                    <div class="profile-avatar">
                        
                    </div>
                    <span class="profile-name"></span>
                </a>
                <a href="logout.jsp" class="logout-btn">Logout</a>
            </div>
        </div>
    </nav>
    
    <!-- Main Content -->
    <div class="main-content">
        <!-- Hero Section -->
        <div class="hero-section">
            <h1>Welcome back, <%= name %>!</h1>
            <p>Your health is our priority. Manage your appointments and consultations easily.</p>
        </div>
        
        <!-- Quick Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">📅</div>
                <div class="stat-number">3</div>
                <div class="stat-label">Upcoming Appointments</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">👨‍⚕️</div>
                <div class="stat-number">12</div>
                <div class="stat-label">Total Consultations</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">📄</div>
                <div class="stat-number">8</div>
                <div class="stat-label">Medical Reports</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">💊</div>
                <div class="stat-number">5</div>
                <div class="stat-label">Active Prescriptions</div>
            </div>
        </div>
        
        <!-- Services Section -->
        <h2 class="section-title">Our Services</h2>
        <div class="services-grid">
            <a href="bookAppointment.jsp" class="service-card">
                <span class="service-icon">📅</span>
                <h3>Book Appointment</h3>
                <p>Schedule appointments with your preferred doctors at your convenience</p>
                <span class="service-arrow">→</span>
            </a>
            
            <a href="Patient_online_consultation.html" class="service-card">
                <span class="service-icon">💻</span>
                <h3>Video Consultation</h3>
                <p>Connect with doctors remotely through secure video calls</p>
                <span class="service-arrow">→</span>
            </a>
            
            <a href="offlineConsultation.jsp" class="service-card">
                <span class="service-icon">🏥</span>
                <h3>Offline Consultation</h3>
                <p>Book in-person consultations at our partner clinics</p>
                <span class="service-arrow">→</span>
            </a>
            
            <a href="myAppointments.jsp" class="service-card">
                <span class="service-icon">📋</span>
                <h3>My Appointments</h3>
                <p>View, reschedule, or cancel your existing appointments</p>
                <span class="service-arrow">→</span>
            </a>
            
            <a href="medicalRecords.jsp" class="service-card">
                <span class="service-icon">📄</span>
                <h3>Medical Records</h3>
                <p>Access your complete medical history and reports</p>
                <span class="service-arrow">→</span>
            </a>
            
            <a href="Payment_page.html" class="service-card">
                <span class="service-icon">💳</span>
                <h3>Payments</h3>
                <p>Manage payments and view transaction history</p>
                <span class="service-arrow">→</span>
            </a>
        </div>
        
        <!-- Recent Appointments -->
        <div class="appointments-section">
            <h2 class="section-title">Recent Appointments</h2>
            
            <div class="appointment-item">
                <div class="appointment-info">
                    <h4>Dr. Sarah Johnson - Cardiologist</h4>
                    <p>Tomorrow, 10:00 AM - Video Consultation</p>
                </div>
                <span class="appointment-status status-upcoming">Upcoming</span>
            </div>
            
            <div class="appointment-item">
                <div class="appointment-info">
                    <h4>Dr. Michael Chen - General Physician</h4>
                    <p>Jan 25, 2026, 2:30 PM - Offline Consultation</p>
                </div>
                <span class="appointment-status status-upcoming">Upcoming</span>
            </div>
            
            <div class="appointment-item">
                <div class="appointment-info">
                    <h4>Dr. Emily Davis - Dermatologist</h4>
                    <p>Jan 28, 2026, 11:00 AM - Video Consultation</p>
                </div>
                <span class="appointment-status status-upcoming">Upcoming</span>
            </div>
            
            <a href="myAppointments.jsp" class="view-all-btn">View All Appointments</a>
        </div>
    </div>
    <%
   
	/* Patient p = (Patient) session.getAttribute("user"); */
    

	if(p!=null) {
		%>
		<h3><%= p.getName() %></h3>
		<%
	}

%>
</body>
</html>