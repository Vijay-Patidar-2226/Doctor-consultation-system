<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorconsult.model.Doctor" %>

<%
    Doctor d = (Doctor) session.getAttribute("user");
    if (d == null) { response.sendRedirect("index.jsp"); return; }
    String name = d.getFname();
    String lname = d.getLname();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Follow-Up Requests – Doctor</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
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

        /* ── Sidebar (same as d-dashboard) ── */
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
        .sidebar-logo {
            padding: 28px 24px 20px;
            border-bottom: 1px solid var(--border);
        }
        .sidebar-logo .brand {
            font-family: 'Playfair Display', serif;
            font-size: 1.45rem;
            color: var(--teal);
            letter-spacing: .5px;
        }
        .sidebar-logo .brand span { color: var(--gold); }
        .sidebar-logo .tagline {
            font-size: .72rem;
            color: var(--slate);
            margin-top: 3px;
            letter-spacing: 1.5px;
            text-transform: uppercase;
        }
        .doctor-card {
            margin: 20px 16px;
            background: linear-gradient(135deg, #0abfa322 0%, #e8b84b11 100%);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 18px 16px;
            text-align: center;
        }
        .avatar {
            width: 64px; height: 64px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--teal), var(--gold));
            display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem;
            margin: 0 auto 10px;
            box-shadow: 0 0 0 3px var(--deep), 0 0 0 5px var(--teal);
        }
        .doctor-name {
            font-family: 'Playfair Display', serif;
            font-size: 1rem;
            color: var(--white);
            margin-bottom: 2px;
        }
        .doctor-spec {
            font-size: .75rem;
            color: var(--teal);
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .nav { padding: 8px 12px; flex: 1; }
        .nav-section-label {
            font-size: .65rem;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: var(--slate);
            padding: 14px 12px 6px;
        }
        .nav-item {
            display: flex; align-items: center; gap: 12px;
            padding: 11px 14px;
            border-radius: 10px;
            cursor: pointer;
            transition: all .22s;
            font-size: .9rem;
            color: var(--slate);
            text-decoration: none;
            margin-bottom: 2px;
        }
        .nav-item:hover { background: rgba(10,191,163,.1); color: var(--teal); }
        .nav-item.active {
            background: linear-gradient(90deg, rgba(10,191,163,.22), rgba(10,191,163,.06));
            color: var(--teal);
            font-weight: 600;
            border-left: 3px solid var(--teal);
        }
        .nav-icon { font-size: 1.1rem; width: 22px; text-align: center; }
        .badge {
            margin-left: auto;
            background: var(--teal);
            color: var(--navy);
            font-size: .68rem;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 20px;
        }
        .logout-section {
            padding: 16px 12px;
            border-top: 1px solid var(--border);
        }
        .logout-btn {
            display: flex; align-items: center; gap: 10px;
            width: 100%; padding: 11px 14px;
            border-radius: 10px;
            background: rgba(239,68,68,.1);
            color: #f87171;
            border: 1px solid rgba(239,68,68,.2);
            cursor: pointer;
            font-size: .88rem;
            font-family: 'DM Sans', sans-serif;
            transition: all .22s;
            text-decoration: none;
        }
        .logout-btn:hover { background: rgba(239,68,68,.22); }

        /* ── Main ── */
        .main { margin-left: 260px; flex: 1; padding: 30px 34px; min-height: 100vh; }

        .topbar {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 30px;
        }
        .topbar h1 {
            font-family: 'Playfair Display', serif;
            font-size: 1.75rem;
            color: var(--white);
        }
        .topbar p { color: var(--slate); font-size: .88rem; margin-top: 3px; }

        /* ── Filter tabs ── */
        .tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 26px;
            flex-wrap: wrap;
        }
        .tab {
            padding: 8px 20px;
            border-radius: 20px;
            border: 1px solid var(--border);
            background: var(--card);
            color: var(--slate);
            font-size: .88rem;
            cursor: pointer;
            transition: all .2s;
            font-family: 'DM Sans', sans-serif;
        }
        .tab.active, .tab:hover {
            background: var(--teal);
            color: var(--navy);
            border-color: var(--teal);
            font-weight: 600;
        }

        /* ── Request cards ── */
        .requests-list { display: flex; flex-direction: column; gap: 16px; }

        .req-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 22px 26px;
            display: flex;
            align-items: center;
            gap: 18px;
            transition: box-shadow .2s;
        }
        .req-card:hover { box-shadow: 0 4px 20px rgba(10,191,163,.12); }

        .patient-avatar {
            width: 52px; height: 52px;
            border-radius: 50%;
            background: linear-gradient(135deg, rgba(10,191,163,.3), rgba(232,184,75,.2));
            border: 2px solid var(--teal);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--teal);
            flex-shrink: 0;
            font-family: 'Playfair Display', serif;
        }
        .req-info { flex: 1; min-width: 0; }
        .req-patient-name {
            font-weight: 700;
            color: var(--white);
            font-size: 1rem;
            margin-bottom: 3px;
        }
        .req-meta {
            font-size: .78rem;
            color: var(--slate);
            margin-bottom: 7px;
        }
        .req-reason {
            font-size: .9rem;
            color: var(--light);
        }
        .req-details {
            font-size: .82rem;
            color: var(--slate);
            margin-top: 4px;
            font-style: italic;
        }

        .req-right {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 10px;
            flex-shrink: 0;
        }

        .status-badge {
            padding: 5px 14px;
            border-radius: 20px;
            font-size: .78rem;
            font-weight: 700;
        }
        .s-pending  { background: rgba(245,158,11,.15);  color: #fbbf24; border: 1px solid rgba(245,158,11,.3); }
        .s-accepted { background: rgba(16,185,129,.15);  color: #34d399; border: 1px solid rgba(16,185,129,.3); }
        .s-rejected { background: rgba(239,68,68,.15);   color: #f87171; border: 1px solid rgba(239,68,68,.3); }

        .action-btns { display: flex; gap: 8px; }

        .btn-accept, .btn-reject {
            padding: 8px 18px;
            border-radius: 8px;
            font-size: .84rem;
            font-weight: 600;
            cursor: pointer;
            border: none;
            font-family: 'DM Sans', sans-serif;
            transition: opacity .2s, transform .15s;
        }
        .btn-accept:hover, .btn-reject:hover { opacity: .85; transform: translateY(-1px); }
        .btn-accept { background: var(--teal); color: var(--navy); }
        .btn-reject {
            background: rgba(239,68,68,.15);
            color: #f87171;
            border: 1px solid rgba(239,68,68,.3);
        }

        /* Empty state */
        .empty {
            text-align: center;
            padding: 60px 20px;
            color: var(--slate);
        }
        .empty-icon { font-size: 48px; margin-bottom: 14px; }
        .empty p { font-size: 1rem; }

        /* Confirm modal */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,.65);
            z-index: 500;
            align-items: center;
            justify-content: center;
        }
        .modal-overlay.open { display: flex; }
        .modal {
            background: var(--deep);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 32px 36px;
            max-width: 420px;
            width: 90%;
            text-align: center;
            box-shadow: var(--shadow);
        }
        .modal-icon { font-size: 42px; margin-bottom: 14px; }
        .modal h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.3rem;
            color: var(--white);
            margin-bottom: 10px;
        }
        .modal p { color: var(--slate); font-size: .92rem; margin-bottom: 24px; }
        .modal-btns { display: flex; gap: 12px; justify-content: center; }
        .modal-confirm, .modal-cancel {
            padding: 10px 26px;
            border-radius: 8px;
            font-size: .92rem;
            font-weight: 600;
            cursor: pointer;
            border: none;
            font-family: 'DM Sans', sans-serif;
        }
        .modal-confirm { background: var(--teal); color: var(--navy); }
        .modal-confirm.danger { background: #ef4444; color: white; }
        .modal-cancel {
            background: var(--card);
            color: var(--slate);
            border: 1px solid var(--border);
        }

        /* Toast */
        .toast {
            display: none;
            position: fixed;
            bottom: 28px; right: 28px;
            background: var(--teal);
            color: var(--navy);
            font-weight: 700;
            padding: 14px 22px;
            border-radius: 10px;
            font-size: .95rem;
            box-shadow: 0 6px 20px rgba(0,0,0,0.3);
            z-index: 9999;
            animation: slideUp .35s ease;
        }
        @keyframes slideUp {
            from { transform: translateY(16px); opacity: 0; }
            to   { transform: translateY(0);    opacity: 1; }
        }

        @media(max-width: 768px) {
            .sidebar { display: none; }
            .main { margin-left: 0; padding: 20px 16px; }
            .req-card { flex-direction: column; align-items: flex-start; }
            .req-right { align-items: flex-start; }
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<aside class="sidebar">
    <div class="sidebar-logo">
        <div class="brand">Medi<span>Care</span></div>
        <div class="tagline">Doctor Portal</div>
    </div>

    <div class="doctor-card">
        <div class="avatar">👨‍⚕️</div>
        <div class="doctor-name">Dr. <%= name %> <%= lname %></div>
        <div class="doctor-spec">Physician</div>
    </div>

    <nav class="nav">
        <div class="nav-section-label">Main</div>
        <a href="d-dashboard.jsp" class="nav-item">
            <span class="nav-icon">🏠</span> Dashboard
        </a>
        <a href="d-previous-consultations.jsp" class="nav-item">
            <span class="nav-icon">👥</span> My Patients
        </a>
        <a href="d-followup.jsp" class="nav-item active">
            <span class="nav-icon">📋</span> Follow-Up Requests
            <span class="badge">3</span>
        </a>
        <a href="consultation.jsp" class="nav-item">
            <span class="nav-icon">🩺</span> Consultations
        </a>
        <a href="d-schedule.jsp" class="nav-item">
            <span class="nav-icon">📅</span> Schedule
        </a>
    </nav>

    <div class="logout-section">
        <a href="logout.jsp" class="logout-btn">🚪 Logout</a>
    </div>
</aside>

<!-- Main content -->
<main class="main">
    <div class="topbar">
        <div>
            <h1>📋 Follow-Up Requests</h1>
            <p>Review and respond to patient follow-up requests</p>
        </div>
    </div>

    <!-- Filter tabs -->
    <div class="tabs">
        <button class="tab active" onclick="filterRequests('all', this)">All Requests</button>
        <button class="tab" onclick="filterRequests('pending', this)">⏳ Pending</button>
        <button class="tab" onclick="filterRequests('accepted', this)">✅ Accepted</button>
        <button class="tab" onclick="filterRequests('rejected', this)">❌ Rejected</button>
    </div>

    <!-- Requests list -->
    <div class="requests-list" id="requestsList">

        <%-- 
            TODO: Replace the cards below with a DB loop, e.g.:
            List<FollowUp> requests = FollowUpDAO.getByDoctor(d.getId());
            for (FollowUp f : requests) { ... }
        --%>

        <!-- PENDING -->
        <div class="req-card" data-status="pending">
            <div class="patient-avatar">RK</div>
            <div class="req-info">
                <div class="req-patient-name">Rahul Kumar</div>
                <div class="req-meta">Requested: 11 Mar 2026 &nbsp;·&nbsp; Preferred date: 15 Mar 2026</div>
                <div class="req-reason">🗣 Chest discomfort returning after medication</div>
                <div class="req-details">"The pain has been coming back in the evenings since I started the new prescription."</div>
            </div>
            <div class="req-right">
                <span class="status-badge s-pending">Pending</span>
                <div class="action-btns">
                    <button class="btn-accept" onclick="openModal('accept', 'Rahul Kumar', 1)">✓ Accept</button>
                    <button class="btn-reject" onclick="openModal('reject', 'Rahul Kumar', 1)">✗ Reject</button>
                </div>
            </div>
        </div>

        <div class="req-card" data-status="pending">
            <div class="patient-avatar">PM</div>
            <div class="req-info">
                <div class="req-patient-name">Priya Mehta</div>
                <div class="req-meta">Requested: 10 Mar 2026 &nbsp;·&nbsp; Preferred date: 14 Mar 2026</div>
                <div class="req-reason">🗣 Rash still present after 5 days</div>
                <div class="req-details">"The rash has spread slightly to my neck area."</div>
            </div>
            <div class="req-right">
                <span class="status-badge s-pending">Pending</span>
                <div class="action-btns">
                    <button class="btn-accept" onclick="openModal('accept', 'Priya Mehta', 2)">✓ Accept</button>
                    <button class="btn-reject" onclick="openModal('reject', 'Priya Mehta', 2)">✗ Reject</button>
                </div>
            </div>
        </div>

        <div class="req-card" data-status="pending">
            <div class="patient-avatar">VG</div>
            <div class="req-info">
                <div class="req-patient-name">Vikas Gupta</div>
                <div class="req-meta">Requested: 9 Mar 2026 &nbsp;·&nbsp; Preferred date: 13 Mar 2026</div>
                <div class="req-reason">🗣 Blood pressure readings still high at home</div>
                <div class="req-details">"Morning readings are above 150/95 consistently."</div>
            </div>
            <div class="req-right">
                <span class="status-badge s-pending">Pending</span>
                <div class="action-btns">
                    <button class="btn-accept" onclick="openModal('accept', 'Vikas Gupta', 3)">✓ Accept</button>
                    <button class="btn-reject" onclick="openModal('reject', 'Vikas Gupta', 3)">✗ Reject</button>
                </div>
            </div>
        </div>

        <!-- ACCEPTED example -->
        <div class="req-card" data-status="accepted">
            <div class="patient-avatar">AS</div>
            <div class="req-info">
                <div class="req-patient-name">Anita Sharma</div>
                <div class="req-meta">Requested: 5 Mar 2026 &nbsp;·&nbsp; Preferred date: 8 Mar 2026</div>
                <div class="req-reason">🗣 Fever not fully resolved</div>
            </div>
            <div class="req-right">
                <span class="status-badge s-accepted">Accepted</span>
            </div>
        </div>

        <!-- REJECTED example -->
        <div class="req-card" data-status="rejected">
            <div class="patient-avatar">SJ</div>
            <div class="req-info">
                <div class="req-patient-name">Sunita Joshi</div>
                <div class="req-meta">Requested: 3 Mar 2026 &nbsp;·&nbsp; Preferred date: 6 Mar 2026</div>
                <div class="req-reason">🗣 Mild headache – redirected to general checkup</div>
            </div>
            <div class="req-right">
                <span class="status-badge s-rejected">Rejected</span>
            </div>
        </div>

    </div><!-- /.requests-list -->

</main>

<!-- Confirm Modal -->
<div class="modal-overlay" id="modalOverlay">
    <div class="modal">
        <div class="modal-icon" id="modalIcon">✅</div>
        <h3 id="modalTitle">Confirm Action</h3>
        <p id="modalMsg">Are you sure?</p>
        <div class="modal-btns">
            <button class="modal-confirm" id="modalConfirmBtn" onclick="confirmAction()">Confirm</button>
            <button class="modal-cancel" onclick="closeModal()">Cancel</button>
        </div>
    </div>
</div>

<!-- Toast -->
<div class="toast" id="toast"></div>

<script>
    let pendingAction = null;
    let pendingId = null;

    function openModal(action, patientName, id) {
        pendingAction = action;
        pendingId = id;
        const overlay = document.getElementById('modalOverlay');
        const icon  = document.getElementById('modalIcon');
        const title = document.getElementById('modalTitle');
        const msg   = document.getElementById('modalMsg');
        const btn   = document.getElementById('modalConfirmBtn');

        if (action === 'accept') {
            icon.textContent  = '✅';
            title.textContent = 'Accept Follow-Up';
            msg.textContent   = `Accept the follow-up request from ${patientName}?`;
            btn.textContent   = 'Accept';
            btn.className     = 'modal-confirm';
        } else {
            icon.textContent  = '❌';
            title.textContent = 'Reject Follow-Up';
            msg.textContent   = `Reject the follow-up request from ${patientName}?`;
            btn.textContent   = 'Reject';
            btn.className     = 'modal-confirm danger';
        }
        overlay.classList.add('open');
    }

    function closeModal() {
        document.getElementById('modalOverlay').classList.remove('open');
        pendingAction = null;
        pendingId = null;
    }

    function confirmAction() {
        const action = pendingAction;
        const id     = pendingId;
        closeModal();

        // TODO: POST to server → fetch('updateFollowUp', { method:'POST', body: new URLSearchParams({id, action}) })

        const cards = document.querySelectorAll('.req-card');
        const idx   = id - 1;

        if (action === 'accept') {
            // Update badge & remove buttons, then redirect to video consultation
            if (cards[idx]) {
                const right = cards[idx].querySelector('.req-right');
                right.querySelector('.status-badge').textContent = 'Accepted';
                right.querySelector('.status-badge').className   = 'status-badge s-accepted';
                cards[idx].dataset.status = 'accepted';
                const btns = right.querySelector('.action-btns');
                if (btns) btns.remove();
            }
            showToast('✅ Follow-up accepted! Opening consultation...');
            setTimeout(() => {
                window.location.href = 'doctor_online_consultation.jsp';
            }, 1200);

        } else {
            // Mark as rejected, stay on page
            if (cards[idx]) {
                const right = cards[idx].querySelector('.req-right');
                right.querySelector('.status-badge').textContent = 'Rejected';
                right.querySelector('.status-badge').className   = 'status-badge s-rejected';
                cards[idx].dataset.status = 'rejected';
                const btns = right.querySelector('.action-btns');
                if (btns) btns.remove();
            }
            showToast('❌ Follow-up rejected.');
        }
    }

    function filterRequests(status, tabEl) {
        document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
        tabEl.classList.add('active');

        document.querySelectorAll('.req-card').forEach(card => {
            card.style.display = (status === 'all' || card.dataset.status === status) ? 'flex' : 'none';
        });
    }

    function showToast(msg) {
        const t = document.getElementById('toast');
        t.textContent = msg;
        t.style.display = 'block';
        setTimeout(() => t.style.display = 'none', 3500);
    }

    // Close modal on overlay click
    document.getElementById('modalOverlay').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });
</script>

</body>
</html>
