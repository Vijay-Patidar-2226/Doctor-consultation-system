<%@page import="com.doctorconsult.model.Consultation"%>
<%@page import="java.util.List"%>
<%@page import="com.doctorconsult.dao.DoctorRegisterDaoImpl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorconsult.model.Doctor" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consultations - MediCare</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: #0d1b2a; color: #ccd6f6; min-height: 100vh; }

        /* Header */
        .header {
            background: #112240;
            padding: 16px 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid rgba(10,191,163,.2);
        }
        .header h2 { font-size: 1.2rem; color: #e6f1ff; }
        .back-btn {
            background: rgba(10,191,163,.15);
            color: #0abfa3;
            border: 1px solid rgba(10,191,163,.3);
            padding: 7px 16px;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            font-size: .85rem;
        }

        .container { max-width: 1100px; margin: 30px auto; padding: 0 20px; }

        /* Toggle Tabs */
        .mode-tabs {
            display: flex;
            gap: 12px;
            margin-bottom: 28px;
            background: #162032;
            padding: 6px;
            border-radius: 12px;
            width: fit-content;
        }
        .tab-btn {
            padding: 10px 30px;
            border-radius: 9px;
            border: none;
            cursor: pointer;
            font-size: .95rem;
            font-weight: 600;
            background: transparent;
            color: #8892b0;
            transition: all .2s;
        }
        .tab-btn.active { background: #0abfa3; color: #0d1b2a; }

        /* Section */
        .section { display: none; }
        .section.active { display: block; }

        /* Patient Card */
        .card-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 18px; }
        .patient-card {
            background: #162032;
            border: 1px solid rgba(10,191,163,.15);
            border-radius: 12px;
            padding: 18px;
            transition: transform .2s;
        }
        .patient-card:hover { transform: translateY(-3px); }
        .card-top { display: flex; align-items: center; gap: 13px; margin-bottom: 14px; }
        .avatar {
            width: 44px; height: 44px;
            border-radius: 50%;
            background: linear-gradient(135deg, #0abfa3, #e8b84b);
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; color: #0d1b2a; font-size: .95rem;
            flex-shrink: 0;
        }
        .patient-name { font-size: 1rem; color: #e6f1ff; font-weight: 600; }
        .patient-id   { font-size: .75rem; color: #8892b0; }

        .info-row { display: flex; justify-content: space-between; font-size: .82rem; padding: 5px 0; border-bottom: 1px solid rgba(255,255,255,.05); }
        .info-row:last-of-type { border-bottom: none; }
        .info-key { color: #8892b0; }
        .info-val { color: #ccd6f6; font-weight: 500; }
        .tag {
            display: inline-block;
            padding: 2px 10px;
            border-radius: 20px;
            font-size: .72rem;
            font-weight: 600;
        }
        .tag.followup   { background: rgba(10,191,163,.15);  color: #0abfa3; }
        .tag.new        { background: rgba(232,184,75,.15);  color: #e8b84b; }
        .tag.urgent     { background: rgba(248,113,113,.15); color: #f87171; }

        .zoom-btn {
            margin-top: 14px;
            width: 100%;
            padding: 10px;
            background: #0abfa3;
            color: #0d1b2a;
            border: none;
            border-radius: 9px;
            font-weight: 700;
            cursor: pointer;
            font-size: .88rem;
            transition: opacity .2s;
        }
        .zoom-btn:hover { opacity: .85; }

        /* Offline - pending requests */
        .request-card {
            background: #162032;
            border: 1px solid rgba(255,255,255,.08);
            border-radius: 12px;
            padding: 18px 22px;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }
        .request-info { flex: 1; min-width: 200px; }
        .request-name { font-size: 1rem; color: #e6f1ff; font-weight: 600; }
        .request-meta { font-size: .8rem; color: #8892b0; margin-top: 4px; }
        .action-btns  { display: flex; gap: 10px; }
        .accept-btn, .decline-btn {
            padding: 8px 20px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            font-size: .85rem;
            transition: opacity .2s;
        }
        .accept-btn  { background: #0abfa3; color: #0d1b2a; }
        .decline-btn { background: rgba(248,113,113,.2); color: #f87171; border: 1px solid rgba(248,113,113,.3); }
        .accept-btn:hover, .decline-btn:hover { opacity: .8; }

        /* Time picker (shown after accept) */
        .time-picker {
            display: none;
            background: #1e3050;
            border: 1px solid rgba(10,191,163,.3);
            border-radius: 10px;
            padding: 14px 18px;
            margin-top: 12px;
            width: 100%;
        }
        .time-picker label { font-size: .82rem; color: #8892b0; display: block; margin-bottom: 6px; }
        .time-picker input[type="datetime-local"] {
            background: #0d1b2a;
            border: 1px solid rgba(10,191,163,.3);
            color: #ccd6f6;
            padding: 8px 12px;
            border-radius: 8px;
            font-size: .88rem;
            margin-right: 10px;
            width: 230px;
        }
        .confirm-btn {
            background: #e8b84b;
            color: #0d1b2a;
            border: none;
            padding: 9px 18px;
            border-radius: 8px;
            font-weight: 700;
            cursor: pointer;
            font-size: .85rem;
        }
        .confirm-btn:hover { opacity: .85; }

        /* Notification toast */
        .toast {
            position: fixed;
            bottom: 30px; right: 30px;
            background: #0abfa3;
            color: #0d1b2a;
            padding: 12px 22px;
            border-radius: 10px;
            font-weight: 600;
            font-size: .9rem;
            display: none;
            z-index: 999;
            box-shadow: 0 8px 24px rgba(0,0,0,.4);
            animation: slideIn .3s ease;
        }
        @keyframes slideIn { from { transform: translateY(20px); opacity:0; } to { transform: translateY(0); opacity:1; } }

        .declined-badge {
            font-size: .78rem;
            color: #f87171;
            font-style: italic;
            margin-top: 6px;
        }
        .accepted-badge {
            font-size: .78rem;
            color: #4ade80;
            font-style: italic;
            margin-top: 6px;
        }

        .section-title { font-size: 1rem; color: #8892b0; margin-bottom: 16px; letter-spacing: .5px; }
    </style>
</head>
<body>

<div class="header">
    <h2>🩺 Consultations</h2>
    <a href="d-dashboard.jsp" class="back-btn">← Dashboard</a>
</div>

<div class="container">

    <!-- Mode Tabs -->
    <div class="mode-tabs">
        <button class="tab-btn active" onclick="switchMode('online')">🌐 Online</button>
        <button class="tab-btn" onclick="switchMode('offline')">🏥 Offline</button>
    </div>

    <!-- ── ONLINE SECTION ── -->
    <div class="section active" id="online-section">
        <p class="section-title">Follow-up patients scheduled for online consultation today</p>
        <div class="card-grid">
        
        <%
        	DoctorRegisterDaoImpl dd = new DoctorRegisterDaoImpl();
        	List<Consultation> ls = dd.getAllConsultations();
        		
        	if(ls.isEmpty()) {
        		%>
        			<h3>Vijay not exists</h3>
        		<%
        	}
        	else {
        		for(Consultation c : ls) {
        			%>
        				<div class="patient-card">
                <div class="card-top">
                    <div class="avatar">RK</div>
                    <div>
                        <div class="patient-name"><%= c.getName() %></div>
                        <div class="patient-id"><%= c.getId() %></div>
                    </div>
                </div>
                <div class="info-row"><span class="info-key">Disease</span><span class="info-val"><%= c.getDisease() %></span></div>
                <div class="info-row"><span class="info-key">Type</span><span class="info-val"><span class="tag followup"><%= c.getType() %></span></span></div>
                <div class="info-row"><span class="info-key">Last Visit</span><span class="info-val"><%= c.getLastV() %></span></div>
                <div class="info-row"><span class="info-key">Scheduled</span><span class="info-val"><%= c.getCurr() %></span></div>
                <button class="zoom-btn" onclick="window.location.href='Doctor_online_consultation.html'">📹 Start Zoom Consultation</button>
            </div>
        			<%
        			
        		}
        	}
        %>
        </div>
    </div>

    <!-- ── OFFLINE SECTION ── -->
    <div class="section" id="offline-section">
        <p class="section-title">Walk-in / offline appointment requests — Accept or Decline</p>

        <!-- Request 1 -->
        <div class="request-card" id="req1">
            <div class="avatar">SJ</div>
            <div class="request-info">
                <div class="request-name">Sunita Joshi</div>
                <div class="request-meta">Age: 45 · Disease: Knee Pain (Arthritis) · Requested: Today 10:00 AM</div>
                <div id="req1-status"></div>
            </div>
            <div class="action-btns" id="req1-btns">
                <button class="accept-btn"  onclick="acceptRequest(1)">✔ Accept</button>
                <button class="decline-btn" onclick="declineRequest(1)">✘ Decline</button>
            </div>
            <div class="time-picker" id="tp1">
                <label>Set appointment time for patient:</label>
                <input type="datetime-local" id="dt1">
                <button class="confirm-btn" onclick="confirmTime(1, 'Sunita Joshi')">Send Notification</button>
            </div>
        </div>

        <!-- Request 2 -->
        <div class="request-card" id="req2">
            <div class="avatar">MK</div>
            <div class="request-info">
                <div class="request-name">Mohan Kumar</div>
                <div class="request-meta">Age: 60 · Disease: Chest Pain (Cardiac) · Requested: Today 11:15 AM</div>
                <div id="req2-status"></div>
            </div>
            <div class="action-btns" id="req2-btns">
                <button class="accept-btn"  onclick="acceptRequest(2)">✔ Accept</button>
                <button class="decline-btn" onclick="declineRequest(2)">✘ Decline</button>
            </div>
            <div class="time-picker" id="tp2">
                <label>Set appointment time for patient:</label>
                <input type="datetime-local" id="dt2">
                <button class="confirm-btn" onclick="confirmTime(2, 'Mohan Kumar')">Send Notification</button>
            </div>
        </div>

        <!-- Request 3 -->
        <div class="request-card" id="req3">
            <div class="avatar">NS</div>
            <div class="request-info">
                <div class="request-name">Neha Singh</div>
                <div class="request-meta">Age: 28 · Disease: Migraine · Requested: Today 01:00 PM</div>
                <div id="req3-status"></div>
            </div>
            <div class="action-btns" id="req3-btns">
                <button class="accept-btn"  onclick="acceptRequest(3)">✔ Accept</button>
                <button class="decline-btn" onclick="declineRequest(3)">✘ Decline</button>
            </div>
            <div class="time-picker" id="tp3">
                <label>Set appointment time for patient:</label>
                <input type="datetime-local" id="dt3">
                <button class="confirm-btn" onclick="confirmTime(3, 'Neha Singh')">Send Notification</button>
            </div>
        </div>

        <!-- Request 4 -->
        <div class="request-card" id="req4">
            <div class="avatar">AR</div>
            <div class="request-info">
                <div class="request-name">Amit Rao</div>
                <div class="request-meta">Age: 35 · Disease: Skin Rash (Dermatitis) · Requested: Today 03:30 PM</div>
                <div id="req4-status"></div>
            </div>
            <div class="action-btns" id="req4-btns">
                <button class="accept-btn"  onclick="acceptRequest(4)">✔ Accept</button>
                <button class="decline-btn" onclick="declineRequest(4)">✘ Decline</button>
            </div>
            <div class="time-picker" id="tp4">
                <label>Set appointment time for patient:</label>
                <input type="datetime-local" id="dt4">
                <button class="confirm-btn" onclick="confirmTime(4, 'Amit Rao')">Send Notification</button>
            </div>
        </div>

    </div>
</div>

<!-- Toast Notification -->
<div class="toast" id="toast"></div>

<script>
    function switchMode(mode) {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
        document.getElementById(mode + '-section').classList.add('active');
        event.target.classList.add('active');
    }

    function startZoom(name) {
        showToast('📹 Starting Zoom for ' + name + '...');
        // Replace with actual Zoom link per patient
        setTimeout(() => window.open('https://zoom.us/start/videomeeting', '_blank'), 1000);
    }

    function acceptRequest(id) {
        document.getElementById('req' + id + '-btns').style.display = 'none';
        document.getElementById('tp' + id).style.display = 'block';
        // Set default to next hour
        const dt = new Date(); dt.setHours(dt.getHours() + 1, 0, 0);
        document.getElementById('dt' + id).value = dt.toISOString().slice(0,16);
    }

    function declineRequest(id) {
        document.getElementById('req' + id + '-btns').style.display = 'none';
        document.getElementById('req' + id + '-status').innerHTML = '<div class="declined-badge">✘ Request Declined</div>';
        document.getElementById('req' + id).style.opacity = '.5';
    }

    function confirmTime(id, name) {
        const val = document.getElementById('dt' + id).value;
        if (!val) { showToast('⚠ Please select a date and time!'); return; }
        const d = new Date(val);
        const fmt = d.toLocaleString('en-IN', { dateStyle:'medium', timeStyle:'short' });
        document.getElementById('tp' + id).style.display = 'none';
        document.getElementById('req' + id + '-status').innerHTML =
            '<div class="accepted-badge">✔ Accepted · Appointment set for ' + fmt + '</div>';
        showToast('🔔 Notification sent to ' + name + ' for ' + fmt);
    }

    function showToast(msg) {
        const t = document.getElementById('toast');
        t.textContent = msg;
        t.style.display = 'block';
        setTimeout(() => t.style.display = 'none', 3500);
    }
</script>
</body>
</html>
