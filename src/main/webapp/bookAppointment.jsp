<%@page import="com.doctorconsult.model.Patient"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
if (session == null || session.getAttribute("user") == null) {
    response.sendRedirect("index.jsp");
    return;
}
Patient p = (Patient) session.getAttribute("user");

// Doctor info from URL params (passed when clicking Book from modal)
String doctorName  = request.getParameter("doctorName")  != null ? request.getParameter("doctorName")  : "Dr. Priya Sharma";
String doctorId    = request.getParameter("doctorId")    != null ? request.getParameter("doctorId")    : "1";
String category    = request.getParameter("category")    != null ? request.getParameter("category")    : "Cardiologist";
String price       = request.getParameter("price")       != null ? request.getParameter("price")       : "₹800 / visit";

// Success/error message
String successMsg = (String) session.getAttribute("appointmentSuccess");
String errorMsg   = (String) session.getAttribute("appointmentError");
if (successMsg != null) session.removeAttribute("appointmentSuccess");
if (errorMsg   != null) session.removeAttribute("appointmentError");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Book Appointment</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
    min-height: 100vh;
}

/* Navbar */
.navbar {
    background: white;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    position: sticky;
    top: 0;
    z-index: 100;
}
.nav-container {
    max-width: 1200px;
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
    font-size: 22px;
    font-weight: bold;
    color: #667eea;
    text-decoration: none;
}
.back-btn {
    background: #667eea;
    color: white;
    padding: 10px 22px;
    border-radius: 25px;
    text-decoration: none;
    font-weight: 600;
    font-size: 14px;
    transition: background 0.3s;
}
.back-btn:hover { background: #5568d3; }

/* Page Layout */
.page-wrapper {
    max-width: 900px;
    margin: 40px auto;
    padding: 0 20px 60px;
}

/* Toast Messages */
.toast {
    padding: 14px 22px;
    border-radius: 12px;
    margin-bottom: 22px;
    font-weight: 600;
    font-size: 15px;
}
.toast.success { background: #dcfce7; color: #15803d; border-left: 4px solid #22c55e; }
.toast.error   { background: #fee2e2; color: #dc2626; border-left: 4px solid #ef4444; }

/* Doctor Info Banner */
.doctor-banner {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 20px;
    padding: 28px 32px;
    display: flex;
    align-items: center;
    gap: 22px;
    margin-bottom: 30px;
    color: white;
    box-shadow: 0 8px 25px rgba(102,126,234,0.35);
}
.doctor-avatar {
    width: 72px;
    height: 72px;
    border-radius: 50%;
    background: rgba(255,255,255,0.2);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 40px;
    flex-shrink: 0;
    border: 3px solid rgba(255,255,255,0.5);
}
.doctor-info h2 { font-size: 22px; font-weight: 700; margin-bottom: 5px; }
.doctor-meta { display: flex; gap: 16px; flex-wrap: wrap; margin-top: 8px; }
.meta-badge {
    background: rgba(255,255,255,0.2);
    padding: 4px 14px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 600;
}
.price-badge {
    background: #22c55e;
    padding: 4px 14px;
    border-radius: 20px;
    font-size: 14px;
    font-weight: 700;
}

/* Form Card */
.form-card {
    background: white;
    border-radius: 20px;
    padding: 36px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.08);
}

.form-section-title {
    font-size: 16px;
    font-weight: 700;
    color: #667eea;
    text-transform: uppercase;
    letter-spacing: 1px;
    margin: 28px 0 16px;
    padding-bottom: 8px;
    border-bottom: 2px solid #e8ebff;
    display: flex;
    align-items: center;
    gap: 8px;
}
.form-section-title:first-child { margin-top: 0; }

/* Consultation Type Toggle */
.consult-toggle {
    display: flex;
    background: #f3f4f6;
    border-radius: 12px;
    padding: 5px;
    gap: 5px;
    margin-bottom: 24px;
}
.consult-btn {
    flex: 1;
    padding: 12px;
    border: none;
    border-radius: 9px;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.25s;
    background: transparent;
    color: #666;
}
.consult-btn.active {
    background: #667eea;
    color: white;
    box-shadow: 0 3px 10px rgba(102,126,234,0.35);
}

/* Input Grid */
.form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 18px;
}
.form-group { display: flex; flex-direction: column; gap: 7px; }
.form-group.full { grid-column: 1 / -1; }

label { font-size: 13px; font-weight: 600; color: #444; }
label span { color: #ef4444; }

input[type="text"],
input[type="email"],
input[type="tel"],
input[type="date"],
input[type="time"],
select,
textarea {
    padding: 12px 16px;
    border: 2px solid #e5e7eb;
    border-radius: 10px;
    font-size: 14px;
    font-family: inherit;
    color: #333;
    transition: border-color 0.25s, box-shadow 0.25s;
    background: #fafafa;
    width: 100%;
}

input:focus,
select:focus,
textarea:focus {
    outline: none;
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102,126,234,0.12);
    background: white;
}

input[readonly] {
    background: #f0f4ff;
    color: #667eea;
    font-weight: 600;
    cursor: not-allowed;
}

textarea { resize: vertical; min-height: 100px; }

/* Time Slots */
.time-slots-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 10px;
}
.time-slot-radio { display: none; }
.time-slot-label {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 10px 8px;
    border: 2px solid #e5e7eb;
    border-radius: 10px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s;
    color: #555;
    background: #fafafa;
    text-align: center;
}
.time-slot-radio:checked + .time-slot-label {
    border-color: #667eea;
    background: #667eea;
    color: white;
    box-shadow: 0 3px 10px rgba(102,126,234,0.3);
}
.time-slot-label:hover { border-color: #667eea; color: #667eea; }

/* Online slots */
.online-slot-radio { display: none; }
.online-slot-label {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 10px 8px;
    border: 2px solid #e5e7eb;
    border-radius: 10px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s;
    color: #555;
    background: #fafafa;
    text-align: center;
}
.online-slot-radio:checked + .online-slot-label {
    border-color: #10b981;
    background: #10b981;
    color: white;
    box-shadow: 0 3px 10px rgba(16,185,129,0.3);
}
.online-slot-label:hover { border-color: #10b981; color: #10b981; }

/* Section visibility */
#offlineSection, #onlineSection { display: none; }
#offlineSection.show, #onlineSection.show { display: block; }

/* Submit Btn */
.submit-btn {
    width: 100%;
    margin-top: 28px;
    padding: 16px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border: none;
    border-radius: 14px;
    font-size: 17px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.3s;
    letter-spacing: 0.5px;
}
.submit-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 20px rgba(102,126,234,0.4);
}
.submit-btn:active { transform: translateY(0); }

/* Note box */
.note-box {
    background: #fffbeb;
    border: 1px solid #fde68a;
    border-radius: 10px;
    padding: 12px 16px;
    font-size: 13px;
    color: #92400e;
    margin-top: 16px;
}

@media(max-width: 640px) {
    .form-grid { grid-template-columns: 1fr; }
    .time-slots-grid { grid-template-columns: repeat(3, 1fr); }
    .doctor-banner { flex-direction: column; text-align: center; }
    .doctor-meta { justify-content: center; }
}
</style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
    <div class="nav-container">
        <a href="patientDashboard.jsp" class="logo">🏥 Doctor's Consultation</a>
        <a href="p-dashboard.jsp" class="back-btn">← Back to Dashboard</a>
    </div>
</nav>

<div class="page-wrapper">

    <% if (successMsg != null) { %>
    <div class="toast success">✅ <%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
    <div class="toast error">❌ <%= errorMsg %></div>
    <% } %>

    <!-- Doctor Banner -->
    <div class="doctor-banner">
        <div class="doctor-avatar">👨‍⚕️</div>
        <div class="doctor-info">
            <h2>Book Doctor Appointment</h2>
            <div class="doctor-meta">
                <span class="meta-badge">🩺 </span>
                <span class="price-badge">💰 </span>
            </div>
        </div>
    </div>

    <!-- Form Card -->
    <div class="form-card">
        <form action="BookAppointmentServlet" method="POST">
            <!-- Hidden fields -->
            <input type="hidden" name="doctorId"   >
            <input type="hidden" name="doctorName">
            <input type="hidden" name="category" >
            <input type="hidden" name="price"  >
            <input type="hidden" name="patientId">
            <input type="hidden" name="consultType" id="consultTypeInput" value="offline">

            <!-- STEP 1: Consultation Type -->
            <div class="form-section-title">🏥 Consultation Type</div>
            <div class="consult-toggle">
                <button type="button" class="consult-btn active" id="offlineBtn" onclick="setConsult('offline')">
                    🏥 Offline (In-Person)
                </button>
                <button type="button" class="consult-btn" id="onlineBtn" onclick="setConsult('online')">
                    💻 Online (Video Call)
                </button>
            </div>

            <!-- STEP 2: Patient Details (pre-filled from session) -->
            <div class="form-section-title">👤 Patient Details</div>
            <div class="form-grid">
                <div class="form-group">
                    <label>Full Name <span>*</span></label>
                    <input type="text" name="patientName"  readonly>
                </div>
                <div class="form-group">
                    <label>Email ID <span>*</span></label>
                    <input type="email" name="email"  readonly>
                </div>
                <div class="form-group">
                    <label>Phone Number <span>*</span></label>
                    <input type="tel" name="phone"  readonly>
                </div>
                <div class="form-group">
                    <label>Age <span>*</span></label>
                    <input type="text" name="age"  readonly>
                </div>
                <div class="form-group">
                    <label>Gender</label>
                    <input type="text" name="gender"  readonly>
                </div>
                <div class="form-group">
                    <label>Blood Group</label>
                    <input type="text" name="bloodGroup"  readonly>
                </div>
            </div>

            <!-- STEP 3: Medical Info -->
            <div class="form-section-title">🩺 Medical Information</div>
            <div class="form-grid">
                <div class="form-group full">
                    <label>Chief Complaint / Main Problem <span>*</span></label>
                    <textarea name="chiefComplaint" placeholder="Describe your main health concern or symptoms in detail..." required></textarea>
                </div>
                <div class="form-group">
                    <label>Duration of Problem</label>
                    <select name="duration">
                        <option value="">-- Select Duration --</option>
                        <option>Less than 1 week</option>
                        <option>1–2 Weeks</option>
                        <option>2–4 Weeks</option>
                        <option>1–3 Months</option>
                        <option>3–6 Months</option>
                        <option>More than 6 Months</option>
                        <option>Chronic / Long-term</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Severity</label>
                    <select name="severity">
                        <option value="">-- Select Severity --</option>
                        <option>Mild</option>
                        <option>Moderate</option>
                        <option>Severe</option>
                        <option>Very Severe</option>
                    </select>
                </div>
                <div class="form-group full">
                    <label>Known Allergies (medicines, food, etc.)</label>
                    <input type="text" name="allergies" placeholder="e.g. Penicillin, Peanuts, Dust — or write 'None'">
                </div>
                <div class="form-group full">
                    <label>Current Medications (if any)</label>
                    <input type="text" name="currentMedications" placeholder="e.g. Metformin 500mg, Aspirin 75mg — or write 'None'">
                </div>
                <div class="form-group full">
                    <label>Past Medical History</label>
                    <textarea name="medicalHistory" style="min-height:80px;" placeholder="Any past surgeries, hospitalizations, or chronic conditions (Diabetes, Hypertension, etc.)"></textarea>
                </div>
                <div class="form-group full">
                    <label>Additional Notes for Doctor</label>
                    <textarea name="additionalNotes" style="min-height:70px;" placeholder="Any other information you want the doctor to know..."></textarea>
                </div>
            </div>

            <!-- STEP 4a: Offline Appointment -->
            <div id="offlineSection" class="show">
                <div class="form-section-title">📅 Schedule Offline Visit</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label>Preferred Date <span>*</span></label>
                        <input type="date" name="appointmentDate" id="appointmentDate" min="" required>
                    </div>
                    <div class="form-group">
                        <label>Select Time Slot <span>*</span></label>
                        <!-- shown below as radio tiles -->
                    </div>
                    <div class="form-group full">
                        <div class="time-slots-grid">
                            <% String[] slots = {"9:00 AM","10:00 AM","11:00 AM","12:00 PM","2:00 PM","3:00 PM","4:00 PM","5:00 PM"}; %>
                            <% for (String slot : slots) { %>
                            <input type="radio" name="timeSlot" id="slot_<%= slot.replace(":","").replace(" ","") %>" value="<%= slot %>" class="time-slot-radio">
                            <label for="slot_<%= slot.replace(":","").replace(" ","") %>" class="time-slot-label"><%= slot %></label>
                            <% } %>
                        </div>
                    </div>
                    <div class="form-group full">
                        <label>Clinic / Location Preference</label>
                        <select name="clinicPreference">
                            <option value="">-- Any Available Clinic --</option>
                            <option>City Hospital, MG Road</option>
                            <option>Apollo Clinic, Vijay Nagar</option>
                            <option>Medanta Center, Ring Road</option>
                            <option>AIIMS OPD</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- STEP 4b: Online Appointment -->
            <div id="onlineSection">
                <div class="form-section-title">💻 Schedule Video Consultation</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label>Preferred Date <span>*</span></label>
                        <input type="date" name="onlineDate" id="onlineDate" min="">
                    </div>
                    <div class="form-group full">
                        <label>Select Online Time Slot <span>*</span></label>
                        <div class="time-slots-grid" style="margin-top:8px;">
                            <% String[] onlineSlots = {"8:00 AM","9:00 AM","10:00 AM","11:00 AM","12:00 PM","2:00 PM","4:00 PM","6:00 PM","7:00 PM","8:00 PM"}; %>
                            <% for (String os : onlineSlots) { %>
                            <input type="radio" name="onlineTimeSlot" id="oslot_<%= os.replace(":","").replace(" ","") %>" value="<%= os %>" class="online-slot-radio">
                            <label for="oslot_<%= os.replace(":","").replace(" ","") %>" class="online-slot-label"><%= os %></label>
                            <% } %>
                        </div>
                    </div>
                    
                </div>
                <div class="note-box">
                    📧 At the time of your scheduled appointment you need connect with doctor using our video consultation feature at give time.
                </div>
            </div>

            <!-- Submit -->
            <button type="submit" class="submit-btn">📅 Confirm &amp; Book Appointment</button>
        </form>
    </div>
</div>

<script>
// Set minimum date to today
const today = new Date().toISOString().split('T')[0];
document.getElementById('appointmentDate').min = today;
document.getElementById('onlineDate').min = today;

function setConsult(type) {
    document.getElementById('consultTypeInput').value = type;
    if (type === 'offline') {
        document.getElementById('offlineSection').classList.add('show');
        document.getElementById('onlineSection').classList.remove('show');
        document.getElementById('offlineBtn').classList.add('active');
        document.getElementById('onlineBtn').classList.remove('active');
        // Make offline fields required
        document.getElementById('appointmentDate').required = true;
        document.getElementById('onlineDate').required = false;
    } else {
        document.getElementById('onlineSection').classList.add('show');
        document.getElementById('offlineSection').classList.remove('show');
        document.getElementById('onlineBtn').classList.add('active');
        document.getElementById('offlineBtn').classList.remove('active');
        document.getElementById('onlineDate').required = true;
        document.getElementById('appointmentDate').required = false;
    }
}
// Init
setConsult('offline');
</script>

</body>
</html>
