<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorconsult.model.Doctor" %>

<%
    Doctor d = (Doctor) session.getAttribute("user");
    if (d == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String name  = d.getFname();
    String lname = d.getLname();

    // ── Replace this block with your real DAO call ──
    // List<Consultation> consultations = ConsultationDAO.getByDoctorId(d.getId());
    // ─────────────────────────────────────────────────
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Previous Consultations – MediCare</title>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
/* ═══════════════════════════════════════
   BASE / RESET
═══════════════════════════════════════ */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

:root {
    --navy:    #0d1b2a;
    --deep:    #112240;
    --teal:    #0abfa3;
    --teal-dk: #089082;
    --gold:    #e8b84b;
    --slate:   #8892b0;
    --light:   #ccd6f6;
    --white:   #e6f1ff;
    --card:    #162032;
    --border:  rgba(10,191,163,.18);
    --radius:  14px;
    --shadow:  0 8px 32px rgba(0,0,0,.35);
}

body {
    font-family: 'DM Sans', sans-serif;
    background: var(--navy);
    color: var(--light);
    min-height: 100vh;
    display: flex;
}

/* ═══════════════════════════════════════
   SIDEBAR  (same as dashboard)
═══════════════════════════════════════ */
.sidebar {
    width: 260px;
    min-height: 100vh;
    background: var(--deep);
    border-right: 1px solid var(--border);
    display: flex;
    flex-direction: column;
    position: fixed;
    top: 0; left: 0; bottom: 0;
    z-index: 100;
}
.sidebar-logo { padding: 28px 24px 20px; border-bottom: 1px solid var(--border); }
.sidebar-logo .brand { font-family:'Playfair Display',serif; font-size:1.45rem; color:var(--teal); }
.sidebar-logo .brand span { color:var(--gold); }
.sidebar-logo .tagline { font-size:.72rem; color:var(--slate); margin-top:3px; letter-spacing:1.5px; text-transform:uppercase; }

.doctor-card {
    margin: 20px 16px;
    background: linear-gradient(135deg,#0abfa322,#e8b84b11);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 18px 16px;
    text-align: center;
}
.avatar {
    width:64px; height:64px; border-radius:50%;
    background: linear-gradient(135deg,var(--teal),var(--gold));
    display:flex; align-items:center; justify-content:center;
    font-size:1.8rem; margin:0 auto 10px;
    box-shadow: 0 0 0 3px var(--deep), 0 0 0 5px var(--teal);
}
.doctor-name { font-family:'Playfair Display',serif; font-size:1rem; color:var(--white); margin-bottom:2px; }
.status-dot {
    display:inline-flex; align-items:center; gap:5px;
    font-size:.72rem; color:#4ade80; margin-top:8px;
}
.status-dot::before {
    content:''; width:7px; height:7px; background:#4ade80; border-radius:50%;
    animation: pulse 2s infinite;
}
@keyframes pulse { 0%,100%{opacity:1} 50%{opacity:.4} }

.nav { padding:8px 12px; flex:1; }
.nav-section-label { font-size:.65rem; text-transform:uppercase; letter-spacing:2px; color:var(--slate); padding:14px 12px 6px; }
.nav-item {
    display:flex; align-items:center; gap:12px;
    padding:11px 14px; border-radius:10px; cursor:pointer;
    transition:all .22s; font-size:.9rem; color:var(--slate);
    text-decoration:none; margin-bottom:2px;
}
.nav-item:hover { background:rgba(10,191,163,.1); color:var(--teal); }
.nav-item.active {
    background:linear-gradient(90deg,rgba(10,191,163,.22),rgba(10,191,163,.06));
    color:var(--teal); font-weight:600; border-left:3px solid var(--teal);
}
.nav-icon { font-size:1.1rem; width:22px; text-align:center; }

.logout-section { padding:16px 12px; border-top:1px solid var(--border); }
.logout-btn {
    display:flex; align-items:center; gap:10px;
    width:100%; padding:11px 14px; border-radius:10px;
    background:rgba(239,68,68,.1); color:#f87171;
    border:1px solid rgba(239,68,68,.2); cursor:pointer;
    font-size:.88rem; font-family:'DM Sans',sans-serif;
    transition:all .22s; text-decoration:none;
}
.logout-btn:hover { background:rgba(239,68,68,.22); }

/* ═══════════════════════════════════════
   MAIN
═══════════════════════════════════════ */
.main {
    margin-left: 260px;
    flex: 1;
    padding: 32px 36px;
    min-height: 100vh;
}

/* Page header */
.page-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 28px;
}
.page-header-left h1 {
    font-family: 'Playfair Display', serif;
    font-size: 1.75rem;
    color: var(--white);
}
.page-header-left p { color:var(--slate); font-size:.88rem; margin-top:4px; }

.back-btn {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: var(--card);
    border: 1px solid var(--border);
    color: var(--teal);
    text-decoration: none;
    padding: 9px 18px;
    border-radius: 10px;
    font-size: .85rem;
    font-weight: 500;
    transition: all .2s;
}
.back-btn:hover { background: rgba(10,191,163,.12); }

/* ═══════════════════════════════════════
   SEARCH BOX
═══════════════════════════════════════ */
.search-panel {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 22px 24px;
    margin-bottom: 24px;
}
.search-panel-title {
    font-size: .8rem;
    text-transform: uppercase;
    letter-spacing: 1.5px;
    color: var(--teal);
    margin-bottom: 16px;
    font-weight: 600;
}
.search-row {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr auto;
    gap: 12px;
    align-items: end;
}
.search-field label {
    display: block;
    font-size: .75rem;
    color: var(--slate);
    margin-bottom: 6px;
    text-transform: uppercase;
    letter-spacing: .8px;
}
.search-field input {
    width: 100%;
    background: var(--deep);
    border: 1px solid var(--border);
    border-radius: 9px;
    padding: 10px 14px;
    color: var(--white);
    font-size: .9rem;
    font-family: 'DM Sans', sans-serif;
    outline: none;
    transition: border-color .2s;
}
.search-field input::placeholder { color: rgba(136,146,176,.5); }
.search-field input:focus { border-color: var(--teal); }

.search-btn {
    background: linear-gradient(135deg, var(--teal), var(--teal-dk));
    color: var(--navy);
    border: none;
    border-radius: 9px;
    padding: 10px 22px;
    font-size: .9rem;
    font-weight: 700;
    cursor: pointer;
    font-family: 'DM Sans', sans-serif;
    transition: opacity .2s;
    white-space: nowrap;
}
.search-btn:hover { opacity: .85; }

.clear-btn {
    background: transparent;
    color: var(--slate);
    border: 1px solid var(--border);
    border-radius: 9px;
    padding: 10px 16px;
    font-size: .85rem;
    cursor: pointer;
    font-family: 'DM Sans', sans-serif;
    transition: all .2s;
    margin-left: 8px;
}
.clear-btn:hover { color: var(--light); border-color: var(--slate); }

.search-actions { display: flex; align-items: center; }

/* Results summary */
.results-info {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 14px;
}
.results-count { font-size:.85rem; color:var(--slate); }
.results-count span { color:var(--teal); font-weight:600; }

/* ═══════════════════════════════════════
   FREE / PAID FOLLOW-UP BADGE
═══════════════════════════════════════ */
.followup-free {
    display: inline-flex; align-items: center; gap: 5px;
    background: rgba(74,222,128,.12);
    color: #4ade80;
    border: 1px solid rgba(74,222,128,.25);
    font-size: .72rem;
    font-weight: 700;
    padding: 3px 10px;
    border-radius: 20px;
    letter-spacing: .4px;
}
.followup-paid {
    display: inline-flex; align-items: center; gap: 5px;
    background: rgba(232,184,75,.12);
    color: var(--gold);
    border: 1px solid rgba(232,184,75,.25);
    font-size: .72rem;
    font-weight: 700;
    padding: 3px 10px;
    border-radius: 20px;
    letter-spacing: .4px;
}

/* ═══════════════════════════════════════
   CONSULTATION TABLE
═══════════════════════════════════════ */
.table-wrap {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    overflow: hidden;
}

table {
    width: 100%;
    border-collapse: collapse;
}
thead {
    background: rgba(10,191,163,.08);
    border-bottom: 1px solid var(--border);
}
thead th {
    padding: 14px 18px;
    text-align: left;
    font-size: .72rem;
    text-transform: uppercase;
    letter-spacing: 1.2px;
    color: var(--teal);
    font-weight: 600;
}
tbody tr {
    border-bottom: 1px solid rgba(255,255,255,.04);
    transition: background .18s;
}
tbody tr:last-child { border-bottom: none; }
tbody tr:hover { background: rgba(10,191,163,.05); }

tbody td {
    padding: 14px 18px;
    font-size: .88rem;
    color: var(--light);
    vertical-align: middle;
}

.patient-cell {
    display: flex;
    align-items: center;
    gap: 12px;
}
.mini-avatar {
    width: 36px; height: 36px;
    border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    font-size: .78rem; font-weight: 700;
    flex-shrink: 0;
    background: rgba(10,191,163,.18);
    color: var(--teal);
}
.patient-name  { font-weight: 500; color: var(--white); font-size: .9rem; }
.patient-phone { font-size: .75rem; color: var(--slate); margin-top: 2px; }

.disease-tag {
    display: inline-block;
    background: rgba(167,139,250,.12);
    color: #a78bfa;
    border: 1px solid rgba(167,139,250,.22);
    border-radius: 20px;
    padding: 3px 11px;
    font-size: .75rem;
    font-weight: 500;
}

.date-col { color: var(--slate); font-size: .82rem; }

.view-btn {
    background: transparent;
    border: 1px solid var(--teal);
    color: var(--teal);
    border-radius: 7px;
    padding: 5px 14px;
    font-size: .78rem;
    cursor: pointer;
    font-family: 'DM Sans', sans-serif;
    transition: all .2s;
    text-decoration: none;
    display: inline-block;
}
.view-btn:hover { background: var(--teal); color: var(--navy); font-weight: 600; }

/* Empty state */
.empty-state {
    text-align: center;
    padding: 60px 20px;
    color: var(--slate);
}
.empty-state .empty-icon { font-size: 3rem; margin-bottom: 14px; opacity: .5; }
.empty-state p { font-size: .95rem; }

/* No results */
.no-results {
    text-align: center;
    padding: 40px 20px;
    color: var(--slate);
    font-size: .9rem;
}

/* ═══════════════════════════════════════
   RESPONSIVE
═══════════════════════════════════════ */
@media (max-width: 1100px) {
    .search-row { grid-template-columns: 1fr 1fr; }
    .search-actions { grid-column: span 2; }
}
@media (max-width: 768px) {
    .sidebar { width: 70px; }
    .sidebar-logo .brand, .sidebar-logo .tagline,
    .doctor-card .doctor-name, .doctor-card .status-dot,
    .nav-item span, .nav-section-label, .logout-btn span { display: none; }
    .main { margin-left: 70px; padding: 20px 16px; }
    .search-row { grid-template-columns: 1fr; }
    .search-actions { grid-column: 1; }
    table { font-size: .8rem; }
    thead th, tbody td { padding: 10px 12px; }
}
</style>
</head>
<body>

<!-- ══════════════════════════════════
     SIDEBAR
══════════════════════════════════ -->
<aside class="sidebar">
    <div class="sidebar-logo">
        <div class="brand">Medi<span>Care</span></div>
        <div class="tagline">Doctor Portal</div>
    </div>

    <div class="doctor-card">
        <div class="avatar">👨‍⚕️</div>
        <div class="doctor-name"><%= name %> <%= lname %></div>
        <div class="status-dot">Available</div>
    </div>

    <nav class="nav">
        <div class="nav-section-label">Main</div>
        <a href="d-dashboard.jsp" class="nav-item">
            <span class="nav-icon">🏠</span><span>Dashboard</span>
        </a>
        <a href="d-previous-consultations.jsp" class="nav-item active">
            <span class="nav-icon">📋</span><span>Previous Consultations</span>
        </a>

        <div class="nav-section-label">Management</div>
        <a href="d_update_profile.html" class="nav-item">
            <span class="nav-icon">⚙️</span><span>Update Profile</span>
        </a>
    </nav>

    <div class="logout-section">
        <a href="index.jsp" class="logout-btn">
            <span>🚪</span><span>Logout</span>
        </a>
    </div>
</aside>

<!-- ══════════════════════════════════
     MAIN CONTENT
══════════════════════════════════ -->
<main class="main">

    <!-- Page Header -->
    <div class="page-header">
        <div class="page-header-left">
            <h1>📋 Previous Consultations</h1>
            <p>All patients you have consulted — search by name, phone or disease</p>
        </div>
        <a href="d-dashboard.jsp" class="back-btn">← Back to Dashboard</a>
    </div>

    <!-- ── SEARCH PANEL ── -->
    <div class="search-panel">
        <div class="search-panel-title">🔍 Search Consultations</div>
        <div class="search-row">
            <div class="search-field">
                <label>Patient Name</label>
                <input type="text" id="searchName" placeholder="e.g. Rahul Kumar" oninput="filterTable()">
            </div>
            <div class="search-field">
                <label>Phone Number</label>
                <input type="text" id="searchPhone" placeholder="e.g. 9876543210" oninput="filterTable()">
            </div>
            <div class="search-field">
                <label>Disease / Condition</label>
                <input type="text" id="searchDisease" placeholder="e.g. Diabetes" oninput="filterTable()">
            </div>
            <div class="search-actions">
                <button class="clear-btn" onclick="clearSearch()">✕ Clear</button>
            </div>
        </div>
    </div>

    <!-- Results Info -->
    <div class="results-info">
        <div class="results-count">Showing <span id="resultCount">0</span> consultation(s)</div>
        <div style="font-size:.78rem; color:var(--slate);">
            🟢 Free Follow-up = within 7 days &nbsp;|&nbsp; 🟡 Paid = after 7 days
        </div>
    </div>

    <!-- ── CONSULTATION TABLE ── -->
    <div class="table-wrap">
        <table id="consultTable">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Patient</th>
                    <th>Disease / Condition</th>
                    <th>Consulted On</th>
                    <th>Follow-up Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="tableBody">

                <%-- ════════════════════════════════════════════════════════
                     BACKEND INTEGRATION POINT
                     ────────────────────────────────────────────────────────
                     Replace the dummy rows below with your real JSTL loop:

                     <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
                     <c:forEach var="c" items="${consultations}" varStatus="s">
                       <tr
                         data-name="${c.patientName}"
                         data-phone="${c.patientPhone}"
                         data-disease="${c.disease}">
                         <td>${s.count}</td>
                         <td>
                           <div class="patient-cell">
                             <div class="mini-avatar">${c.patientName.substring(0,2).toUpperCase()}</div>
                             <div>
                               <div class="patient-name">${c.patientName}</div>
                               <div class="patient-phone">${c.patientPhone}</div>
                             </div>
                           </div>
                         </td>
                         <td><span class="disease-tag">${c.disease}</span></td>
                         <td class="date-col">${c.consultDate}</td>
                         <td id="fu-${s.count}"></td>
                         <td><a href="consultation-detail.jsp?id=${c.id}" class="view-btn">View</a></td>
                       </tr>
                       <script>setFollowUp(${s.count},'${c.consultDate}');</script>
                     </c:forEach>
                ═════════════════════════════════════════════════════════ --%>

                <!-- ── DUMMY DATA (delete when backend is connected) ── -->
                <tr data-name="rahul kumar" data-phone="9876543210" data-disease="common cold">
                    <td>1</td>
                    <td>
                        <div class="patient-cell">
                            <div class="mini-avatar">RK</div>
                            <div>
                                <div class="patient-name">Rahul Kumar</div>
                                <div class="patient-phone">📞 9876543210</div>
                            </div>
                        </div>
                    </td>
                    <td><span class="disease-tag">Common Cold</span></td>
                    <td class="date-col" data-date="2025-03-06">06 Mar 2025</td>
                    <td class="followup-cell"></td>
                    <td><a href="consultation-detail.jsp?id=1" class="view-btn">View</a></td>
                </tr>
                <tr data-name="priya mehta" data-phone="9123456780" data-disease="diabetes">
                    <td>2</td>
                    <td>
                        <div class="patient-cell">
                            <div class="mini-avatar" style="background:rgba(232,184,75,.18);color:var(--gold)">PM</div>
                            <div>
                                <div class="patient-name">Priya Mehta</div>
                                <div class="patient-phone">📞 9123456780</div>
                            </div>
                        </div>
                    </td>
                    <td><span class="disease-tag">Diabetes</span></td>
                    <td class="date-col" data-date="2025-02-20">20 Feb 2025</td>
                    <td class="followup-cell"></td>
                    <td><a href="consultation-detail.jsp?id=2" class="view-btn">View</a></td>
                </tr>
                <tr data-name="anita sharma" data-phone="9988776655" data-disease="hypertension">
                    <td>3</td>
                    <td>
                        <div class="patient-cell">
                            <div class="mini-avatar" style="background:rgba(74,222,128,.15);color:#4ade80">AS</div>
                            <div>
                                <div class="patient-name">Anita Sharma</div>
                                <div class="patient-phone">📞 9988776655</div>
                            </div>
                        </div>
                    </td>
                    <td><span class="disease-tag">Hypertension</span></td>
                    <td class="date-col" data-date="2025-03-07">07 Mar 2025</td>
                    <td class="followup-cell"></td>
                    <td><a href="consultation-detail.jsp?id=3" class="view-btn">View</a></td>
                </tr>
                <tr data-name="vikas gupta" data-phone="9001122334" data-disease="fever">
                    <td>4</td>
                    <td>
                        <div class="patient-cell">
                            <div class="mini-avatar" style="background:rgba(167,139,250,.15);color:#a78bfa">VG</div>
                            <div>
                                <div class="patient-name">Vikas Gupta</div>
                                <div class="patient-phone">📞 9001122334</div>
                            </div>
                        </div>
                    </td>
                    <td><span class="disease-tag">Fever</span></td>
                    <td class="date-col" data-date="2025-02-10">10 Feb 2025</td>
                    <td class="followup-cell"></td>
                    <td><a href="consultation-detail.jsp?id=4" class="view-btn">View</a></td>
                </tr>
                <tr data-name="sunita joshi" data-phone="9871234560" data-disease="migraine">
                    <td>5</td>
                    <td>
                        <div class="patient-cell">
                            <div class="mini-avatar" style="background:rgba(248,113,113,.15);color:#f87171">SJ</div>
                            <div>
                                <div class="patient-name">Sunita Joshi</div>
                                <div class="patient-phone">📞 9871234560</div>
                            </div>
                        </div>
                    </td>
                    <td><span class="disease-tag">Migraine</span></td>
                    <td class="date-col" data-date="2025-03-05">05 Mar 2025</td>
                    <td class="followup-cell"></td>
                    <td><a href="consultation-detail.jsp?id=5" class="view-btn">View</a></td>
                </tr>
                <!-- ── END DUMMY DATA ── -->

            </tbody>
        </table>

        <!-- Empty state (shown when no data at all) -->
        <div class="empty-state" id="emptyState" style="display:none">
            <div class="empty-icon">📭</div>
            <p>No consultations found.</p>
        </div>

        <!-- No results from search -->
        <div class="no-results" id="noResults" style="display:none">
            🔍 No consultations match your search. Try different keywords.
        </div>
    </div>

</main>

<script>
/* ═══════════════════════════════════════════
   FOLLOW-UP STATUS LOGIC
   Free if consulted within last 7 days, else Paid
═══════════════════════════════════════════ */
function computeFollowUp(dateStr) {
    const consultDate = new Date(dateStr);
    const today       = new Date();
    today.setHours(0,0,0,0);
    const diffDays    = Math.floor((today - consultDate) / (1000 * 60 * 60 * 24));
    return diffDays <= 7;
}

function renderFollowUpBadges() {
    document.querySelectorAll('#tableBody tr').forEach(row => {
        const dateCell = row.querySelector('td[data-date]');
        const fuCell   = row.querySelector('.followup-cell');
        if (!dateCell || !fuCell) return;

        const isFree = computeFollowUp(dateCell.dataset.date);
        fuCell.innerHTML = isFree
            ? '<span class="followup-free">🟢 Free Follow-up</span>'
            : '<span class="followup-paid">🟡 Paid</span>';
    });
}

/* ═══════════════════════════════════════════
   LIVE SEARCH / FILTER
═══════════════════════════════════════════ */
function filterTable() {
    const nameQ    = document.getElementById('searchName').value.trim().toLowerCase();
    const phoneQ   = document.getElementById('searchPhone').value.trim().toLowerCase();
    const diseaseQ = document.getElementById('searchDisease').value.trim().toLowerCase();

    const rows = document.querySelectorAll('#tableBody tr');
    let visible = 0;

    rows.forEach(row => {
        const rName    = (row.dataset.name    || '').toLowerCase();
        const rPhone   = (row.dataset.phone   || '').toLowerCase();
        const rDisease = (row.dataset.disease || '').toLowerCase();

        const match =
            (!nameQ    || rName.includes(nameQ))    &&
            (!phoneQ   || rPhone.includes(phoneQ))  &&
            (!diseaseQ || rDisease.includes(diseaseQ));

        row.style.display = match ? '' : 'none';
        if (match) visible++;
    });

    document.getElementById('resultCount').textContent = visible;
    document.getElementById('noResults').style.display  = (visible === 0 && rows.length > 0) ? 'block' : 'none';
    document.getElementById('emptyState').style.display = (rows.length === 0)                 ? 'block' : 'none';
}

function clearSearch() {
    document.getElementById('searchName').value    = '';
    document.getElementById('searchPhone').value   = '';
    document.getElementById('searchDisease').value = '';
    filterTable();
}

/* ═══════════════════════════════════════════
   INIT
═══════════════════════════════════════════ */
window.onload = function () {
    renderFollowUpBadges();
    filterTable();            // sets initial count
};
</script>

</body>
</html>
