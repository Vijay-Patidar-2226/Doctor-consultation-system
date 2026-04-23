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
<title>Patient Dashboard</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
    min-height: 100vh;
}

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

.logo-icon { font-size: 32px; }

.search-container { flex: 1; max-width: 500px; margin: 0 40px; }
.search-form { position: relative; width: 100%; }

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

.search-btn:hover { background: #5568d3; }

.profile-section { display: flex; align-items: center; gap: 15px; }

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

.profile-link:hover { background: #f5f5f5; }

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

.profile-name { font-weight: 600; color: #333; }

.logout-btn {
    background: #ff4757;
    color: white;
    padding: 10px 20px;
    text-decoration: none;
    border-radius: 25px;
    font-weight: 600;
    transition: background 0.3s;
}

.logout-btn:hover { background: #ee5a6f; }

.main-content { max-width: 1400px; margin: 0 auto; padding: 40px 30px; }

.hero-section {
    border-radius: 20px;
    padding: 40px;
    margin-bottom: 40px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.1);
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
}

.hero-section h1 { font-size: 36px; margin-bottom: 10px; }
.hero-section p { font-size: 18px; opacity: 0.9; }

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

.stat-icon { font-size: 40px; margin-bottom: 10px; }
.stat-number { font-size: 32px; font-weight: bold; color: #667eea; margin-bottom: 5px; }
.stat-label { color: #666; font-size: 14px; }

.section-title { font-size: 28px; color: #333; margin-bottom: 25px; font-weight: 600; }

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

.service-icon { font-size: 50px; margin-bottom: 15px; display: block; }
.service-card h3 { font-size: 20px; margin-bottom: 12px; color: #333; }
.service-card p { color: #666; font-size: 14px; line-height: 1.6; margin-bottom: 15px; }
.service-arrow { color: #667eea; font-weight: bold; font-size: 18px; }

/* ===== DOCTORS SECTION ===== */
.doctors-section { margin-bottom: 50px; }

.doctors-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 25px;
}

.doctor-card {
    background: white;
    border-radius: 18px;
    overflow: hidden;
    box-shadow: 0 4px 15px rgba(0,0,0,0.08);
    transition: all 0.3s ease;
    position: relative;
    cursor: pointer;
}

.doctor-card:hover {
    transform: translateY(-6px);
    box-shadow: 0 12px 30px rgba(102, 126, 234, 0.2);
}

.doctor-card-img-placeholder {
    width: 100%;
    height: 200px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 80px;
    background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);
}

.doctor-card-body { padding: 20px; }

.doctor-card-name { font-size: 18px; font-weight: 700; color: #222; margin-bottom: 8px; }

.doctor-card-category {
    display: inline-block;
    background: #ede9fe;
    color: #6d28d9;
    font-size: 12px;
    font-weight: 600;
    padding: 4px 12px;
    border-radius: 20px;
}

.doctor-card-overlay {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    background: linear-gradient(to top, rgba(102,126,234,0.95) 0%, transparent 100%);
    padding: 40px 20px 20px;
    transform: translateY(100%);
    transition: transform 0.35s ease;
    display: flex;
    justify-content: center;
}

.doctor-card:hover .doctor-card-overlay { transform: translateY(0); }

.view-more-btn {
    background: white;
    color: #667eea;
    border: none;
    padding: 10px 28px;
    border-radius: 25px;
    font-weight: 700;
    font-size: 14px;
    cursor: pointer;
    transition: all 0.2s;
    box-shadow: 0 3px 10px rgba(0,0,0,0.15);
}

.view-more-btn:hover {
    background: #667eea;
    color: white;
    transform: scale(1.05);
}

/* ===== POPUP MODAL ===== */
.modal-overlay {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.55);
    z-index: 9998;
    justify-content: center;
    align-items: center;
    backdrop-filter: blur(3px);
}

.modal-overlay.active {
    display: flex;
    animation: fadeIn 0.25s ease;
}

@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

.modal-box {
    background: white;
    border-radius: 24px;
    width: 680px;
    max-width: 95vw;
    max-height: 90vh;
    overflow-y: auto;
    position: relative;
    box-shadow: 0 20px 60px rgba(0,0,0,0.25);
    animation: slideUp 0.3s ease;
}

@keyframes slideUp {
    from { transform: translateY(40px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
}

.modal-close {
    position: absolute;
    top: 18px;
    right: 18px;
    width: 36px;
    height: 36px;
    background: rgba(255,255,255,0.25);
    border: none;
    border-radius: 50%;
    font-size: 18px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    transition: all 0.2s;
    z-index: 10;
    font-weight: bold;
}

.modal-close:hover {
    background: #ff4757;
    transform: rotate(90deg);
}

.modal-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    padding: 30px;
    border-radius: 24px 24px 0 0;
    display: flex;
    gap: 25px;
    align-items: center;
}

.modal-doctor-img-placeholder {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    border: 4px solid white;
    box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #e0e7ff, #c7d2fe);
    font-size: 50px;
    flex-shrink: 0;
}

.modal-header-info { color: white; }
.modal-header-info h2 { font-size: 24px; font-weight: 700; margin-bottom: 6px; }

.modal-category-badge {
    display: inline-block;
    background: rgba(255,255,255,0.25);
    color: white;
    padding: 4px 14px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 600;
    margin-bottom: 10px;
}

.modal-rating-row {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 14px;
    color: rgba(255,255,255,0.9);
}

.stars { color: #ffd700; letter-spacing: 2px; font-size: 16px; }

.modal-body { padding: 28px 30px; }

.modal-info-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 15px;
    margin-bottom: 22px;
}

.modal-info-item {
    background: #f8f9ff;
    border-radius: 12px;
    padding: 15px 18px;
}

.modal-info-label {
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: 1px;
    color: #999;
    margin-bottom: 5px;
    font-weight: 600;
}

.modal-info-value { font-size: 16px; font-weight: 700; color: #333; }
.modal-info-value.price { color: #22c55e; font-size: 18px; }

.modal-description { color: #555; font-size: 14px; line-height: 1.75; margin-bottom: 24px; }

.reviews-title { font-size: 17px; font-weight: 700; color: #333; margin-bottom: 14px; }

.review-item {
    background: #f9fafb;
    border-radius: 12px;
    padding: 15px 18px;
    margin-bottom: 12px;
    border-left: 3px solid #667eea;
}

.review-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 6px;
}

.review-name { font-weight: 600; color: #333; font-size: 14px; }
.review-stars { color: #ffd700; font-size: 14px; }
.review-text { color: #666; font-size: 13px; line-height: 1.55; }

.modal-book-btn {
    display: block;
    width: 100%;
    margin-top: 24px;
    padding: 15px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border: none;
    border-radius: 14px;
    font-size: 17px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.3s;
    text-align: center;
    text-decoration: none;
    letter-spacing: 0.5px;
}

.modal-book-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 20px rgba(102,126,234,0.4);
}

/* Appointments Section */
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

.appointment-item:last-child { border-bottom: none; }
.appointment-info h4 { color: #333; margin-bottom: 5px; }
.appointment-info p { color: #666; font-size: 14px; }

.appointment-status {
    padding: 6px 15px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 600;
}

.status-upcoming { background: #e3f2fd; color: #1976d2; }

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

.view-all-btn:hover { background: #5568d3; }

/* WhatsApp Floating Button */
.whatsapp-float {
    position: fixed;
    bottom: 30px;
    right: 30px;
    width: 60px;
    height: 60px;
    background-color: #25D366;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 15px rgba(37, 211, 102, 0.5);
    text-decoration: none;
    z-index: 9999;
    transition: all 0.3s ease;
}

.whatsapp-float:hover {
    background-color: #1ebe5d;
    transform: scale(1.12);
    box-shadow: 0 6px 22px rgba(37, 211, 102, 0.7);
}

.whatsapp-float svg { width: 32px; height: 32px; fill: white; }

.whatsapp-tooltip {
    position: absolute;
    right: 70px;
    background: #333;
    color: white;
    padding: 6px 12px;
    border-radius: 8px;
    font-size: 13px;
    white-space: nowrap;
    opacity: 0;
    pointer-events: none;
    transition: opacity 0.3s;
}

.whatsapp-float:hover .whatsapp-tooltip { opacity: 1; }

@media (max-width: 900px) { .doctors-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 580px) {
    .doctors-grid { grid-template-columns: 1fr; }
    .modal-info-grid { grid-template-columns: 1fr; }
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
                <div class="profile-avatar"></div>
                <span class="profile-name"></span>
            </a>
            <a href="logout.jsp" class="logout-btn">Logout</a>
        </div>
    </div>
</nav>

<!-- Main Content -->
<div class="main-content">

    <!-- Hero -->
    <div class="hero-section">
        <h1>Welcome back, <%= name %>!</h1>
        <p>Your health is our priority. Manage your appointments and consultations easily.</p>
    </div>

    <!-- Stats -->
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

    <!-- Services -->
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

    <!-- ===== DOCTORS SECTION ===== -->
    <div class="doctors-section">
        <h2 class="section-title">👨‍⚕️ Our Top Doctors</h2>
        <div class="doctors-grid">

            <div class="doctor-card" onclick="openModal('doc1')">
                <div class="doctor-card-img-placeholder">👩‍⚕️</div>
                <div class="doctor-card-body">
                    <div class="doctor-card-name">Dr. Priya Sharma</div>
                    <div class="doctor-card-category">Cardiologist</div>
                </div>
                <div class="doctor-card-overlay">
                    <button class="view-more-btn">View More</button>
                </div>
            </div>

            <div class="doctor-card" onclick="openModal('doc2')">
                <div class="doctor-card-img-placeholder">👨‍⚕️</div>
                <div class="doctor-card-body">
                    <div class="doctor-card-name">Dr. Rahul Verma</div>
                    <div class="doctor-card-category">Neurologist</div>
                </div>
                <div class="doctor-card-overlay">
                    <button class="view-more-btn">View More</button>
                </div>
            </div>

            <div class="doctor-card" onclick="openModal('doc3')">
                <div class="doctor-card-img-placeholder">👩‍⚕️</div>
                <div class="doctor-card-body">
                    <div class="doctor-card-name">Dr. Anjali Mehta</div>
                    <div class="doctor-card-category">Dermatologist</div>
                </div>
                <div class="doctor-card-overlay">
                    <button class="view-more-btn">View More</button>
                </div>
            </div>

            <div class="doctor-card" onclick="openModal('doc4')">
                <div class="doctor-card-img-placeholder">👨‍⚕️</div>
                <div class="doctor-card-body">
                    <div class="doctor-card-name">Dr. Suresh Gupta</div>
                    <div class="doctor-card-category">Orthopedic</div>
                </div>
                <div class="doctor-card-overlay">
                    <button class="view-more-btn">View More</button>
                </div>
            </div>

            <div class="doctor-card" onclick="openModal('doc5')">
                <div class="doctor-card-img-placeholder">👩‍⚕️</div>
                <div class="doctor-card-body">
                    <div class="doctor-card-name">Dr. Neha Joshi</div>
                    <div class="doctor-card-category">Gynecologist</div>
                </div>
                <div class="doctor-card-overlay">
                    <button class="view-more-btn">View More</button>
                </div>
            </div>

            <div class="doctor-card" onclick="openModal('doc6')">
                <div class="doctor-card-img-placeholder">👨‍⚕️</div>
                <div class="doctor-card-body">
                    <div class="doctor-card-name">Dr. Amit Patel</div>
                    <div class="doctor-card-category">General Physician</div>
                </div>
                <div class="doctor-card-overlay">
                    <button class="view-more-btn">View More</button>
                </div>
            </div>

            <div class="doctor-card" onclick="openModal('doc7')">
                <div class="doctor-card-img-placeholder">👩‍⚕️</div>
                <div class="doctor-card-body">
                    <div class="doctor-card-name">Dr. Sunita Rao</div>
                    <div class="doctor-card-category">Pediatrician</div>
                </div>
                <div class="doctor-card-overlay">
                    <button class="view-more-btn">View More</button>
                </div>
            </div>

            <div class="doctor-card" onclick="openModal('doc8')">
                <div class="doctor-card-img-placeholder">👨‍⚕️</div>
                <div class="doctor-card-body">
                    <div class="doctor-card-name">Dr. Vikram Singh</div>
                    <div class="doctor-card-category">Psychiatrist</div>
                </div>
                <div class="doctor-card-overlay">
                    <button class="view-more-btn">View More</button>
                </div>
            </div>

            <div class="doctor-card" onclick="openModal('doc9')">
                <div class="doctor-card-img-placeholder">👩‍⚕️</div>
                <div class="doctor-card-body">
                    <div class="doctor-card-name">Dr. Kavita Nair</div>
                    <div class="doctor-card-category">Ophthalmologist</div>
                </div>
                <div class="doctor-card-overlay">
                    <button class="view-more-btn">View More</button>
                </div>
            </div>

        </div>
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

<!-- ===== DOCTOR POPUP MODAL ===== -->
<div class="modal-overlay" id="doctorModal" onclick="closeModalOnOverlay(event)">
    <div class="modal-box">
        <button class="modal-close" onclick="closeModal()">&#10005;</button>

        <div class="modal-header">
            <div class="modal-doctor-img-placeholder" id="modal-avatar">👨‍⚕️</div>
            <div class="modal-header-info">
                <h2 id="modal-name">Doctor Name</h2>
                <div class="modal-category-badge" id="modal-category">Category</div><br>
                <div class="modal-rating-row">
                    <span class="stars" id="modal-stars">★★★★★</span>
                    <span id="modal-rating-text">4.8 / 5.0</span>
                </div>
            </div>
        </div>

        <div class="modal-body">
            <div class="modal-info-grid">
                <div class="modal-info-item">
                    <div class="modal-info-label">Experience</div>
                    <div class="modal-info-value" id="modal-experience">—</div>
                </div>
                <div class="modal-info-item">
                    <div class="modal-info-label">Consultation Fee</div>
                    <div class="modal-info-value price" id="modal-price">—</div>
                </div>
                <div class="modal-info-item">
                    <div class="modal-info-label">Specialty</div>
                    <div class="modal-info-value" id="modal-specialty">—</div>
                </div>
                <div class="modal-info-item">
                    <div class="modal-info-label">Available</div>
                    <div class="modal-info-value" id="modal-available">—</div>
                </div>
            </div>

            <p class="modal-description" id="modal-description">—</p>

            <div class="reviews-title">🗣️ Patient Reviews</div>
            <div id="modal-reviews"></div>

            <a href="bookAppointment.jsp" class="modal-book-btn">📅 Book Appointment</a>
        </div>
    </div>
</div>

<!-- WhatsApp Floating Button -->
<a href="https://wa.me/919171164940" target="_blank" class="whatsapp-float">
    <span class="whatsapp-tooltip">Chat on WhatsApp</span>
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
        <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/>
    </svg>
</a>

<%
if(p!=null) { %>
    <span style="display:none;"><%= p.getName() %></span>
<% } %>

<script>
const doctors = {
    doc1: {
        avatar: "👩‍⚕️",
        name: "Dr. Priya Sharma",
        category: "Cardiologist",
        specialty: "Heart & Vascular",
        experience: "14 Years",
        price: "₹800 / visit",
        available: "Mon–Sat, 10AM–5PM",
        rating: 4.9,
        description: "Dr. Priya Sharma is a highly experienced cardiologist specializing in interventional cardiology and heart disease prevention. She completed her MBBS from AIIMS Delhi and MD Cardiology from PGI Chandigarh. She has performed over 2,000 cardiac procedures and is known for her compassionate, patient-first approach.",
        reviews: [
            { name: "Ramesh K.", stars: 5, text: "Excellent doctor! She explained everything very clearly and my heart condition improved significantly after her treatment." },
            { name: "Sunita M.", stars: 5, text: "Very professional and caring. Diagnosis was spot-on and follow-up care was outstanding." }
        ]
    },
    doc2: {
        avatar: "👨‍⚕️",
        name: "Dr. Rahul Verma",
        category: "Neurologist",
        specialty: "Brain & Nervous System",
        experience: "11 Years",
        price: "₹900 / visit",
        available: "Tue–Sat, 9AM–4PM",
        rating: 4.7,
        description: "Dr. Rahul Verma is a skilled neurologist with expertise in epilepsy, migraines, and stroke management. He trained at Bombay Hospital and has published multiple research papers in leading neurology journals. Patients trust him for his methodical and thorough diagnostic approach.",
        reviews: [
            { name: "Anil P.", stars: 5, text: "Dr. Verma correctly diagnosed my migraine condition after years of misdiagnosis. Life-changing!" },
            { name: "Priya L.", stars: 4, text: "Very knowledgeable. The wait time can be long but it is absolutely worth it for the quality of care." }
        ]
    },
    doc3: {
        avatar: "👩‍⚕️",
        name: "Dr. Anjali Mehta",
        category: "Dermatologist",
        specialty: "Skin & Hair Care",
        experience: "9 Years",
        price: "₹600 / visit",
        available: "Mon–Fri, 11AM–6PM",
        rating: 4.8,
        description: "Dr. Anjali Mehta is a certified dermatologist and cosmetologist with a passion for helping patients achieve healthy skin. She specializes in acne treatment, hair loss therapy, and cosmetic dermatology. Her clinic uses the latest laser and light therapy technologies.",
        reviews: [
            { name: "Pooja S.", stars: 5, text: "My skin transformed completely! Dr. Mehta's acne treatment worked wonders where others had failed." },
            { name: "Kiran B.", stars: 5, text: "Friendly, professional, and very updated with new treatments. Highly recommend!" }
        ]
    },
    doc4: {
        avatar: "👨‍⚕️",
        name: "Dr. Suresh Gupta",
        category: "Orthopedic",
        specialty: "Bone & Joint Surgery",
        experience: "18 Years",
        price: "₹750 / visit",
        available: "Mon–Sat, 8AM–3PM",
        rating: 4.9,
        description: "Dr. Suresh Gupta is a senior orthopedic surgeon with 18 years of expertise in joint replacement, sports injuries, and spine surgery. He has performed over 5,000 successful surgeries and is renowned for his minimal-invasive surgical techniques that reduce recovery time significantly.",
        reviews: [
            { name: "Mahesh T.", stars: 5, text: "After my knee replacement surgery by Dr. Gupta, I am walking normally again. He is truly gifted!" },
            { name: "Radha N.", stars: 5, text: "Very experienced and calm surgeon. Pre and post-op care was excellent." }
        ]
    },
    doc5: {
        avatar: "👩‍⚕️",
        name: "Dr. Neha Joshi",
        category: "Gynecologist",
        specialty: "Women's Health",
        experience: "12 Years",
        price: "₹700 / visit",
        available: "Mon–Fri, 10AM–5PM",
        rating: 4.8,
        description: "Dr. Neha Joshi is a compassionate gynecologist and obstetrician dedicated to women's reproductive health. She specializes in high-risk pregnancies, PCOS, endometriosis, and laparoscopic surgeries. Her gentle approach and clear communication make patients feel comfortable and informed.",
        reviews: [
            { name: "Meena R.", stars: 5, text: "Dr. Joshi guided me through a high-risk pregnancy with utmost care. My baby and I are both healthy thanks to her!" },
            { name: "Deepa K.", stars: 5, text: "Best gynecologist I have ever visited. Very thorough and reassuring." }
        ]
    },
    doc6: {
        avatar: "👨‍⚕️",
        name: "Dr. Amit Patel",
        category: "General Physician",
        specialty: "Internal Medicine",
        experience: "8 Years",
        price: "₹400 / visit",
        available: "Mon–Sun, 9AM–8PM",
        rating: 4.6,
        description: "Dr. Amit Patel is a general physician with a holistic approach to patient care. He manages a wide range of conditions including diabetes, hypertension, fever, infections, and lifestyle diseases. He is known for his availability, prompt diagnoses, and affordable consultation fees.",
        reviews: [
            { name: "Vijay D.", stars: 5, text: "Always available and gives ample time to each patient. My go-to doctor for anything health related." },
            { name: "Sarita G.", stars: 4, text: "Very patient and explains everything in simple language. Very affordable too." }
        ]
    },
    doc7: {
        avatar: "👩‍⚕️",
        name: "Dr. Sunita Rao",
        category: "Pediatrician",
        specialty: "Child Health & Development",
        experience: "15 Years",
        price: "₹500 / visit",
        available: "Mon–Sat, 9AM–6PM",
        rating: 4.9,
        description: "Dr. Sunita Rao is a beloved pediatrician with 15 years of experience caring for newborns, infants, and children up to age 18. She specializes in childhood vaccinations, developmental assessments, and managing chronic conditions in children. Parents love her warm, child-friendly consultation style.",
        reviews: [
            { name: "Geeta M.", stars: 5, text: "My kids absolutely love Dr. Sunita! She has a magical way of calming scared children. Best pediatrician in the city!" },
            { name: "Rajesh A.", stars: 5, text: "Extremely knowledgeable and very patient with children. Highly recommended for all parents." }
        ]
    },
    doc8: {
        avatar: "👨‍⚕️",
        name: "Dr. Vikram Singh",
        category: "Psychiatrist",
        specialty: "Mental Health & Therapy",
        experience: "10 Years",
        price: "₹850 / visit",
        available: "Mon–Fri, 11AM–7PM",
        rating: 4.7,
        description: "Dr. Vikram Singh is a compassionate psychiatrist specializing in anxiety disorders, depression, OCD, and stress management. He integrates modern pharmacotherapy with psychotherapy to provide holistic mental health care. He creates a safe, non-judgmental space for his patients to heal and grow.",
        reviews: [
            { name: "Anonymous", stars: 5, text: "Dr. Vikram helped me overcome severe anxiety that was ruining my life. I am forever grateful for his support and expertise." },
            { name: "Nisha P.", stars: 5, text: "Very empathetic and professional. Treatment plan was clear and effective. I noticed improvement within weeks." }
        ]
    },
    doc9: {
        avatar: "👩‍⚕️",
        name: "Dr. Kavita Nair",
        category: "Ophthalmologist",
        specialty: "Eye Care & Surgery",
        experience: "13 Years",
        price: "₹650 / visit",
        available: "Mon–Sat, 10AM–5PM",
        rating: 4.8,
        description: "Dr. Kavita Nair is an expert ophthalmologist with specialization in cataract surgery, LASIK, glaucoma treatment, and diabetic retinopathy. She has restored vision for thousands of patients and is known for her precision, calm demeanor, and use of state-of-the-art surgical equipment.",
        reviews: [
            { name: "Mohan L.", stars: 5, text: "Dr. Kavita performed my cataract surgery perfectly. My vision is crystal clear now — better than it has been in years!" },
            { name: "Lata S.", stars: 5, text: "Very reassuring before surgery and excellent post-op care. Highly skilled doctor." }
        ]
    }
};

function getStars(rating) {
    const full = Math.floor(rating);
    const half = rating % 1 >= 0.5 ? 1 : 0;
    const empty = 5 - full - half;
    return '★'.repeat(full) + (half ? '½' : '') + '☆'.repeat(empty);
}

function openModal(docId) {
    const d = doctors[docId];
    if (!d) return;
    document.getElementById('modal-avatar').textContent = d.avatar;
    document.getElementById('modal-name').textContent = d.name;
    document.getElementById('modal-category').textContent = d.category;
    document.getElementById('modal-stars').textContent = getStars(d.rating);
    document.getElementById('modal-rating-text').textContent = d.rating + ' / 5.0';
    document.getElementById('modal-experience').textContent = d.experience;
    document.getElementById('modal-price').textContent = d.price;
    document.getElementById('modal-specialty').textContent = d.specialty;
    document.getElementById('modal-available').textContent = d.available;
    document.getElementById('modal-description').textContent = d.description;
    document.getElementById('modal-reviews').innerHTML = d.reviews.map(r =>
        '<div class="review-item"><div class="review-top"><span class="review-name">👤 ' + r.name + '</span><span class="review-stars">' + '★'.repeat(r.stars) + '☆'.repeat(5 - r.stars) + '</span></div><div class="review-text">' + r.text + '</div></div>'
    ).join('');
    document.getElementById('doctorModal').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function closeModal() {
    document.getElementById('doctorModal').classList.remove('active');
    document.body.style.overflow = '';
}

function closeModalOnOverlay(event) {
    if (event.target === document.getElementById('doctorModal')) closeModal();
}

document.addEventListener('keydown', function(e) { if (e.key === 'Escape') closeModal(); });
</script>

</body>
</html>
