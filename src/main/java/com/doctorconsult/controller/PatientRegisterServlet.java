package com.doctorconsult.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;

import com.doctorconsult.dao.PatientRegister;
import com.doctorconsult.dao.PatientRegsiterImpl;
import com.doctorconsult.model.Patient;

/**
 * Servlet implementation class PatientRegisterServlet
 */
@WebServlet("/patientRegisterServlet")
public class PatientRegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PatientRegisterServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String dob = request.getParameter("dob");
		Date dob1 = Date.valueOf(dob);
		String password = request.getParameter("password");
		
		Patient p = new Patient();
		p.setName(name);
		p.setEmail(email);
		p.setPhone(phone);
		p.setDob(dob1);
		p.setPassword(password);
		
		PatientRegister pi = new PatientRegsiterImpl();
		int insert = pi.insertPatient(p);
		
		if(insert>0) {
			HttpSession session = request.getSession();
			session.setAttribute("success", "Registration Successfull");
			response.sendRedirect("p-reg-login.jsp");
		}
	}
	

}
