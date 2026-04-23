package com.clinic.dao;

import com.clinic.model.DiseaseTemplate;
import com.clinic.model.Medicine;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TemplateDAO {

    // ─────────────────────────────────────────────
    // GET ALL TEMPLATES (with medicines & advice)
    // ─────────────────────────────────────────────
    public List<DiseaseTemplate> getAllTemplates() throws SQLException {
        List<DiseaseTemplate> list = new ArrayList<>();
        String sql = "SELECT * FROM disease_templates ORDER BY disease_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                DiseaseTemplate t = mapTemplate(rs);
                t.setMedicines(getMedicinesForTemplate(conn, t.getId()));
                t.setAdviceList(getAdviceForTemplate(conn, t.getId()));
                list.add(t);
            }
        }
        return list;
    }

    // ─────────────────────────────────────────────
    // GET SINGLE TEMPLATE BY ID
    // ─────────────────────────────────────────────
    public DiseaseTemplate getTemplateById(int id) throws SQLException {
        String sql = "SELECT * FROM disease_templates WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DiseaseTemplate t = mapTemplate(rs);
                    t.setMedicines(getMedicinesForTemplate(conn, id));
                    t.setAdviceList(getAdviceForTemplate(conn, id));
                    return t;
                }
            }
        }
        return null;
    }

    // ─────────────────────────────────────────────
    // ADD NEW TEMPLATE
    // ─────────────────────────────────────────────
    public int addTemplate(DiseaseTemplate t) throws SQLException {
        String sql = "INSERT INTO disease_templates (disease_name, icon, color_tag, description) VALUES (?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, t.getDiseaseName());
            ps.setString(2, t.getIcon());
            ps.setString(3, t.getColorTag());
            ps.setString(4, t.getDescription());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int newId = keys.getInt(1);
                    saveMedicines(conn, newId, t.getMedicines());
                    saveAdvice(conn, newId, t.getAdviceList());
                    return newId;
                }
            }
        }
        return -1;
    }

    // ─────────────────────────────────────────────
    // UPDATE TEMPLATE
    // ─────────────────────────────────────────────
    public boolean updateTemplate(DiseaseTemplate t) throws SQLException {
        String sql = "UPDATE disease_templates SET disease_name=?, icon=?, color_tag=?, description=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getDiseaseName());
            ps.setString(2, t.getIcon());
            ps.setString(3, t.getColorTag());
            ps.setString(4, t.getDescription());
            ps.setInt(5, t.getId());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                // Delete existing and re-insert
                deleteMedicinesForTemplate(conn, t.getId());
                deleteAdviceForTemplate(conn, t.getId());
                saveMedicines(conn, t.getId(), t.getMedicines());
                saveAdvice(conn, t.getId(), t.getAdviceList());
                return true;
            }
        }
        return false;
    }

    // ─────────────────────────────────────────────
    // DELETE TEMPLATE
    // ─────────────────────────────────────────────
    public boolean deleteTemplate(int id) throws SQLException {
        String sql = "DELETE FROM disease_templates WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ─────────────────────────────────────────────
    // PRIVATE HELPERS
    // ─────────────────────────────────────────────
    private DiseaseTemplate mapTemplate(ResultSet rs) throws SQLException {
        DiseaseTemplate t = new DiseaseTemplate();
        t.setId(rs.getInt("id"));
        t.setDiseaseName(rs.getString("disease_name"));
        t.setIcon(rs.getString("icon"));
        t.setColorTag(rs.getString("color_tag"));
        t.setDescription(rs.getString("description"));
        return t;
    }

    private List<Medicine> getMedicinesForTemplate(Connection conn, int templateId) throws SQLException {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT * FROM template_medicines WHERE template_id=? ORDER BY sort_order";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, templateId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Medicine m = new Medicine();
                    m.setId(rs.getInt("id"));
                    m.setTemplateId(templateId);
                    m.setMedicineName(rs.getString("medicine_name"));
                    m.setDosage(rs.getString("dosage"));
                    m.setDuration(rs.getString("duration"));
                    m.setInstructions(rs.getString("instructions"));
                    m.setSortOrder(rs.getInt("sort_order"));
                    list.add(m);
                }
            }
        }
        return list;
    }

    private List<String> getAdviceForTemplate(Connection conn, int templateId) throws SQLException {
        List<String> list = new ArrayList<>();
        String sql = "SELECT advice_text FROM template_advice WHERE template_id=? ORDER BY sort_order";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, templateId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(rs.getString("advice_text"));
            }
        }
        return list;
    }

    private void saveMedicines(Connection conn, int templateId, List<Medicine> medicines) throws SQLException {
        if (medicines == null || medicines.isEmpty()) return;
        String sql = "INSERT INTO template_medicines (template_id, medicine_name, dosage, duration, instructions, sort_order) VALUES (?,?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < medicines.size(); i++) {
                Medicine m = medicines.get(i);
                ps.setInt(1, templateId);
                ps.setString(2, m.getMedicineName());
                ps.setString(3, m.getDosage());
                ps.setString(4, m.getDuration());
                ps.setString(5, m.getInstructions());
                ps.setInt(6, i);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private void saveAdvice(Connection conn, int templateId, List<String> adviceList) throws SQLException {
        if (adviceList == null || adviceList.isEmpty()) return;
        String sql = "INSERT INTO template_advice (template_id, advice_text, sort_order) VALUES (?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < adviceList.size(); i++) {
                ps.setInt(1, templateId);
                ps.setString(2, adviceList.get(i));
                ps.setInt(3, i);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private void deleteMedicinesForTemplate(Connection conn, int templateId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM template_medicines WHERE template_id=?")) {
            ps.setInt(1, templateId);
            ps.executeUpdate();
        }
    }

    private void deleteAdviceForTemplate(Connection conn, int templateId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM template_advice WHERE template_id=?")) {
            ps.setInt(1, templateId);
            ps.executeUpdate();
        }
    }
}
