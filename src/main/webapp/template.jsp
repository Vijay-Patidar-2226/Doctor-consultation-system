<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Doctor's Consultation Disease Template</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<style>
/* =============================================
   CSS VARIABLES & RESET
   ============================================= */
:root {
  --bg:        #0d0f14;
  --surface:   #141720;
  --card:      #1a1e2a;
  --border:    #252b3b;
  --accent:    #4f9cf9;
  --accent2:   #a78bfa;
  --green:     #34d399;
  --red:       #f87171;
  --amber:     #fbbf24;
  --text:      #e8ecf4;
  --muted:     #7b84a0;
  --radius:    14px;
  --shadow:    0 8px 32px rgba(0,0,0,0.4);
}

*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
html { font-size: 15px; scroll-behavior: smooth; }
body {
  font-family: 'DM Sans', sans-serif;
  background: var(--bg);
  color: var(--text);
  min-height: 100vh;
  overflow-x: hidden;
}

/* =============================================
   LAYOUT
   ============================================= */
.app { display: flex; min-height: 100vh; }

/* ── Sidebar ── */
.sidebar {
  width: 280px; flex-shrink: 0;
  background: var(--surface);
  border-right: 1px solid var(--border);
  display: flex; flex-direction: column;
  position: sticky; top: 0; height: 100vh;
  overflow: hidden;
}
.sidebar-header {
  padding: 28px 24px 20px;
  border-bottom: 1px solid var(--border);
}
.logo { display: flex; align-items: center; gap: 10px; margin-bottom: 6px; }
.logo-icon {
  width: 38px; height: 38px; border-radius: 10px;
  background: linear-gradient(135deg, #4f9cf9, #a78bfa);
  display: grid; place-items: center; font-size: 18px;
}
.logo-text { font-family: 'Syne', sans-serif; font-size: 1.1rem; font-weight: 700; }
.logo-sub { font-size: 0.75rem; color: var(--muted); }

.search-wrap { padding: 16px 20px; border-bottom: 1px solid var(--border); }
.search-input {
  width: 100%; padding: 10px 14px 10px 38px;
  background: var(--card); border: 1px solid var(--border);
  border-radius: 10px; color: var(--text);
  font-family: 'DM Sans', sans-serif; font-size: 0.875rem;
  transition: border-color 0.2s;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%237b84a0' stroke-width='2'%3E%3Ccircle cx='11' cy='11' r='8'/%3E%3Cpath d='m21 21-4.35-4.35'/%3E%3C/svg%3E");
  background-repeat: no-repeat; background-position: 12px center;
}
.search-input:focus { outline: none; border-color: var(--accent); }

.templates-list { flex: 1; overflow-y: auto; padding: 12px 12px 0; }
.templates-list::-webkit-scrollbar { width: 4px; }
.templates-list::-webkit-scrollbar-track { background: transparent; }
.templates-list::-webkit-scrollbar-thumb { background: var(--border); border-radius: 4px; }

.template-btn {
  width: 100%; padding: 12px 14px;
  background: transparent; border: none;
  border-radius: 10px; cursor: pointer;
  display: flex; align-items: center; gap: 12px;
  color: var(--text); font-family: 'DM Sans', sans-serif;
  font-size: 0.9rem; text-align: left;
  transition: background 0.15s, transform 0.1s;
  margin-bottom: 4px;
}
.template-btn:hover  { background: var(--card); }
.template-btn.active { background: var(--card); box-shadow: inset 2px 0 0 var(--accent); }
.template-btn .t-icon {
  width: 36px; height: 36px; border-radius: 8px;
  display: grid; place-items: center; font-size: 18px;
  flex-shrink: 0;
}
.template-btn .t-name { font-weight: 500; flex: 1; }
.template-btn .t-count {
  font-size: 0.72rem; color: var(--muted);
  background: var(--border); padding: 2px 7px; border-radius: 20px;
}

.sidebar-footer { padding: 16px 20px; border-top: 1px solid var(--border); }
.btn-add {
  width: 100%; padding: 11px; border: none;
  background: linear-gradient(135deg, var(--accent), var(--accent2));
  color: #fff; border-radius: 10px; cursor: pointer;
  font-family: 'Syne', sans-serif; font-weight: 600; font-size: 0.875rem;
  display: flex; align-items: center; justify-content: center; gap: 8px;
  transition: opacity 0.2s, transform 0.1s;
}
.btn-add:hover { opacity: 0.9; }
.btn-add:active { transform: scale(0.98); }

/* ── Main Panel ── */
.main { flex: 1; overflow-y: auto; }

/* ─ Empty State ─ */
.empty-state {
  display: flex; flex-direction: column;
  align-items: center; justify-content: center;
  height: 100vh; gap: 16px; text-align: center; padding: 40px;
}
.empty-state .big-icon { font-size: 64px; opacity: 0.4; }
.empty-state h2 { font-family: 'Syne', sans-serif; font-size: 1.5rem; font-weight: 700; color: var(--muted); }
.empty-state p { color: var(--muted); max-width: 320px; line-height: 1.6; }

/* ─ Template Detail ─ */
.detail-view { padding: 36px 40px; max-width: 900px; }
.detail-header {
  display: flex; align-items: flex-start;
  justify-content: space-between; gap: 16px;
  margin-bottom: 32px;
  padding-bottom: 24px; border-bottom: 1px solid var(--border);
}
.detail-title-group { display: flex; align-items: center; gap: 16px; }
.detail-icon {
  width: 60px; height: 60px; border-radius: 16px;
  display: grid; place-items: center; font-size: 28px;
}
.detail-name {
  font-family: 'Syne', sans-serif; font-size: 1.8rem; font-weight: 800;
  line-height: 1.1;
}
.detail-desc { font-size: 0.875rem; color: var(--muted); margin-top: 5px; }
.detail-actions { display: flex; gap: 10px; flex-shrink: 0; }

.btn { padding: 9px 18px; border: none; border-radius: 8px; cursor: pointer;
       font-family: 'DM Sans', sans-serif; font-size: 0.875rem; font-weight: 500;
       display: inline-flex; align-items: center; gap: 6px; transition: all 0.15s; }
.btn-primary  { background: var(--accent);  color: #fff; }
.btn-primary:hover { background: #3a8ef0; }
.btn-success  { background: var(--green);   color: #0d0f14; }
.btn-success:hover { background: #2bd48a; }
.btn-danger   { background: transparent; border: 1px solid var(--red); color: var(--red); }
.btn-danger:hover { background: rgba(248,113,113,0.1); }
.btn-ghost    { background: var(--card); color: var(--text); border: 1px solid var(--border); }
.btn-ghost:hover { border-color: var(--accent); }

/* ─ Auto-fill Banner ─ */
.autofill-banner {
  background: linear-gradient(135deg, rgba(79,156,249,0.12), rgba(167,139,250,0.12));
  border: 1px solid rgba(79,156,249,0.3);
  border-radius: var(--radius); padding: 18px 24px;
  display: flex; align-items: center; justify-content: space-between;
  margin-bottom: 28px; gap: 16px;
}
.banner-text h3 { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 1rem; }
.banner-text p  { font-size: 0.83rem; color: var(--muted); margin-top: 3px; }
.btn-autofill {
  padding: 10px 22px; background: var(--accent); color: #fff; border: none;
  border-radius: 8px; cursor: pointer; font-family: 'Syne', sans-serif;
  font-weight: 700; font-size: 0.875rem; white-space: nowrap;
  transition: all 0.15s; display: flex; align-items: center; gap: 8px;
}
.btn-autofill:hover { background: #3a8ef0; transform: translateY(-1px); }
.btn-autofill.filled {
  background: var(--green); color: #0d0f14;
  animation: pulse-green 0.4s ease;
}
@keyframes pulse-green {
  0%   { box-shadow: 0 0 0 0 rgba(52,211,153,0.6); }
  70%  { box-shadow: 0 0 0 10px rgba(52,211,153,0); }
  100% { box-shadow: 0 0 0 0 rgba(52,211,153,0); }
}

/* ─ Sections ─ */
.section { margin-bottom: 28px; }
.section-header {
  display: flex; align-items: center; gap: 10px;
  margin-bottom: 14px;
}
.section-title {
  font-family: 'Syne', sans-serif; font-size: 0.95rem;
  font-weight: 700; text-transform: uppercase;
  letter-spacing: 0.06em; color: var(--muted);
}
.section-badge {
  background: var(--border); color: var(--muted);
  font-size: 0.72rem; padding: 2px 8px; border-radius: 20px;
}

/* ─ Medicine Cards ─ */
.medicines-grid {
  display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 14px;
}
.med-card {
  background: var(--card); border: 1px solid var(--border);
  border-radius: var(--radius); padding: 16px 18px;
  transition: border-color 0.2s, transform 0.15s;
}
.med-card:hover { border-color: var(--accent); transform: translateY(-2px); }
.med-name { font-weight: 600; font-size: 0.95rem; margin-bottom: 10px;
            padding-bottom: 10px; border-bottom: 1px solid var(--border); }
.med-meta { display: flex; flex-direction: column; gap: 6px; }
.med-row  { display: flex; justify-content: space-between; align-items: center; font-size: 0.8rem; }
.med-label { color: var(--muted); }
.med-value { font-weight: 500; text-align: right; max-width: 55%; }
.med-instr {
  margin-top: 8px; padding: 7px 10px;
  background: rgba(79,156,249,0.07); border-radius: 6px;
  font-size: 0.78rem; color: var(--accent); line-height: 1.4;
}

/* ─ Advice List ─ */
.advice-list { display: flex; flex-direction: column; gap: 8px; }
.advice-item {
  display: flex; align-items: flex-start; gap: 10px;
  background: var(--card); border: 1px solid var(--border);
  border-radius: 10px; padding: 12px 16px; font-size: 0.875rem;
  transition: border-color 0.2s;
}
.advice-item:hover { border-color: var(--green); }
.advice-dot {
  width: 8px; height: 8px; border-radius: 50%;
  background: var(--green); flex-shrink: 0; margin-top: 5px;
}

/* ─ Prescription Preview Modal ─ */
.modal-overlay {
  position: fixed; inset: 0; background: rgba(0,0,0,0.7);
  display: none; align-items: center; justify-content: center;
  z-index: 100; padding: 24px; backdrop-filter: blur(4px);
}
.modal-overlay.open { display: flex; }
.modal {
  background: var(--surface); border: 1px solid var(--border);
  border-radius: 18px; width: 100%; max-width: 680px;
  max-height: 90vh; overflow: hidden; display: flex; flex-direction: column;
  box-shadow: var(--shadow);
  animation: modal-in 0.25s cubic-bezier(0.34,1.56,0.64,1);
}
@keyframes modal-in {
  from { transform: scale(0.9) translateY(20px); opacity: 0; }
  to   { transform: scale(1) translateY(0); opacity: 1; }
}
.modal-head {
  padding: 20px 24px; border-bottom: 1px solid var(--border);
  display: flex; align-items: center; justify-content: space-between;
}
.modal-head h2 { font-family: 'Syne', sans-serif; font-size: 1.1rem; font-weight: 700; }
.modal-body { padding: 24px; overflow-y: auto; }
.modal-close {
  width: 34px; height: 34px; border-radius: 8px; border: 1px solid var(--border);
  background: transparent; color: var(--muted); cursor: pointer; font-size: 1.1rem;
  display: grid; place-items: center; transition: all 0.15s;
}
.modal-close:hover { background: var(--card); color: var(--text); }

/* ─ Prescription Output ─ */
.rx-header {
  text-align: center; padding: 20px;
  background: linear-gradient(135deg, rgba(79,156,249,0.08), rgba(167,139,250,0.08));
  border-radius: 10px; margin-bottom: 20px;
  border: 1px solid rgba(79,156,249,0.2);
}
.rx-header .rx-symbol {
  font-family: 'Syne', sans-serif; font-size: 2.5rem; font-weight: 800;
  color: var(--accent); display: block;
}
.rx-header .rx-disease {
  font-family: 'Syne', sans-serif; font-size: 1.3rem; font-weight: 700;
  margin-top: 4px;
}
.rx-header .rx-date { font-size: 0.8rem; color: var(--muted); margin-top: 6px; }
.rx-section { margin-bottom: 18px; }
.rx-section-title {
  font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.08em;
  color: var(--muted); margin-bottom: 10px; font-weight: 600;
}
.rx-med-row {
  display: flex; justify-content: space-between; align-items: center;
  padding: 10px 14px; background: var(--card); border-radius: 8px;
  margin-bottom: 6px; font-size: 0.875rem;
}
.rx-med-name { font-weight: 600; }
.rx-med-info { font-size: 0.78rem; color: var(--muted); text-align: right; }
.rx-advice-item {
  padding: 8px 14px; background: var(--card); border-radius: 8px;
  margin-bottom: 6px; font-size: 0.875rem;
  display: flex; align-items: center; gap: 8px;
}
.modal-footer {
  padding: 16px 24px; border-top: 1px solid var(--border);
  display: flex; justify-content: flex-end; gap: 10px;
}

/* ─ Add/Edit Modal ─ */
.form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
.form-group { display: flex; flex-direction: column; gap: 6px; }
.form-group.full { grid-column: 1 / -1; }
.form-label { font-size: 0.8rem; color: var(--muted); font-weight: 500; }
.form-input, .form-textarea {
  background: var(--card); border: 1px solid var(--border);
  border-radius: 8px; color: var(--text); padding: 10px 12px;
  font-family: 'DM Sans', sans-serif; font-size: 0.875rem;
  transition: border-color 0.2s;
}
.form-input:focus, .form-textarea:focus { outline: none; border-color: var(--accent); }
.form-textarea { resize: vertical; min-height: 70px; }
.divider {
  border: none; border-top: 1px solid var(--border);
  margin: 18px 0;
}
.dyn-row {
  display: grid; grid-template-columns: 2fr 1fr 1fr 1fr auto;
  gap: 8px; align-items: end; margin-bottom: 8px;
}
.dyn-row-advice { display: flex; gap: 8px; align-items: center; margin-bottom: 8px; }
.btn-remove {
  width: 32px; height: 32px; border-radius: 7px; border: 1px solid rgba(248,113,113,0.3);
  background: transparent; color: var(--red); cursor: pointer; font-size: 1rem;
  display: grid; place-items: center; transition: all 0.15s; flex-shrink: 0;
}
.btn-remove:hover { background: rgba(248,113,113,0.1); }
.btn-add-row {
  background: transparent; border: 1px dashed var(--border); border-radius: 8px;
  color: var(--muted); padding: 8px; cursor: pointer; width: 100%; font-size: 0.8rem;
  transition: all 0.15s; font-family: 'DM Sans', sans-serif; margin-top: 4px;
}
.btn-add-row:hover { border-color: var(--accent); color: var(--accent); }

/* ─ Toast ─ */
.toast {
  position: fixed; bottom: 28px; right: 28px; z-index: 200;
  background: var(--green); color: #0d0f14;
  padding: 12px 20px; border-radius: 10px; font-weight: 600; font-size: 0.875rem;
  display: flex; align-items: center; gap: 8px;
  transform: translateY(80px); opacity: 0;
  transition: all 0.35s cubic-bezier(0.34,1.56,0.64,1);
  pointer-events: none;
}
.toast.show { transform: translateY(0); opacity: 1; }
.toast.error { background: var(--red); color: #fff; }

/* ─ Loading skeleton ─ */
.skeleton {
  background: linear-gradient(90deg, var(--card) 25%, var(--border) 50%, var(--card) 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
  border-radius: 8px;
}
@keyframes shimmer { 0% { background-position: 200% 0; } 100% { background-position: -200% 0; } }

/* ─ Responsive ─ */
@media (max-width: 900px) {
  .sidebar { width: 240px; }
  .detail-view { padding: 24px; }
  .dyn-row { grid-template-columns: 1fr 1fr; }
  .dyn-row > :nth-child(n+3) { display: none; }
}
@media (max-width: 640px) {
  .app { flex-direction: column; }
  .sidebar { width: 100%; height: auto; position: static; }
  .templates-list { max-height: 200px; }
  .form-grid { grid-template-columns: 1fr; }
}
</style>
</head>
<body>

<div class="app">

  <!-- ═══════════════ SIDEBAR ═══════════════ -->
  <aside class="sidebar">
    <div class="sidebar-header">
      <div class="logo">
        <div class="logo-icon">🏥</div>
        <div>
          <div class="logo-text">Doctor's Consultation System</div>
          <div class="logo-sub">Disease Templates</div>
        </div>
      </div>
    </div>

    <div class="search-wrap">
      <input type="text" class="search-input" placeholder="Search disease..."
             id="searchInput" oninput="filterTemplates(this.value)">
    </div>

    <div class="templates-list" id="templatesList">
      <!-- JS populated -->
      <div style="padding:24px;text-align:center;color:var(--muted);">
        <div class="skeleton" style="height:40px;margin-bottom:8px;"></div>
        <div class="skeleton" style="height:40px;margin-bottom:8px;"></div>
        <div class="skeleton" style="height:40px;"></div>
      </div>
    </div>

    <div class="sidebar-footer">
      <button class="btn-add" onclick="openAddModal()">
        <span>＋</span> Add New Template
      </button>
    </div>
  </aside>

  <!-- ═══════════════ MAIN ═══════════════ -->
  <main class="main" id="mainPanel">
    <div class="empty-state" id="emptyState">
      <div class="big-icon">🩺</div>
      <h2>Select a Disease Template</h2>
      <p>Click any disease on the left to view its prescription template, then auto-fill into a new prescription with one click.</p>
    </div>
    <div class="detail-view" id="detailView" style="display:none;"></div>
  </main>

</div>

<!-- ═══════════════ PRESCRIPTION MODAL ═══════════════ -->
<div class="modal-overlay" id="rxModal">
  <div class="modal">
    <div class="modal-head">
      <h2>📄 Prescription Preview</h2>
      <button class="modal-close" onclick="closeModal('rxModal')">✕</button>
    </div>
    <div class="modal-body" id="rxModalBody"></div>
    <div class="modal-footer">
      <button class="btn btn-ghost" onclick="closeModal('rxModal')">Close</button>
      <button class="btn btn-success" onclick="printRx()">🖨️ Print</button>
    </div>
  </div>
</div>

<!-- ═══════════════ ADD / EDIT MODAL ═══════════════ -->
<div class="modal-overlay" id="formModal">
  <div class="modal" style="max-width:760px;">
    <div class="modal-head">
      <h2 id="formModalTitle">➕ Add Disease Template</h2>
      <button class="modal-close" onclick="closeModal('formModal')">✕</button>
    </div>
    <div class="modal-body">
      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Disease Name *</label>
          <input type="text" class="form-input" id="f_name" placeholder="e.g., Typhoid Fever">
        </div>
        <div class="form-group">
          <label class="form-label">Icon (Emoji)</label>
          <input type="text" class="form-input" id="f_icon" placeholder="🌡️" maxlength="4">
        </div>
        <div class="form-group">
          <label class="form-label">Color Tag</label>
          <input type="color" class="form-input" id="f_color" value="#4f9cf9" style="padding:4px;height:40px;cursor:pointer;">
        </div>
        <div class="form-group">
          <label class="form-label">Description</label>
          <input type="text" class="form-input" id="f_desc" placeholder="Brief protocol description">
        </div>
      </div>

      <hr class="divider">
      <div class="section-header" style="margin-bottom:12px;">
        <span class="section-title">💊 Medicines</span>
      </div>
      <div id="medRows"></div>
      <button class="btn-add-row" onclick="addMedRow()">＋ Add Medicine</button>

      <hr class="divider">
      <div class="section-header" style="margin-bottom:12px;">
        <span class="section-title">📋 Advice / Instructions</span>
      </div>
      <div id="adviceRows"></div>
      <button class="btn-add-row" onclick="addAdviceRow()">＋ Add Advice</button>
    </div>
    <div class="modal-footer">
      <button class="btn btn-ghost" onclick="closeModal('formModal')">Cancel</button>
      <button class="btn btn-primary" onclick="saveTemplate()">💾 Save Template</button>
    </div>
  </div>
</div>

<!-- TOAST -->
<div class="toast" id="toast"></div>

<script>
// ═══════════════════════════════════════════
//  STATE
// ═══════════════════════════════════════════
const API = 'api/templates';
let allTemplates  = [];
let activeId      = null;
let editingId     = null;

// ═══════════════════════════════════════════
//  INIT
// ═══════════════════════════════════════════
document.addEventListener('DOMContentLoaded', loadTemplates);

async function loadTemplates() {
  try {
    const res  = await fetch(API);
    allTemplates = await res.json();
    renderSidebar(allTemplates);
  } catch (err) {
    showToast('❌ Failed to load templates', 'error');
    // Demo mode: use sample data when backend isn't running
    allTemplates = getSampleData();
    renderSidebar(allTemplates);
  }
}

// ═══════════════════════════════════════════
//  SIDEBAR RENDER
// ═══════════════════════════════════════════
function renderSidebar(templates) {
  const list = document.getElementById('templatesList');
  if (!templates.length) {
    list.innerHTML = '<p style="padding:24px;text-align:center;color:var(--muted);font-size:0.85rem;">No templates found.</p>';
    return;
  }
  list.innerHTML = templates.map(t => `
    <button class="template-btn ${t.id === activeId ? 'active' : ''}"
            onclick="showTemplate(${t.id})">
      <div class="t-icon" style="background:${t.colorTag}22; color:${t.colorTag};">${t.icon}</div>
      <span class="t-name">${escHtml(t.diseaseName)}</span>
      <span class="t-count">${(t.medicines||[]).length} med</span>
    </button>
  `).join('');
}

function filterTemplates(q) {
  const filtered = allTemplates.filter(t =>
    t.diseaseName.toLowerCase().includes(q.toLowerCase()));
  renderSidebar(filtered);
}

// ═══════════════════════════════════════════
//  DETAIL VIEW
// ═══════════════════════════════════════════
function showTemplate(id) {
  activeId = id;
  renderSidebar(allTemplates);
  const t = allTemplates.find(x => x.id === id);
  if (!t) return;

  document.getElementById('emptyState').style.display  = 'none';
  document.getElementById('detailView').style.display  = 'block';

  document.getElementById('detailView').innerHTML = `
    <div class="detail-header">
      <div class="detail-title-group">
        <div class="detail-icon" style="background:${t.colorTag}22; color:${t.colorTag};">${t.icon}</div>
        <div>
          <div class="detail-name">${escHtml(t.diseaseName)}</div>
          <div class="detail-desc">${escHtml(t.description || 'Treatment protocol')}</div>
        </div>
      </div>
      <div class="detail-actions">
        <button class="btn btn-ghost" onclick="openEditModal(${t.id})">✏️ Edit</button>
        <button class="btn btn-danger" onclick="deleteTemplate(${t.id})">🗑️ Delete</button>
      </div>
    </div>

    <!-- Auto-fill Banner -->
    <div class="autofill-banner">
      <div class="banner-text">
        <h3>⚡ One-Click Auto Fill</h3>
        <p>Fill prescription form instantly with all medicines and advice from this template</p>
      </div>
      <button class="btn-autofill" id="autoFillBtn" onclick="autoFillPrescription(${t.id})">
        📋 Auto Fill Prescription
      </button>
    </div>

    <!-- Medicines -->
    <div class="section">
      <div class="section-header">
        <span class="section-title">💊 Medicines</span>
        <span class="section-badge">${(t.medicines||[]).length} items</span>
      </div>
      <div class="medicines-grid">
        ${(t.medicines || []).map(m => `
          <div class="med-card">
            <div class="med-name">💊 ${escHtml(m.medicineName)}</div>
            <div class="med-meta">
              <div class="med-row">
                <span class="med-label">Dosage</span>
                <span class="med-value">${escHtml(m.dosage || '—')}</span>
              </div>
              <div class="med-row">
                <span class="med-label">Duration</span>
                <span class="med-value">${escHtml(m.duration || '—')}</span>
              </div>
              ${m.instructions ? `<div class="med-instr">📌 ${escHtml(m.instructions)}</div>` : ''}
            </div>
          </div>
        `).join('')}
      </div>
    </div>

    <!-- Advice -->
    ${(t.adviceList && t.adviceList.length) ? `
    <div class="section">
      <div class="section-header">
        <span class="section-title">📋 Patient Advice</span>
        <span class="section-badge">${t.adviceList.length} items</span>
      </div>
      <div class="advice-list">
        ${t.adviceList.map(a => `
          <div class="advice-item">
            <div class="advice-dot"></div>
            <span>${escHtml(a)}</span>
          </div>
        `).join('')}
      </div>
    </div>` : ''}
  `;
}

// ═══════════════════════════════════════════
//  AUTO FILL — Opens prescription preview
// ═══════════════════════════════════════════
function autoFillPrescription(id) {
  const t   = allTemplates.find(x => x.id === id);
  const btn = document.getElementById('autoFillBtn');
  btn.classList.add('filled');
  btn.textContent = '✅ Filled!';
  setTimeout(() => {
    btn.classList.remove('filled');
    btn.innerHTML = '📋 Auto Fill Prescription';
  }, 2000);

  const today = new Date().toLocaleDateString('en-IN', {day:'2-digit',month:'long',year:'numeric'});
  document.getElementById('rxModalBody').innerHTML = `
    <div class="rx-header">
      <span class="rx-symbol">℞</span>
      <div class="rx-disease">${escHtml(t.diseaseName)} — ${t.icon}</div>
      <div class="rx-date">Date: ${today}</div>
    </div>
    <div class="rx-section">
      <div class="rx-section-title">Medications (${(t.medicines||[]).length})</div>
      ${(t.medicines||[]).map(m => `
        <div class="rx-med-row">
          <div class="rx-med-name">💊 ${escHtml(m.medicineName)}</div>
          <div class="rx-med-info">
            ${escHtml(m.dosage)} &nbsp;·&nbsp; ${escHtml(m.duration)}<br>
            <small>${escHtml(m.instructions||'')}</small>
          </div>
        </div>
      `).join('')}
    </div>
    ${(t.adviceList && t.adviceList.length) ? `
    <div class="rx-section">
      <div class="rx-section-title">Advice & Instructions</div>
      ${t.adviceList.map(a => `
        <div class="rx-advice-item">✅ ${escHtml(a)}</div>
      `).join('')}
    </div>` : ''}
    <div style="margin-top:20px;padding:14px;background:var(--card);border-radius:10px;
                font-size:0.78rem;color:var(--muted);text-align:center;">
      Doctor's Signature: _______________________
    </div>
  `;
  document.getElementById('rxModal').classList.add('open');
  showToast('✅ Prescription filled from template!');
}

function printRx() {
  const content = document.getElementById('rxModalBody').innerHTML;
  const win = window.open('', '_blank');
  win.document.write(`<!DOCTYPE html><html><head><title>Prescription</title>
    <style>
      body { font-family: Arial; padding: 30px; color: #111; }
      .rx-symbol { font-size: 36px; font-weight: 900; color: #1a56db; }
      .rx-disease { font-size: 20px; font-weight: 700; margin: 6px 0; }
      .rx-header { text-align: center; border: 2px solid #1a56db; padding: 16px; border-radius: 10px; margin-bottom: 20px; }
      .rx-med-row { display: flex; justify-content: space-between; padding: 8px 12px; border-bottom: 1px solid #eee; }
      .rx-section-title { font-weight: 700; text-transform: uppercase; color: #666; font-size: 11px; letter-spacing: 1px; margin-bottom: 8px; }
      .rx-advice-item { padding: 6px 0; border-bottom: 1px solid #eee; }
    </style></head><body>${content}</body></html>`);
  win.document.close(); win.print();
}

// ═══════════════════════════════════════════
//  ADD / EDIT MODAL
// ═══════════════════════════════════════════
function openAddModal() {
  editingId = null;
  document.getElementById('formModalTitle').textContent = '➕ Add Disease Template';
  document.getElementById('f_name').value  = '';
  document.getElementById('f_icon').value  = '💊';
  document.getElementById('f_color').value = '#4f9cf9';
  document.getElementById('f_desc').value  = '';
  document.getElementById('medRows').innerHTML    = '';
  document.getElementById('adviceRows').innerHTML = '';
  addMedRow(); addMedRow();
  addAdviceRow();
  document.getElementById('formModal').classList.add('open');
}

function openEditModal(id) {
  const t = allTemplates.find(x => x.id === id);
  editingId = id;
  document.getElementById('formModalTitle').textContent = '✏️ Edit Template';
  document.getElementById('f_name').value  = t.diseaseName;
  document.getElementById('f_icon').value  = t.icon;
  document.getElementById('f_color').value = t.colorTag;
  document.getElementById('f_desc').value  = t.description || '';
  document.getElementById('medRows').innerHTML    = '';
  document.getElementById('adviceRows').innerHTML = '';
  (t.medicines || []).forEach(m => addMedRow(m));
  (t.adviceList || []).forEach(a => addAdviceRow(a));
  document.getElementById('formModal').classList.add('open');
}

function addMedRow(m = {}) {
  const div = document.createElement('div');
  div.className = 'dyn-row';
  div.innerHTML = `
    <input class="form-input med-name" placeholder="Medicine Name *" value="${escHtml(m.medicineName||'')}">
    <input class="form-input med-dosage" placeholder="Dosage" value="${escHtml(m.dosage||'')}">
    <input class="form-input med-duration" placeholder="Duration" value="${escHtml(m.duration||'')}">
    <input class="form-input med-instr" placeholder="Instructions" value="${escHtml(m.instructions||'')}">
    <button class="btn-remove" onclick="this.parentElement.remove()">✕</button>
  `;
  document.getElementById('medRows').appendChild(div);
}

function addAdviceRow(text = '') {
  const div = document.createElement('div');
  div.className = 'dyn-row-advice';
  div.innerHTML = `
    <input class="form-input advice-text" style="flex:1" placeholder="e.g., Drink plenty of water" value="${escHtml(text)}">
    <button class="btn-remove" onclick="this.parentElement.remove()">✕</button>
  `;
  document.getElementById('adviceRows').appendChild(div);
}

async function saveTemplate() {
  const name = document.getElementById('f_name').value.trim();
  if (!name) { showToast('Disease name is required!', 'error'); return; }

  const medicines = [...document.querySelectorAll('#medRows .dyn-row')]
    .map(row => ({
      medicineName: row.querySelector('.med-name').value.trim(),
      dosage:       row.querySelector('.med-dosage').value.trim(),
      duration:     row.querySelector('.med-duration').value.trim(),
      instructions: row.querySelector('.med-instr').value.trim()
    })).filter(m => m.medicineName);

  const adviceList = [...document.querySelectorAll('#adviceRows .advice-text')]
    .map(i => i.value.trim()).filter(Boolean);

  const payload = {
    diseaseName: name,
    icon:        document.getElementById('f_icon').value || '💊',
    colorTag:    document.getElementById('f_color').value,
    description: document.getElementById('f_desc').value.trim(),
    medicines, adviceList
  };

  try {
    let res;
    if (editingId) {
      res = await fetch(`${API}/${editingId}`, { method:'PUT', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload) });
    } else {
      res = await fetch(API, { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload) });
    }
    const data = await res.json();
    if (data.success) {
      closeModal('formModal');
      showToast(editingId ? '✅ Template updated!' : '✅ Template created!');
      await loadTemplates();
      if (editingId) showTemplate(editingId);
      else if (data.id) showTemplate(data.id);
    } else {
      showToast('❌ Save failed: ' + data.error, 'error');
    }
  } catch (err) {
    // Demo mode — update local state
    if (editingId) {
      const idx = allTemplates.findIndex(x => x.id === editingId);
      allTemplates[idx] = { id: editingId, ...payload };
      showTemplate(editingId);
    } else {
      const newId = Date.now();
      allTemplates.push({ id: newId, ...payload });
      showTemplate(newId);
    }
    renderSidebar(allTemplates);
    closeModal('formModal');
    showToast(editingId ? '✅ Template updated!' : '✅ Template created!');
  }
}

async function deleteTemplate(id) {
  if (!confirm('Delete this template? This cannot be undone.')) return;
  try {
    const res  = await fetch(`${API}/${id}`, { method: 'DELETE' });
    const data = await res.json();
    if (data.success) doDelete(id);
    else showToast('❌ Delete failed', 'error');
  } catch (err) {
    doDelete(id);
  }
}

function doDelete(id) {
  allTemplates = allTemplates.filter(x => x.id !== id);
  activeId = null;
  renderSidebar(allTemplates);
  document.getElementById('emptyState').style.display  = 'flex';
  document.getElementById('detailView').style.display  = 'none';
  showToast('🗑️ Template deleted');
}

// ═══════════════════════════════════════════
//  UTILS
// ═══════════════════════════════════════════
function closeModal(id) { document.getElementById(id).classList.remove('open'); }

function showToast(msg, type = 'success') {
  const t = document.getElementById('toast');
  t.textContent = msg;
  t.className   = 'toast show' + (type === 'error' ? ' error' : '');
  setTimeout(() => t.className = 'toast', 3000);
}

function escHtml(str) {
  return String(str).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

// Close modals on overlay click
document.querySelectorAll('.modal-overlay').forEach(overlay => {
  overlay.addEventListener('click', e => { if (e.target === overlay) overlay.classList.remove('open'); });
});

// ═══════════════════════════════════════════
//  DEMO DATA (runs when backend is offline)
// ═══════════════════════════════════════════
function getSampleData() {
  return [
    { id:1, diseaseName:'Fever', icon:'🌡️', colorTag:'#ef4444', description:'Common fever treatment protocol',
      medicines:[
        {medicineName:'Paracetamol 500mg', dosage:'1 tablet', duration:'3 days', instructions:'Every 6 hours if temp > 101°F'},
        {medicineName:'ORS Sachet',        dosage:'1 sachet', duration:'3 days', instructions:'Drink throughout the day'},
        {medicineName:'Vitamin C 500mg',   dosage:'1 tablet', duration:'5 days', instructions:'Once daily after meal'}
      ],
      adviceList:['Complete bed rest advised','Drink 3-4 liters of water daily','Sponge bath if temp > 103°F','Return if fever persists beyond 3 days']
    },
    { id:2, diseaseName:'Cold & Cough', icon:'🤧', colorTag:'#3b82f6', description:'Upper respiratory infection protocol',
      medicines:[
        {medicineName:'Cetirizine 10mg',  dosage:'1 tablet', duration:'5 days', instructions:'Once daily at night'},
        {medicineName:'Ambroxol Syrup',   dosage:'10ml',     duration:'5 days', instructions:'Three times daily'},
        {medicineName:'Vitamin C 1000mg', dosage:'1 tablet', duration:'7 days', instructions:'Once daily'}
      ],
      adviceList:['Steam inhalation twice daily','Avoid cold drinks and ice cream','Warm saline gargling 3x daily']
    },
    { id:3, diseaseName:'Hypertension', icon:'❤️', colorTag:'#8b5cf6', description:'High blood pressure management',
      medicines:[
        {medicineName:'Amlodipine 5mg',   dosage:'1 tablet', duration:'30 days', instructions:'Once daily morning'},
        {medicineName:'Telmisartan 40mg', dosage:'1 tablet', duration:'30 days', instructions:'Once daily morning'},
        {medicineName:'Aspirin 75mg',     dosage:'1 tablet', duration:'30 days', instructions:'Once daily after breakfast'}
      ],
      adviceList:['Monitor BP daily - target < 130/80','Low salt diet (< 5g/day)','Regular walking 30 min daily']
    },
    { id:4, diseaseName:'Diabetes Type 2', icon:'🩸', colorTag:'#10b981', description:'Type 2 diabetes management',
      medicines:[
        {medicineName:'Metformin 500mg',    dosage:'1 tablet', duration:'30 days', instructions:'Twice daily after meal'},
        {medicineName:'Glimepiride 1mg',    dosage:'1 tablet', duration:'30 days', instructions:'Before breakfast'},
        {medicineName:'Vitamin B12 500mcg', dosage:'1 tablet', duration:'30 days', instructions:'Once daily'}
      ],
      adviceList:['Check blood sugar fasting + PP weekly','Diabetic diet: avoid sugar/maida','Exercise 45 minutes daily']
    },
    { id:5, diseaseName:'Migraine', icon:'🧠', colorTag:'#f97316', description:'Migraine headache protocol',
      medicines:[
        {medicineName:'Sumatriptan 50mg', dosage:'1 tablet', duration:'As needed', instructions:'At onset of headache'},
        {medicineName:'Ibuprofen 400mg',  dosage:'1 tablet', duration:'3 days',    instructions:'Every 8 hours with food'}
      ],
      adviceList:['Rest in a dark, quiet room','Apply cold pack on forehead','Identify and avoid triggers']
    }
  ];
}
</script>
</body>
</html>
