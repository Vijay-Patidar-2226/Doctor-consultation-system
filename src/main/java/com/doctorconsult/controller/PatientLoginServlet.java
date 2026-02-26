package com.doctorconsult.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import com.doctorconsult.dao.PatientRegister;
import com.doctorconsult.dao.PatientRegsiterImpl;
import com.doctorconsult.model.Patient;

/**
 * Servlet implementation class PatientLoginServlet
 */
@WebServlet("/patientLoginServlet")
public class PatientLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PatientLoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		
		PatientRegister pr = new PatientRegsiterImpl();
		
		Patient p = pr.checkLogin(email, password);
		
		if(p==null) {
			HttpSession hs = request.getSession();
			hs.setAttribute("fail", "Invalid Username/Password");
			response.sendRedirect("p-reg-login.jsp");
		}
		else {
			HttpSession session = request.getSession();
			session.setAttribute("user", p);
			
			response.sendRedirect("p-dashboard.jsp");
		}
	}

}
