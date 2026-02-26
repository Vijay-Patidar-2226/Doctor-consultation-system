package com.doctorconsult.dao;

import com.doctorconsult.model.Doctor;

public interface DoctorRegisterDao {

	public int insertDoctor(Doctor obj);
	public Doctor checkLogin(String email, String password);
}
