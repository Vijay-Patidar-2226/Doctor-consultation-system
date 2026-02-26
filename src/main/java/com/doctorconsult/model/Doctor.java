package com.doctorconsult.model;

public class Doctor {
	
	private int id;
	private String fname;
	private String lname;
	private String email;
	private String phone;
	private String license;
	private String specialization;
	private int expreience;
	private String affilation;
	private String password;
	
	public Doctor() {
		
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getFname() {
		return fname;
	}

	public void setFname(String fname) {
		this.fname = fname;
	}

	public String getLname() {
		return lname;
	}

	public void setLname(String lname) {
		this.lname = lname;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getLicense() {
		return license;
	}

	public void setLicense(String license) {
		this.license = license;
	}

	public String getSpecialization() {
		return specialization;
	}

	public void setSpecialization(String specialization) {
		this.specialization = specialization;
	}

	public int getExpreience() {
		return expreience;
	}

	public void setExpreience(int expreience) {
		this.expreience = expreience;
	}

	public String getAffilation() {
		return affilation;
	}

	public void setAffilation(String affilation) {
		this.affilation = affilation;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
}
