package com.clinic.servlet;

import com.clinic.dao.TemplateDAO;
import com.clinic.model.DiseaseTemplate;
import com.clinic.model.Medicine;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;

@WebServlet("/api/templates/*")
public class TemplateServlet extends HttpServlet {

    private final TemplateDAO dao = new TemplateDAO();
    private final Gson gson = new GsonBuilder().create();

    // ─── GET: fetch all or single ──────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        try {
            String pathInfo = req.getPathInfo();
            if (pathInfo != null && pathInfo.length() > 1) {
                int id = Integer.parseInt(pathInfo.substring(1));
                DiseaseTemplate t = dao.getTemplateById(id);
                if (t != null) out.print(gson.toJson(t));
                else sendError(resp, 404, "Template not found");
            } else {
                List<DiseaseTemplate> all = dao.getAllTemplates();
                out.print(gson.toJson(all));
            }
        } catch (Exception e) {
            sendError(resp, 500, e.getMessage());
        }
    }

    // ─── POST: create new template ─────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try {
            DiseaseTemplate t = parseTemplate(req);
            int newId = dao.addTemplate(t);
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("id", newId);
            result.put("message", "Template created successfully");
            resp.getWriter().print(gson.toJson(result));
        } catch (Exception e) {
            sendError(resp, 500, e.getMessage());
        }
    }

    // ─── PUT: update existing template ────────────
    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try {
            String pathInfo = req.getPathInfo();
            if (pathInfo == null || pathInfo.length() <= 1) {
                sendError(resp, 400, "Template ID required");
                return;
            }
            int id = Integer.parseInt(pathInfo.substring(1));
            DiseaseTemplate t = parseTemplate(req);
            t.setId(id);
            boolean ok = dao.updateTemplate(t);
            Map<String, Object> result = new HashMap<>();
            result.put("success", ok);
            result.put("message", ok ? "Template updated successfully" : "Update failed");
            resp.getWriter().print(gson.toJson(result));
        } catch (Exception e) {
            sendError(resp, 500, e.getMessage());
        }
    }

    // ─── DELETE: remove template ───────────────────
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try {
            String pathInfo = req.getPathInfo();
            if (pathInfo == null || pathInfo.length() <= 1) {
                sendError(resp, 400, "Template ID required");
                return;
            }
            int id = Integer.parseInt(pathInfo.substring(1));
            boolean ok = dao.deleteTemplate(id);
            Map<String, Object> result = new HashMap<>();
            result.put("success", ok);
            result.put("message", ok ? "Template deleted" : "Delete failed");
            resp.getWriter().print(gson.toJson(result));
        } catch (Exception e) {
            sendError(resp, 500, e.getMessage());
        }
    }

    // ─── Parse JSON body into DiseaseTemplate ──────
    @SuppressWarnings("unchecked")
    private DiseaseTemplate parseTemplate(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = req.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
        }
        Map<String, Object> data = gson.fromJson(sb.toString(), Map.class);

        DiseaseTemplate t = new DiseaseTemplate();
        t.setDiseaseName((String) data.getOrDefault("diseaseName", ""));
        t.setIcon((String) data.getOrDefault("icon", "💊"));
        t.setColorTag((String) data.getOrDefault("colorTag", "#3b82f6"));
        t.setDescription((String) data.getOrDefault("description", ""));

        // Parse medicines
        List<Map<String, String>> meds = (List<Map<String, String>>) data.get("medicines");
        if (meds != null) {
            for (Map<String, String> m : meds) {
                Medicine med = new Medicine(
                    m.getOrDefault("medicineName", ""),
                    m.getOrDefault("dosage", ""),
                    m.getOrDefault("duration", ""),
                    m.getOrDefault("instructions", "")
                );
                t.getMedicines().add(med);
            }
        }

        // Parse advice
        List<String> advice = (List<String>) data.get("adviceList");
        if (advice != null) t.setAdviceList(advice);

        return t;
    }

    private void sendError(HttpServletResponse resp, int status, String msg) throws IOException {
        resp.setStatus(status);
        Map<String, Object> err = new HashMap<>();
        err.put("success", false);
        err.put("error", msg);
        resp.getWriter().print(gson.toJson(err));
    }
}
