package com.doctorconsult.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.doctorconsult.model.Consultation;
import com.doctorconsult.model.Doctor;
import com.doctorconsult.utility.DBConnection;

public class DoctorRegisterDaoImpl implements DoctorRegisterDao {
	
	public int insertDoctor(Doctor obj) {
		
		try {
			Connection con = DBConnection.getConnection();
			String query = "insert into doctors(first_name, last_name, email, phone_number, medical_license, specialization, experience, hospital_affiliation, password) values(?,?,?,?,?,?,?,?,?)";
			PreparedStatement pstmt = con.prepareStatement(query);
			pstmt.setString(1, obj.getFname());
			pstmt.setString(2, obj.getLname());
			pstmt.setString(3, obj.getEmail());
			pstmt.setString(4, obj.getPhone());
			pstmt.setString(5, obj.getLicense());
			pstmt.setString(6, obj.getSpecialization());
			pstmt.setInt(7, obj.getExpreience());
			pstmt.setString(8, obj.getAffilation());
			pstmt.setString(9, obj.getPassword());
			
			int insert = pstmt.executeUpdate();
			if(insert>0) {
				return insert;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}

	@Override
	public Doctor checkLogin(String email, String password) {
		// TODO Auto-generated method stub
		Doctor d = null;
		
		try {
			Connection con = DBConnection.getConnection();
			String query = "select * from doctors where email=? and password=?";
			PreparedStatement pstmt = con.prepareStatement(query);
			pstmt.setString(1, email);
			pstmt.setString(2, password);
			ResultSet rs = pstmt.executeQuery();
			if(rs.next()) {
				d = new Doctor();
				
				d.setFname(rs.getString(2));
				d.setLname(rs.getString(3));
				d.setEmail(email);
				d.setPassword(password);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return d;
	}
	
	public List<Consultation> getAllConsultations() {
	    List<Consultation> list = new ArrayList<>();
	    try {
	        Connection con = DBConnection.getConnection();
	        String query = "SELECT * FROM patient_disease";
	        PreparedStatement pstmt = con.prepareStatement(query);
	        ResultSet rs = pstmt.executeQuery();
	        while (rs.next()) {
	            Consultation c = new Consultation();
	            c.setId(rs.getInt("id"));
	            c.setName(rs.getString("name"));
	            c.setDisease(rs.getString("disease"));
	            c.setType(rs.getString("type"));
	            c.setLastV(rs.getDate("last_visit_time"));
	            c.setCurr(rs.getDate("scheduled_time"));
	            
	            list.add(c);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return list;
	}
}
