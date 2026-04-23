<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorconsult.model.Doctor" %>

<%
	Doctor d = (Doctor) session.getAttribute("user");
	
	String name = d.getFname();
	String lname = d.getLname();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard - MediCare</title>
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

        /* ── Sidebar ── */
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
        .status-dot {
            display: inline-flex; align-items: center; gap: 5px;
            font-size: .72rem; color: #4ade80;
            margin-top: 8px;
        }
        .status-dot::before {
            content: '';
            width: 7px; height: 7px;
            background: #4ade80;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0%,100% { opacity: 1; } 50% { opacity: .4; }
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
        .main {
            margin-left: 260px;
            flex: 1;
            padding: 28px 32px;
            min-height: 100vh;
        }

        /* Top bar */
        .topbar {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 32px;
        }
        .topbar-left h1 {
            font-family: 'Playfair Display', serif;
            font-size: 1.75rem;
            color: var(--white);
        }
        .topbar-left p { color: var(--slate); font-size: .88rem; margin-top: 3px; }
        .topbar-right { display: flex; align-items: center; gap: 14px; }
        .icon-btn {
            width: 40px; height: 40px;
            border-radius: 10px;
            background: var(--card);
            border: 1px solid var(--border);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem;
            cursor: pointer;
            position: relative;
            transition: background .2s;
        }
        .icon-btn:hover { background: rgba(10,191,163,.15); }
        .notif-badge {
            position: absolute; top: -4px; right: -4px;
            width: 16px; height: 16px;
            background: var(--gold);
            border-radius: 50%;
            font-size: .6rem;
            color: var(--navy);
            font-weight: 700;
            display: flex; align-items: center; justify-content: center;
        }
        .date-chip {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 8px 14px;
            font-size: .82rem;
            color: var(--slate);
        }

        /* Stats */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 28px;
        }
        .stat-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 22px 20px;
            position: relative;
            overflow: hidden;
            transition: transform .22s, box-shadow .22s;
        }
        .stat-card:hover { transform: translateY(-3px); box-shadow: var(--shadow); }
        .stat-card::before {
            content: '';
            position: absolute; top: 0; left: 0; right: 0;
            height: 3px;
        }
        .stat-card.teal::before  { background: var(--teal); }
        .stat-card.gold::before  { background: var(--gold); }
        .stat-card.purple::before{ background: #a78bfa; }
        .stat-card.red::before   { background: #f87171; }

        .stat-icon {
            font-size: 1.6rem;
            margin-bottom: 12px;
            display: block;
        }
        .stat-value {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            color: var(--white);
            line-height: 1;
        }
        .stat-label {
            font-size: .78rem;
            color: var(--slate);
            margin-top: 4px;
            text-transform: uppercase;
            letter-spacing: .8px;
        }
        .stat-change {
            font-size: .75rem;
            margin-top: 8px;
            display: flex; align-items: center; gap: 4px;
        }
        .stat-change.up   { color: #4ade80; }
        .stat-change.down { color: #f87171; }

        /* Content grid */
        .content-grid {
            display: grid;
            grid-template-columns: 1.4fr 1fr;
            gap: 22px;
            margin-bottom: 22px;
        }

        /* Panels */
        .panel {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            overflow: hidden;
        }
        .panel-header {
            display: flex; align-items: center; justify-content: space-between;
            padding: 18px 22px;
            border-bottom: 1px solid var(--border);
        }
        .panel-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.05rem;
            color: var(--white);
        }
        .panel-action {
            font-size: .78rem;
            color: var(--teal);
            cursor: pointer;
            text-decoration: none;
            transition: opacity .2s;
        }
        .panel-action:hover { opacity: .7; }

        /* Appointments list */
        .appt-list { padding: 8px 0; }
        .appt-item {
            display: flex; align-items: center; gap: 14px;
            padding: 13px 22px;
            border-bottom: 1px solid rgba(255,255,255,.04);
            transition: background .18s;
        }
        .appt-item:last-child { border-bottom: none; }
        .appt-item:hover { background: rgba(10,191,163,.06); }
        .appt-time {
            min-width: 58px;
            font-size: .78rem;
            color: var(--teal);
            font-weight: 600;
            text-align: right;
        }
        .appt-avatar {
            width: 36px; height: 36px;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: .85rem;
            font-weight: 700;
            flex-shrink: 0;
        }
        .appt-info { flex: 1; }
        .appt-name { font-size: .9rem; color: var(--light); font-weight: 500; }
        .appt-type { font-size: .75rem; color: var(--slate); margin-top: 1px; }
        .appt-status {
            font-size: .72rem;
            padding: 3px 10px;
            border-radius: 20px;
            font-weight: 600;
        }
        .s-confirmed  { background: rgba(10,191,163,.15); color: var(--teal); }
        .s-pending    { background: rgba(232,184,75,.15);  color: var(--gold); }
        .s-completed  { background: rgba(74,222,128,.15);  color: #4ade80; }
        .s-cancelled  { background: rgba(248,113,113,.15); color: #f87171; }

        /* Quick actions */
        .quick-actions { padding: 18px 22px; display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .qa-btn {
            background: rgba(255,255,255,.04);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 16px 14px;
            cursor: pointer;
            transition: all .22s;
            text-align: center;
            text-decoration: none;
            display: block;
            color: var(--light);
        }
        .qa-btn:hover { background: rgba(10,191,163,.12); border-color: var(--teal); transform: translateY(-2px); }
        .qa-icon { font-size: 1.5rem; margin-bottom: 7px; }
        .qa-label { font-size: .8rem; font-weight: 500; }

        /* Schedule timeline */
        .schedule-list { padding: 8px 0; }
        .schedule-slot {
            display: flex; align-items: stretch; gap: 0;
            padding: 10px 22px;
        }
        .slot-time-col {
            width: 60px;
            font-size: .75rem;
            color: var(--slate);
            padding-top: 4px;
            flex-shrink: 0;
        }
        .slot-line {
            width: 2px;
            background: var(--border);
            margin: 0 14px;
            position: relative;
            flex-shrink: 0;
        }
        .slot-line::before {
            content: '';
            width: 8px; height: 8px;
            border-radius: 50%;
            background: var(--border);
            position: absolute;
            top: 4px; left: -3px;
        }
        .slot-line.occupied::before { background: var(--teal); box-shadow: 0 0 8px var(--teal); }
        .slot-content { flex: 1; padding-bottom: 14px; }
        .slot-card {
            background: rgba(10,191,163,.08);
            border: 1px solid rgba(10,191,163,.2);
            border-radius: 9px;
            padding: 10px 13px;
        }
        .slot-patient { font-size: .87rem; color: var(--light); font-weight: 500; }
        .slot-detail  { font-size: .75rem; color: var(--slate); margin-top: 2px; }
        .slot-empty {
            font-size: .78rem;
            color: rgba(136,146,176,.4);
            font-style: italic;
            padding-top: 6px;
        }

        /* Bottom row */
        .bottom-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 22px;
        }

        /* Recent prescriptions */
        .rx-item {
            display: flex; align-items: center; gap: 13px;
            padding: 12px 22px;
            border-bottom: 1px solid rgba(255,255,255,.04);
        }
        .rx-item:last-child { border-bottom: none; }
        .rx-icon {
            width: 36px; height: 36px;
            background: rgba(167,139,250,.15);
            border-radius: 9px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1rem;
            flex-shrink: 0;
        }
        .rx-name { font-size: .88rem; color: var(--light); }
        .rx-meta { font-size: .73rem; color: var(--slate); margin-top: 2px; }
        .rx-date { margin-left: auto; font-size: .73rem; color: var(--slate); }

        /* Clinical notes */
        .note-item {
            padding: 14px 22px;
            border-bottom: 1px solid rgba(255,255,255,.04);
        }
        .note-item:last-child { border-bottom: none; }
        .note-patient { font-size: .88rem; color: var(--teal); font-weight: 500; }
        .note-text    { font-size: .8rem; color: var(--slate); margin-top: 4px; line-height: 1.5; }
        .note-date    { font-size: .72rem; color: rgba(136,146,176,.5); margin-top: 6px; }

        /* Profile summary */
        .profile-body { padding: 18px 22px; }
        .profile-row {
            display: flex; justify-content: space-between; align-items: center;
            padding: 9px 0;
            border-bottom: 1px solid rgba(255,255,255,.05);
            font-size: .85rem;
        }
        .profile-row:last-child { border-bottom: none; }
        .profile-key { color: var(--slate); }
        .profile-val { color: var(--light); font-weight: 500; text-align: right; }
        .profile-val.teal { color: var(--teal); }

        .update-btn {
            display: block;
            margin: 14px 22px 18px;
            background: linear-gradient(135deg, var(--teal), var(--teal-dk));
            color: var(--navy);
            text-align: center;
            padding: 10px;
            border-radius: 10px;
            font-weight: 700;
            font-size: .85rem;
            text-decoration: none;
            letter-spacing: .4px;
            transition: opacity .2s;
        }
        .update-btn:hover { opacity: .85; }

        /* Responsive */
        @media (max-width: 1200px) {
            .stats-grid { grid-template-columns: repeat(2,1fr); }
            .content-grid, .bottom-grid { grid-template-columns: 1fr; }
        }
        @media (max-width: 768px) {
            .sidebar { width: 70px; }
            .sidebar-logo .brand, .sidebar-logo .tagline,
            .doctor-card .doctor-name, .doctor-card .doctor-spec,
            .doctor-card .status-dot, .nav-item span, .nav-section-label,
            .logout-btn span { display: none; }
            .main { margin-left: 70px; padding: 20px 16px; }
            .stats-grid { grid-template-columns: 1fr 1fr; }
        }
    </style>
</head>
<body>

<!-- ── SIDEBAR ── -->
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
	        <!-- <div class="nav-section-label">Main</div>
	        <a href="d-dashboard.jsp" class="nav-item active">
	            <span class="nav-icon">🏠</span><span>Dashboard</span>
	        </a>
	        <a href="d-appointments.jsp" class="nav-item">
	            <span class="nav-icon">📅</span><span>Appointments</span>
	            <span class="badge">5</span>
	        </a>
	        <a href="d-consultations.jsp" class="nav-item">
	            <span class="nav-icon">🩺</span><span>Consultations</span>
	        </a>
	        <a href="d-prescriptions.jsp" class="nav-item">
	            <span class="nav-icon">💊</span><span>Prescriptions</span>
	        </a>
	        <a href="d-schedule.jsp" class="nav-item">
	            <span class="nav-icon">🕐</span><span>Schedule</span>
	        </a> -->

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

<!-- ── MAIN CONTENT ── -->
<main class="main">

    <!-- Top bar -->
    <div class="topbar">
        <div class="topbar-left">
            <%-- <h1>Good Morning, <%= fullName %> 👋</h1> --%>
            <p>Here's what's happening with your practice today.</p>
        </div>
        <div class="topbar-right">
            <div class="date-chip" id="liveClock">--:-- --</div>
            <div class="icon-btn" title="Notifications">
                🔔
                <span class="notif-badge">3</span>
            </div>
            <div class="icon-btn" title="Messages">💬</div>
        </div>
    </div>

    <!-- Stats -->
    <div class="stats-grid">
        <div class="stat-card teal">
            <span class="stat-icon">📅</span>
            <div class="stat-value">12</div>
            <div class="stat-label">Today's Appointments</div>
            <div class="stat-change up">▲ 2 more than yesterday</div>
        </div>
        <div class="stat-card gold">
            <span class="stat-icon">⏳</span>
            <div class="stat-value">4</div>
            <div class="stat-label">Pending Consultations</div>
            <div class="stat-change down">▼ 1 from last week</div>
        </div>
        <div class="stat-card purple">
            <span class="stat-icon">👥</span>
            <div class="stat-value">87</div>
            <div class="stat-label">Total Patients</div>
            <div class="stat-change up">▲ 5 new this month</div>
        </div>
        <div class="stat-card red">
            <span class="stat-icon">✅</span>
            <div class="stat-value">143</div>
            <div class="stat-label">Completed Sessions</div>
            <div class="stat-change up">▲ 98% satisfaction</div>
        </div>
    </div>

    <!-- Middle row -->
    <div class="content-grid">

        <!-- Today's Appointments -->
        <div class="panel">
            <div class="panel-header">
                <span class="panel-title">Today's Appointments</span>
                <a href="d-appointments.jsp" class="panel-action">View All →</a>
            </div>
            <div class="appt-list">
                <div class="appt-item">
                    <div class="appt-time">09:00</div>
                    <div class="appt-avatar" style="background:rgba(10,191,163,.2);color:var(--teal)">RK</div>
                    <div class="appt-info">
                        <div class="appt-name">Rahul Kumar</div>
                        <div class="appt-type">General Checkup · 30 min</div>
                    </div>
                    <span class="appt-status s-confirmed">Confirmed</span>
                </div>
                <div class="appt-item">
                    <div class="appt-time">10:00</div>
                    <div class="appt-avatar" style="background:rgba(232,184,75,.2);color:var(--gold)">PM</div>
                    <div class="appt-info">
                        <div class="appt-name">Priya Mehta</div>
                        <div class="appt-type">Follow-up · 20 min</div>
                    </div>
                    <span class="appt-status s-pending">Pending</span>
                </div>
                <div class="appt-item">
                    <div class="appt-time">11:30</div>
                    <div class="appt-avatar" style="background:rgba(74,222,128,.15);color:#4ade80">AS</div>
                    <div class="appt-info">
                        <div class="appt-name">Anita Sharma</div>
                        <div class="appt-type">Consultation · 45 min</div>
                    </div>
                    <span class="appt-status s-confirmed">Confirmed</span>
                </div>
                <div class="appt-item">
                    <div class="appt-time">02:00</div>
                    <div class="appt-avatar" style="background:rgba(167,139,250,.15);color:#a78bfa">VG</div>
                    <div class="appt-info">
                        <div class="appt-name">Vikas Gupta</div>
                        <div class="appt-type">New Patient · 60 min</div>
                    </div>
                    <span class="appt-status s-confirmed">Confirmed</span>
                </div>
                <div class="appt-item">
                    <div class="appt-time">04:30</div>
                    <div class="appt-avatar" style="background:rgba(248,113,113,.15);color:#f87171">SJ</div>
                    <div class="appt-info">
                        <div class="appt-name">Sunita Joshi</div>
                        <div class="appt-type">General Checkup · 30 min</div>
                    </div>
                    <span class="appt-status s-cancelled">Cancelled</span>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="panel">
            <div class="panel-header">
                <span class="panel-title">Quick Actions</span>
            </div>
            <div class="quick-actions">
                <a href="consultation.jsp" class="qa-btn">
                    <div class="qa-icon">🩺</div>
                    <div class="qa-label">Start Consultation</div>
                </a>
                
                <a href="d-patients.jsp" class="qa-btn">
                    <div class="qa-icon">👥</div>
                    <div class="qa-label">My Patients</div>
                </a>
                
            </div>

            <!-- Today's Schedule mini-view -->
            <div class="panel-header" style="border-top:1px solid var(--border)">
                <span class="panel-title" style="font-size:.95rem">Today's Schedule</span>
                <a href="d-schedule.jsp" class="panel-action">Full View →</a>
            </div>
            <div class="schedule-list">
                <div class="schedule-slot">
                    <div class="slot-time-col">09:00</div>
                    <div class="slot-line occupied"></div>
                    <div class="slot-content">
                        <div class="slot-card">
                            <div class="slot-patient">Rahul Kumar</div>
                            <div class="slot-detail">General Checkup</div>
                        </div>
                    </div>
                </div>
                <div class="schedule-slot">
                    <div class="slot-time-col">10:00</div>
                    <div class="slot-line occupied"></div>
                    <div class="slot-content">
                        <div class="slot-card">
                            <div class="slot-patient">Priya Mehta</div>
                            <div class="slot-detail">Follow-up</div>
                        </div>
                    </div>
                </div>
                <div class="schedule-slot">
                    <div class="slot-time-col">11:00</div>
                    <div class="slot-line"></div>
                    <div class="slot-content">
                        <div class="slot-empty">— Free slot —</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bottom row -->
    <%-- <div class="bottom-grid">

        <!-- Recent Prescriptions -->
        <div class="panel">
            <div class="panel-header">
                <span class="panel-title">Recent Prescriptions</span>
                <a href="d-prescriptions.jsp" class="panel-action">All →</a>
            </div>
            <div class="rx-item">
                <div class="rx-icon">💊</div>
                <div>
                    <div class="rx-name">Amoxicillin 500mg</div>
                    <div class="rx-meta">Rahul Kumar · 3×/day for 7 days</div>
                </div>
                <div class="rx-date">Today</div>
            </div>
            <div class="rx-item">
                <div class="rx-icon">💊</div>
                <div>
                    <div class="rx-name">Metformin 850mg</div>
                    <div class="rx-meta">Anita Sharma · 2×/day</div>
                </div>
                <div class="rx-date">Yesterday</div>
            </div>
            <div class="rx-item">
                <div class="rx-icon">💊</div>
                <div>
                    <div class="rx-name">Atorvastatin 20mg</div>
                    <div class="rx-meta">Vikas Gupta · 1×/day</div>
                </div>
                <div class="rx-date">Feb 23</div>
            </div>
            <div class="rx-item">
                <div class="rx-icon">💊</div>
                <div>
                    <div class="rx-name">Omeprazole 40mg</div>
                    <div class="rx-meta">Priya Mehta · Before meals</div>
                </div>
                <div class="rx-date">Feb 22</div>
            </div>
        </div>

        <!-- Clinical Notes -->
        <div class="panel">
            <div class="panel-header">
                <span class="panel-title">Clinical Notes</span>
                <a href="d-clinical-notes.jsp" class="panel-action">All →</a>
            </div>
            <div class="note-item">
                <div class="note-patient">Rahul Kumar</div>
                <div class="note-text">Patient reports persistent cough for 5 days. Prescribed antibiotics. Follow-up in 7 days.</div>
                <div class="note-date">Today, 09:30 AM</div>
            </div>
            <div class="note-item">
                <div class="note-patient">Anita Sharma</div>
                <div class="note-text">Blood sugar levels slightly elevated. Adjusted metformin dosage. Diet counselling given.</div>
                <div class="note-date">Yesterday, 02:15 PM</div>
            </div>
            <div class="note-item">
                <div class="note-patient">Vikas Gupta</div>
                <div class="note-text">New patient. Hypertension diagnosed. Started on low-dose medication and lifestyle changes.</div>
                <div class="note-date">Feb 23, 11:00 AM</div>
            </div>
        </div>

        <!-- Profile Summary -->
        <div class="panel">
            <div class="panel-header">
                <span class="panel-title">Professional Info</span>
                <a href="d-profile.jsp" class="panel-action">Edit →</a>
            </div>
            <div class="profile-body">
                <div class="profile-row">
                    <span class="profile-key">Name</span>
                    <span class="profile-val"><%= fullName %></span>
                </div>
                <div class="profile-row">
                    <span class="profile-key">Email</span>
                    <span class="profile-val"><%= doctor.getEmail() %></span>
                </div>
                <div class="profile-row">
                    <span class="profile-key">Specialization</span>
                    <span class="profile-val teal"><%= doctor.getSpecialization() != null ? doctor.getSpecialization() : "N/A" %></span>
                </div>
                <div class="profile-row">
                    <span class="profile-key">Experience</span>
                    <span class="profile-val"><%= doctor.getExpreience() %> years</span>
                </div>
                <div class="profile-row">
                    <span class="profile-key">Affiliation</span>
                    <span class="profile-val"><%= doctor.getAffilation() != null ? doctor.getAffilation() : "N/A" %></span>
                </div>
                <div class="profile-row">
                    <span class="profile-key">License No.</span>
                    <span class="profile-val teal"><%= doctor.getLicense() != null ? doctor.getLicense() : "N/A" %></span>
                </div>
            </div>
            <a href="d-profile.jsp" class="update-btn">Update Profile & Info</a>
        </div>
    </div> --%>

</main>

<!-- <script>
    // Live clock
    function updateClock() {
        const now = new Date();
        const h = now.getHours(), m = now.getMinutes();
        const ampm = h >= 12 ? 'PM' : 'AM';
        const hh = (h % 12 || 12).toString().padStart(2,'0');
        const mm = m.toString().padStart(2,'0');
        const days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
        const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
        document.getElementById('liveClock').textContent =
            `${days[now.getDay()]}, ${months[now.getMonth()]} ${now.getDate()} · ${hh}:${mm} ${ampm}`;
    }
    updateClock();
    setInterval(updateClock, 1000);
</script> -->
<!-- WhatsApp Floating Button -->
<a href="https://wa.me/" target="_blank" title="Chat on WhatsApp"
   style="
       position: fixed;
       bottom: 28px;
       right: 28px;
       width: 58px;
       height: 58px;
       background: #25D366;
       border-radius: 50%;
       display: flex;
       align-items: center;
       justify-content: center;
       box-shadow: 0 4px 20px rgba(37,211,102,0.45);
       z-index: 9999;
       transition: transform 0.22s, box-shadow 0.22s;
       text-decoration: none;
   "
   onmouseover="this.style.transform='scale(1.12)';this.style.boxShadow='0 6px 28px rgba(37,211,102,0.65)'"
   onmouseout="this.style.transform='scale(1)';this.style.boxShadow='0 4px 20px rgba(37,211,102,0.45)'"
>
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="32" height="32" fill="white">
        <path d="M16 0C7.163 0 0 7.163 0 16c0 2.822.736 5.471 2.027 7.774L0 32l8.469-2.001A15.938 15.938 0 0016 32c8.837 0 16-7.163 16-16S24.837 0 16 0zm0 29.333a13.27 13.27 0 01-6.747-1.836l-.484-.287-5.027 1.187 1.234-4.893-.317-.503A13.267 13.267 0 012.667 16C2.667 8.636 8.636 2.667 16 2.667S29.333 8.636 29.333 16 23.364 29.333 16 29.333zm7.27-9.862c-.398-.199-2.354-1.161-2.72-1.294-.366-.133-.632-.199-.898.199-.266.398-1.031 1.294-1.264 1.56-.233.266-.466.299-.864.1-.398-.199-1.681-.619-3.202-1.975-1.183-1.055-1.982-2.357-2.215-2.755-.233-.398-.025-.613.175-.811.18-.178.398-.466.597-.699.199-.233.266-.398.398-.664.133-.266.066-.499-.033-.698-.1-.199-.898-2.165-1.231-2.963-.324-.778-.653-.673-.898-.686l-.765-.013c-.266 0-.698.1-1.064.499-.366.398-1.397 1.365-1.397 3.33 0 1.965 1.43 3.864 1.629 4.13.199.266 2.814 4.298 6.819 6.028.953.412 1.697.658 2.277.842.957.305 1.828.262 2.516.159.767-.114 2.354-.962 2.687-1.891.333-.929.333-1.726.233-1.891-.1-.166-.366-.266-.764-.465z"/>
    </svg>
</a>
<!-- ```

---

**`href` mein apna WhatsApp number dalein:**
```
https://wa.me/91XXXXXXXXXX -->
</body>
</html>
