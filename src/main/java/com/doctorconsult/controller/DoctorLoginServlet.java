package com.doctorconsult.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import com.doctorconsult.dao.DoctorRegisterDao;
import com.doctorconsult.dao.DoctorRegisterDaoImpl;
import com.doctorconsult.dao.PatientRegister;
import com.doctorconsult.dao.PatientRegsiterImpl;
import com.doctorconsult.model.Doctor;
import com.doctorconsult.model.Patient;

/**
 * Servlet implementation class DoctorLoginServlet
 */
@WebServlet("/DoctorLoginServlet")
public class DoctorLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DoctorLoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String email = request.getParameter("loginEmail");
		String password = request.getParameter("loginPassword");
		
		DoctorRegisterDao dd = new DoctorRegisterDaoImpl();
		Doctor d = dd.checkLogin(email, password);
		System.out.println(d);
		if(d==null) {
			HttpSession hs = request.getSession();
			hs.setAttribute("fail", "Invalid Username/Password");
			response.sendRedirect("d-reg-login.jsp");
		}
		else {
			HttpSession session = request.getSession();
			session.setAttribute("user", d);
			
			response.sendRedirect("d-dashboard.jsp");
		}

	}

}
