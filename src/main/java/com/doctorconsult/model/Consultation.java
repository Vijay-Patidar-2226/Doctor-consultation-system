package com.doctorconsult.model;

import java.sql.Date;

public class Consultation {
	private int id;
	private String name;
	private String disease;
	private String type;
	private Date lastV;
	private Date curr;
	
	public Consultation () {}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDisease() {
		return disease;
	}

	public void setDisease(String disease) {
		this.disease = disease;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Date getLastV() {
		return lastV;
	}

	public void setLastV(Date lastV) {
		this.lastV = lastV;
	}

	public Date getCurr() {
		return curr;
	}

	public void setCurr(Date curr) {
		this.curr = curr;
	}
	
}
