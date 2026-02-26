package com.doctorconsult.dao;

import com.doctorconsult.model.Patient;

public interface PatientRegister {
	
	public int insertPatient(Patient obj);
	public Patient checkLogin(String email, String password);
}
