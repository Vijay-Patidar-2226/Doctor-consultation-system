<%@page import="com.doctorconsult.model.Patient"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Request Follow-Up | Patient</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
    min-height: 100vh;
}

/* ── Navbar (same as p-dashboard) ── */
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
.profile-section { display: flex; align-items: center; gap: 15px; }
.profile-avatar {
    width: 40px; height: 40px;
    border-radius: 50%;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    display: flex; align-items: center; justify-content: center;
    color: white; font-size: 18px; font-weight: bold;
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

/* ── Page content ── */
.main-content { max-width: 850px; margin: 0 auto; padding: 40px 30px; }

.back-link {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    color: #667eea;
    text-decoration: none;
    font-weight: 600;
    margin-bottom: 28px;
    font-size: 15px;
    transition: gap 0.2s;
}
.back-link:hover { gap: 12px; }

.page-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border-radius: 20px;
    padding: 36px 40px;
    margin-bottom: 32px;
    box-shadow: 0 5px 20px rgba(102,126,234,0.3);
}
.page-header h1 { font-size: 30px; margin-bottom: 8px; }
.page-header p { font-size: 16px; opacity: 0.9; }

/* ── Status cards (my requests) ── */
.section-title { font-size: 22px; font-weight: 700; color: #333; margin-bottom: 18px; }

.requests-list { display: flex; flex-direction: column; gap: 16px; margin-bottom: 40px; }

.request-card {
    background: white;
    border-radius: 15px;
    padding: 22px 26px;
    box-shadow: 0 3px 12px rgba(0,0,0,0.08);
    display: flex;
    align-items: center;
    gap: 18px;
}
.request-doc-avatar {
    width: 52px; height: 52px;
    border-radius: 50%;
    background: linear-gradient(135deg, #667eea, #764ba2);
    display: flex; align-items: center; justify-content: center;
    font-size: 22px;
    flex-shrink: 0;
}
.request-info { flex: 1; }
.request-doc-name { font-weight: 700; color: #222; font-size: 16px; margin-bottom: 3px; }
.request-meta { font-size: 13px; color: #888; margin-bottom: 6px; }
.request-reason { font-size: 14px; color: #555; }
.status-badge {
    padding: 6px 16px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 600;
    flex-shrink: 0;
}
.status-pending  { background: #fff7e6; color: #d97706; border: 1px solid #fde68a; }
.status-accepted { background: #ecfdf5; color: #059669; border: 1px solid #6ee7b7; }
.status-rejected { background: #fff1f2; color: #e11d48; border: 1px solid #fda4af; }

.empty-state {
    text-align: center;
    padding: 36px;
    color: #aaa;
    background: white;
    border-radius: 15px;
    font-size: 15px;
}
.empty-state .empty-icon { font-size: 42px; margin-bottom: 10px; }

/* ── New request form ── */
.form-card {
    background: white;
    border-radius: 20px;
    padding: 36px 40px;
    box-shadow: 0 3px 15px rgba(0,0,0,0.08);
}
.form-card h2 { font-size: 22px; color: #333; margin-bottom: 24px; font-weight: 700; }

.form-group { margin-bottom: 22px; }
.form-group label {
    display: block;
    font-weight: 600;
    color: #444;
    margin-bottom: 8px;
    font-size: 15px;
}
.form-group select,
.form-group input,
.form-group textarea {
    width: 100%;
    padding: 13px 16px;
    border: 2px solid #e0e0e0;
    border-radius: 12px;
    font-size: 15px;
    font-family: inherit;
    color: #333;
    outline: none;
    transition: border-color 0.3s, box-shadow 0.3s;
    background: #fafafa;
}
.form-group select:focus,
.form-group input:focus,
.form-group textarea:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
    background: white;
}
.form-group textarea { resize: vertical; min-height: 110px; }

.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }

.submit-btn {
    width: 100%;
    padding: 15px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border: none;
    border-radius: 12px;
    font-size: 16px;
    font-weight: 700;
    cursor: pointer;
    transition: opacity 0.3s, transform 0.2s;
    margin-top: 8px;
}
.submit-btn:hover { opacity: 0.92; transform: translateY(-1px); }
.submit-btn:active { transform: translateY(0); }

/* ── Success toast ── */
.toast {
    display: none;
    position: fixed;
    bottom: 30px; right: 30px;
    background: #059669;
    color: white;
    padding: 16px 24px;
    border-radius: 12px;
    font-weight: 600;
    font-size: 15px;
    box-shadow: 0 6px 20px rgba(0,0,0,0.15);
    z-index: 9999;
    animation: slideUp 0.4s ease;
}
@keyframes slideUp {
    from { transform: translateY(20px); opacity: 0; }
    to   { transform: translateY(0);    opacity: 1; }
}

@media(max-width: 600px) {
    .main-content { padding: 24px 16px; }
    .page-header  { padding: 26px 22px; }
    .form-card    { padding: 24px 18px; }
    .form-row     { grid-template-columns: 1fr; }
    .request-card { flex-direction: column; align-items: flex-start; }
}
</style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
    <div class="nav-container">
        <a href="p-dashboard.jsp" class="logo">
            <span class="logo-icon">🏥</span>
            MediCare
        </a>
        <div class="profile-section">
            <div class="profile-avatar"><%= name.charAt(0) %></div>
            <span class="profile-name"><%= name %></span>
            <a href="logout.jsp" class="logout-btn">Logout</a>
        </div>
    </div>
</nav>

<div class="main-content">

    <!-- Back link -->
    <a href="p-dashboard.jsp" class="back-link">← Back to Dashboard</a>

    <!-- Header -->
    <div class="page-header">
        <h1>📋 Follow-Up Requests</h1>
        <p>Submit a follow-up to your doctor after your consultation</p>
    </div>

    <!-- My existing requests -->
    <div class="section-title">My Follow-Up Requests</div>
    <div class="requests-list">

        <%-- Example requests — replace with DB fetch loop --%>
        <%
        // TODO: fetch follow-up requests for this patient from DB
        // List<FollowUp> requests = FollowUpDAO.getByPatient(p.getId());
        // if (requests.isEmpty()) show empty state, else loop
        boolean hasRequests = false; // replace with: !requests.isEmpty()
        if (!hasRequests) {
        %>
        <div class="empty-state">
            <div class="empty-icon">📭</div>
            You have no follow-up requests yet. Submit one below!
        </div>
        <%
        } else {
            // for (FollowUp f : requests) { %>
            <div class="request-card">
                <div class="request-doc-avatar">👩‍⚕️</div>
                <div class="request-info">
                    <div class="request-doc-name">Dr. Priya Sharma</div>
                    <div class="request-meta">Requested on 10 Mar 2026 &nbsp;·&nbsp; Cardiologist</div>
                    <div class="request-reason">Chest discomfort returning after medication</div>
                </div>
                <span class="status-badge status-pending">Pending</span>
            </div>
            <div class="request-card">
                <div class="request-doc-avatar">👨‍⚕️</div>
                <div class="request-info">
                    <div class="request-doc-name">Dr. Amit Patel</div>
                    <div class="request-meta">Requested on 5 Mar 2026 &nbsp;·&nbsp; General Physician</div>
                    <div class="request-reason">Fever not fully resolved</div>
                </div>
                <span class="status-badge status-accepted">Accepted</span>
            </div>
        <%
            // }
        }
        %>
    </div>

    <!-- New follow-up form -->
    <div class="form-card">
        <h2>➕ New Follow-Up Request</h2>

        <form action="" method="post" onsubmit="handleSubmit(event)">

            <div class="form-group">
                <label>Select Doctor</label>
                <select name="doctorId" required>
                    <option value="" disabled selected>-- Choose your doctor --</option>
                    <option value="1">Dr. Priya Sharma – Cardiologist</option>
                    <option value="2">Dr. Rahul Verma – Neurologist</option>
                    <option value="3">Dr. Anjali Mehta – Dermatologist</option>
                    <option value="4">Dr. Suresh Gupta – Orthopedic</option>
                    <option value="5">Dr. Neha Joshi – Gynecologist</option>
                    <option value="6">Dr. Amit Patel – General Physician</option>
                    <option value="7">Dr. Sunita Rao – Pediatrician</option>
                    <option value="8">Dr. Vikram Singh – Psychiatrist</option>
                    <option value="9">Dr. Kavita Nair – Ophthalmologist</option>
                    <%-- TODO: replace with DB doctor list --%>
                </select>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Consultation Date</label>
                    <input type="date" name="consultationDate" required>
                </div>
                <div class="form-group">
                    <label>Preferred Follow-Up Date</label>
                    <input type="date" name="preferredDate" required>
                </div>
            </div>

            <div class="form-group">
                <label>Reason for Follow-Up</label>
                <input type="text" name="reason" placeholder="e.g. Symptoms not improving" maxlength="150" required>
            </div>

            <div class="form-group">
                <label>Additional Details (optional)</label>
                <textarea name="details" placeholder="Describe what you are experiencing since your last visit..."></textarea>
            </div>

            <button type="submit" class="submit-btn">📤 Submit Follow-Up Request</button>
        </form>
    </div>
</div>

<!-- Toast -->
<div class="toast" id="toast">✅ Follow-up request submitted successfully!</div>

<script>
function handleSubmit(e) {
    // Allow default form POST; show toast on success redirect param
}

// Show toast if ?submitted=1 in URL
const params = new URLSearchParams(window.location.search);
if (params.get('submitted') === '1') {
    const t = document.getElementById('toast');
    t.style.display = 'block';
    setTimeout(() => t.style.display = 'none', 4000);
}

// Set min dates to today
const today = new Date().toISOString().split('T')[0];
document.querySelectorAll('input[type="date"]').forEach(el => el.min = today);
</script>

</body>
</html>
