package com.doctorconsult.controller;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.sql.*;

@WebServlet("/SavePrescription")
public class SavePrescription extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String patientName = request.getParameter("patientName");
        String disease = request.getParameter("disease");
        String symptoms = request.getParameter("symptoms");
        String medicines = request.getParameter("medicines");
        String dosage = request.getParameter("dosage");
        String days = request.getParameter("days");
        String notes = request.getParameter("notes");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/pre?allowPublicKeyRetrieval=true&useSSL=false",
                "root", "root");

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO prescription VALUES (null, ?, ?, ?, ?, ?, ?, ?, now())"
            );

            ps.setString(1, patientName);
            ps.setString(2, disease);
            ps.setString(3, symptoms);
            ps.setString(4, medicines);
            ps.setString(5, dosage);
            ps.setString(6, days);
            ps.setString(7, notes);

            ps.executeUpdate();
            con.close();

            response.sendRedirect("d-dashboard.jsp");

        } catch (Exception e) {
            PrintWriter out = response.getWriter();
            response.setContentType("text/html");
            out.println("<html><body>");
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
            out.println("</body></html>");
        }
    }
}