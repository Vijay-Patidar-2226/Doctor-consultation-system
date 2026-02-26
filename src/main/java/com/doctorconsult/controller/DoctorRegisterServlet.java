package com.doctorconsult.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;

import com.doctorconsult.dao.DoctorRegisterDao;
import com.doctorconsult.dao.DoctorRegisterDaoImpl;
import com.doctorconsult.dao.PatientRegister;
import com.doctorconsult.dao.PatientRegsiterImpl;
import com.doctorconsult.model.Doctor;
import com.doctorconsult.model.Patient;

/**
 * Servlet implementation class DoctorRegisterServlet
 */
@WebServlet("/DoctorRegisterServlet")
public class DoctorRegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DoctorRegisterServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String fname = request.getParameter("firstName");
		String lname = request.getParameter("lastName");		
		String email = request.getParameter("registerEmail");
		String phone = request.getParameter("phoneNumber");
		String medical = request.getParameter("medicalLicense");
		String specialization = request.getParameter("specialization");
		String experience = request.getParameter("experience");
		int exp = Integer.parseInt(experience);
		String password = request.getParameter("registerPassword");
		String hospitalAffiliation = request.getParameter("hospitalAffiliation");
		
		Doctor d = new Doctor();
		d.setFname(fname);
		d.setLname(lname);
		d.setEmail(email);
		d.setLicense(medical);
		d.setSpecialization(specialization);
		d.setExpreience(exp);
		d.setPhone(phone);
		d.setAffilation(hospitalAffiliation);
		d.setPassword(password);
		
		DoctorRegisterDao dd = new DoctorRegisterDaoImpl();
		int insert = dd.insertDoctor(d);
		
		if(insert>0) {
			HttpSession session = request.getSession();
			session.setAttribute("success", "Registration Successfull");
			response.sendRedirect("d-reg-login.jsp");
		}
	}

}
