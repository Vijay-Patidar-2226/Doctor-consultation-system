<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorconsult.model.Doctor" %>
<%
    Doctor d = (Doctor) session.getAttribute("user");
    if (d == null) { response.sendRedirect("index.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Video Consultation - Doctor Portal</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
  :root {
    --teal: #00e5c8;
    --teal-dark: #00b8a0;
    --bg: #0a0f1e;
    --card: #111827;
    --card2: #1a2235;
    --border: rgba(0,229,200,0.15);
    --text: #e2e8f0;
    --muted: #94a3b8;
    --red: #ff4d6d;
    --green: #22d3a0;
  }
  * { margin:0; padding:0; box-sizing:border-box; }
  body { font-family:'DM Sans',sans-serif; background:var(--bg); color:var(--text); min-height:100vh; overflow-x:hidden; }

  /* ── PAGE SYSTEM ── */
  .page { display:none; min-height:100vh; }
  .page.active { display:flex; flex-direction:column; }

  /* ══ PAGE 1 — VIDEO CALL ══ */
  #zoomPage {
    background: radial-gradient(ellipse at 20% 50%, #0d2040 0%, var(--bg) 60%);
  }

  .zoom-header {
    display:flex; align-items:center; justify-content:space-between;
    padding:14px 28px;
    background:rgba(17,24,39,0.9);
    border-bottom:1px solid var(--border);
    backdrop-filter:blur(10px);
    position:sticky; top:0; z-index:10;
  }
  .zoom-header .logo { font-family:'Syne',sans-serif; font-weight:800; font-size:18px; color:var(--teal); letter-spacing:0.5px; }
  .zoom-header .meeting-info { display:flex; align-items:center; gap:10px; }
  .rec-dot { width:10px; height:10px; border-radius:50%; background:var(--red); animation:pulse-rec 1.4s infinite; }
  @keyframes pulse-rec { 0%,100%{opacity:1;transform:scale(1)} 50%{opacity:0.5;transform:scale(1.3)} }
  .meeting-id { font-size:13px; color:var(--muted); }
  .timer { font-family:'Syne',sans-serif; font-size:16px; font-weight:600; color:var(--teal); letter-spacing:1px; }

  .zoom-body {
    flex:1; display:grid; grid-template-columns:1fr 1fr; gap:16px;
    padding:20px 28px; align-items:stretch;
  }

  .video-slot {
    border-radius:16px; overflow:hidden; position:relative;
    background:var(--card); border:1px solid var(--border);
    min-height:400px; display:flex; align-items:center; justify-content:center;
  }
  .video-slot.doctor-slot { background:#000; }
  .video-slot.patient-slot { background:linear-gradient(135deg, #0d2040 0%, #112030 100%); }

  #doctorVideo {
    width:100%; height:100%; object-fit:cover;
    position:absolute; inset:0; border-radius:16px;
    display:none; transform:scaleX(-1);
    transition:opacity 0.3s;
  }

  #camPermission {
    position:absolute; inset:0; display:flex; align-items:center; justify-content:center;
    flex-direction:column; gap:14px; background:rgba(0,0,0,0.85); border-radius:16px; z-index:2;
  }
  .perm-icon {
    width:70px; height:70px; border-radius:50%;
    background:rgba(0,229,200,0.1); border:2px solid rgba(0,229,200,0.4);
    display:flex; align-items:center; justify-content:center;
    animation:pulse-cam 2s infinite;
  }
  @keyframes pulse-cam { 0%,100%{box-shadow:0 0 0 0 rgba(0,229,200,0.3)} 50%{box-shadow:0 0 0 16px rgba(0,229,200,0)} }
  .perm-text { color:var(--text); font-size:14px; font-weight:500; text-align:center; }
  .perm-sub  { color:var(--muted); font-size:12px; text-align:center; }
  .perm-btn  {
    background:linear-gradient(135deg, var(--teal), var(--teal-dark));
    border:none; border-radius:10px; padding:10px 22px;
    font-family:'Syne',sans-serif; font-weight:700; font-size:13px; color:#000;
    cursor:pointer; transition:all 0.2s;
  }
  .perm-btn:hover { transform:scale(1.05); }

  .cam-overlay {
    position:absolute; inset:0; display:flex; align-items:center; justify-content:center;
    flex-direction:column; gap:12px;
  }
  .patient-avatar {
    width:110px; height:110px; border-radius:50%;
    background:linear-gradient(135deg, var(--teal-dark), #0070c0);
    display:flex; align-items:center; justify-content:center;
    font-family:'Syne',sans-serif; font-size:38px; font-weight:800; color:#fff;
    border:3px solid var(--teal);
    box-shadow:0 0 30px rgba(0,229,200,0.3);
  }
  .cam-name {
    font-family:'Syne',sans-serif; font-size:14px; font-weight:600;
    background:rgba(0,0,0,0.5); padding:4px 14px; border-radius:20px; color:#fff;
  }
  .cam-label {
    position:absolute; bottom:14px; left:16px;
    background:rgba(0,0,0,0.6); padding:4px 12px; border-radius:8px;
    font-size:12px; color:var(--teal); font-weight:600; letter-spacing:0.5px;
  }
  .cam-status {
    position:absolute; top:14px; right:14px;
    background:rgba(0,0,0,0.6); padding:4px 10px; border-radius:8px;
    font-size:11px; color:var(--green); display:flex; align-items:center; gap:5px;
  }
  .status-dot { width:7px; height:7px; border-radius:50%; background:var(--green); }

  /* ── CONTROLS BAR ── */
  .controls-bar {
    display:flex; align-items:center; justify-content:center; gap:16px;
    padding:18px; background:rgba(17,24,39,0.95);
    border-top:1px solid var(--border);
  }
  .ctrl-btn {
    display:flex; flex-direction:column; align-items:center; gap:5px;
    background:var(--card2); border:1px solid var(--border);
    border-radius:14px; padding:12px 20px; cursor:pointer;
    transition:all 0.2s; color:var(--text); font-size:11px; font-weight:500;
    min-width:80px; user-select:none;
  }
  .ctrl-btn svg { width:22px; height:22px; }
  .ctrl-btn:hover { background:var(--card); border-color:var(--teal); color:var(--teal); transform:translateY(-2px); }
  .ctrl-btn.active { background:rgba(0,229,200,0.1); border-color:var(--teal); color:var(--teal); }
  .ctrl-btn.off    { background:rgba(255,77,109,0.12); border-color:rgba(255,77,109,0.4); color:var(--red); }
  .ctrl-btn.end-btn {
    background:var(--red); border-color:var(--red); color:#fff;
    min-width:120px; font-weight:700; font-size:13px;
  }
  .ctrl-btn.end-btn:hover { background:#e0003c; transform:translateY(-2px) scale(1.03); }

  /* ══ PAGE 2 — SUCCESS ══ */
  #successPage {
    align-items:center; justify-content:center; text-align:center; padding:40px 20px;
    background: radial-gradient(ellipse at 50% 30%, #0d2040 0%, var(--bg) 60%);
  }
  .success-circle {
    width:100px; height:100px; border-radius:50%;
    background:linear-gradient(135deg, var(--teal), var(--teal-dark));
    display:flex; align-items:center; justify-content:center; margin:0 auto 24px;
    animation:popIn 0.5s cubic-bezier(0.22,1,0.36,1);
    box-shadow:0 0 50px rgba(0,229,200,0.3);
  }
  @keyframes popIn { from{opacity:0;transform:scale(0.5)} to{opacity:1;transform:scale(1)} }
  .success-title { font-family:'Syne',sans-serif; font-size:28px; font-weight:800; margin-bottom:10px; }
  .success-text  { color:var(--muted); font-size:15px; margin-bottom:30px; max-width:360px; margin-left:auto; margin-right:auto; }
  .redirect-bar  {
    background:var(--card); border:1px solid var(--border); border-radius:14px; padding:16px 24px;
    display:inline-flex; align-items:center; gap:12px; font-size:14px; color:var(--muted);
  }
  .redirect-count { font-family:'Syne',sans-serif; font-size:20px; font-weight:800; color:var(--teal); }

  ::-webkit-scrollbar { width:6px; }
  ::-webkit-scrollbar-track { background:transparent; }
  ::-webkit-scrollbar-thumb { background:var(--border); border-radius:3px; }
</style>
</head>
<body>

<!-- ════ PAGE 1: VIDEO CALL ════ -->
<div class="page active" id="zoomPage">
  <div class="zoom-header">
    <div class="logo">Doctor Consultation</div>
    <div class="meeting-info">
      <div class="rec-dot"></div>
      <span class="meeting-id">Meeting: #MC-2026-0312</span>
    </div>
    <div class="timer" id="callTimer">00:00</div>
  </div>

  <div class="zoom-body">
    <!-- Doctor — real webcam -->
    <div class="video-slot doctor-slot">
      <video id="doctorVideo" autoplay playsinline muted></video>
      <div id="camPermission">
        <div class="perm-icon">
          <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#00e5c8" stroke-width="2">
            <path d="M15 10l4.553-2.069A1 1 0 0121 8.82v6.361a1 1 0 01-1.447.894L15 14M3 8a2 2 0 012-2h10a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2V8z"/>
          </svg>
        </div>
        <div class="perm-text">Camera access required</div>
        <div class="perm-sub">Allow camera permission to start video</div>
        <button class="perm-btn" onclick="startDoctorCamera()">Allow Camera</button>
      </div>
      <div class="cam-label">🩺 Doctor &nbsp;·&nbsp; You</div>
      <div class="cam-status" id="docStatus" style="display:none">
        <span class="status-dot"></span> Live
      </div>
    </div>

    <!-- Patient side -->
    <div class="video-slot patient-slot">
      <div class="cam-overlay">
        <div class="patient-avatar">P</div>
        <div class="cam-name">Patient</div>
      </div>
      <div class="cam-label">👤 Patient &nbsp;·&nbsp; Follow-Up</div>
      <div class="cam-status"><span class="status-dot"></span> Connected</div>
    </div>
  </div>

  <!-- Controls -->
  <div class="controls-bar">
    <button class="ctrl-btn active" id="micBtn" onclick="toggleMic()">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M12 1a3 3 0 00-3 3v8a3 3 0 006 0V4a3 3 0 00-3-3z"/>
        <path d="M19 10v2a7 7 0 01-14 0v-2M12 19v4M8 23h8"/>
      </svg>
      Mic On
    </button>
    <button class="ctrl-btn active" id="videoBtn" onclick="toggleVideo()">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M15 10l4.553-2.069A1 1 0 0121 8.82v6.361a1 1 0 01-1.447.894L15 14M3 8a2 2 0 012-2h10a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2V8z"/>
      </svg>
      Video On
    </button>
    <button class="ctrl-btn end-btn" onclick="endMeeting()">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
        <path d="M10.68 13.31a16 16 0 003.41 2.6l1.27-1.27a2 2 0 012.11-.45 12.84 12.84 0 002.81.7 2 2 0 011.72 2v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07A19.42 19.42 0 013.43 9.19 19.79 19.79 0 01.36 0.56 2 2 0 012.35 0h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L6.18 7.91a16 16 0 006.5 5.4z"/>
      </svg>
      End Meeting
    </button>
  </div>
</div>

<!-- ════ PAGE 2: SUCCESS (brief transition before redirect) ════ -->
<div class="page" id="successPage">
  <div class="success-circle">
    <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="#000" stroke-width="2.8">
      <polyline points="20 6 9 17 4 12"/>
    </svg>
  </div>
  <div class="success-title">Meeting Ended ✓</div>
  <div class="success-text">Opening prescription form...</div>
  <div class="redirect-bar">
    <span>Redirecting in</span>
    <span class="redirect-count" id="countNum">3</span>
    <span>seconds...</span>
  </div>
</div>

<script>
// ── Timer ──
let secs = 0, timerInt = null;
function startTimer() {
  timerInt = setInterval(() => {
    secs++;
    const m = String(Math.floor(secs / 60)).padStart(2, '0');
    const s = String(secs % 60).padStart(2, '0');
    document.getElementById('callTimer').textContent = m + ':' + s;
  }, 1000);
}
startTimer();

// ── Camera ──
let localStream = null;

async function startDoctorCamera() {
  try {
    localStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
    const video = document.getElementById('doctorVideo');
    video.srcObject = localStream;
    video.style.display = 'block';
    document.getElementById('camPermission').style.display = 'none';
    document.getElementById('docStatus').style.display = 'flex';
  } catch (err) {
    const perm = document.getElementById('camPermission');
    perm.querySelector('.perm-text').textContent = 'Camera access denied';
    perm.querySelector('.perm-sub').textContent  = 'Please allow camera in browser settings and reload';
    perm.querySelector('.perm-btn').textContent  = 'Retry';
  }
}

window.addEventListener('load', startDoctorCamera);

// ── Mic toggle ──
function toggleMic() {
  const btn = document.getElementById('micBtn');
  if (!localStream) return;
  const tracks = localStream.getAudioTracks();
  if (btn.classList.contains('active')) {
    tracks.forEach(t => t.enabled = false);
    btn.classList.remove('active'); btn.classList.add('off');
    btn.querySelector('svg').innerHTML = `<line x1="1" y1="1" x2="23" y2="23" stroke-width="2"/><path d="M9 9v3a3 3 0 005.12 2.12M15 9.34V4a3 3 0 00-5.94-.6M17 16.95A7 7 0 015 12v-2m14 0v2a7 7 0 01-.11 1.23M12 19v4M8 23h8"/>`;
    btn.lastChild.textContent = ' Mic Off';
  } else {
    tracks.forEach(t => t.enabled = true);
    btn.classList.add('active'); btn.classList.remove('off');
    btn.querySelector('svg').innerHTML = `<path d="M12 1a3 3 0 00-3 3v8a3 3 0 006 0V4a3 3 0 00-3-3z"/><path d="M19 10v2a7 7 0 01-14 0v-2M12 19v4M8 23h8"/>`;
    btn.lastChild.textContent = ' Mic On';
  }
}

// ── Video toggle ──
function toggleVideo() {
  const btn   = document.getElementById('videoBtn');
  const video = document.getElementById('doctorVideo');
  if (!localStream) return;
  const tracks = localStream.getVideoTracks();
  if (btn.classList.contains('active')) {
    tracks.forEach(t => t.enabled = false);
    video.style.opacity = '0.15';
    btn.classList.remove('active'); btn.classList.add('off');
    btn.lastChild.textContent = ' Video Off';
  } else {
    tracks.forEach(t => t.enabled = true);
    video.style.opacity = '1';
    btn.classList.add('active'); btn.classList.remove('off');
    btn.lastChild.textContent = ' Video On';
  }
}

// ── End Meeting → show success briefly → redirect to addPrescription.jsp ──
function endMeeting() {
  clearInterval(timerInt);
  if (localStream) {
    localStream.getTracks().forEach(t => t.stop());
    localStream = null;
  }
  showPage('successPage');
  let n = 3;
  const counter = document.getElementById('countNum');
  const cd = setInterval(() => {
    n--;
    counter.textContent = n;
    if (n <= 0) {
      clearInterval(cd);
      window.location.href = 'addPrescription.jsp';
    }
  }, 1000);
}

// ── Page switch ──
function showPage(id) {
  document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
  document.getElementById(id).classList.add('active');
  window.scrollTo(0, 0);
}
</script>
</body>
</html>
