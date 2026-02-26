package com.doctorconsult.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.doctorconsult.model.Patient;
import com.doctorconsult.utility.DBConnection;

public class PatientRegsiterImpl implements PatientRegister {

	@Override
	public int insertPatient(Patient obj) {
		
		try {
			Connection con = DBConnection.getConnection();
			String query = "insert into patients(name, email, phone_no, dob, password) values(?,?,?,?,?)";
			PreparedStatement pstmt = con.prepareStatement(query);
			pstmt.setString(1, obj.getName());
			pstmt.setString(2, obj.getEmail());
			pstmt.setString(3, obj.getPhone());
			pstmt.setDate(4, obj.getDob());
			pstmt.setString(5, obj.getPassword());
			
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
	public Patient checkLogin(String email, String password) {
		// TODO Auto-generated method stub
		Patient p = null;
		
		try {
			Connection con = DBConnection.getConnection();
			String query = "select * from patients where email=? and password=?";
			PreparedStatement pstmt = con.prepareStatement(query);
			pstmt.setString(1, email);
			pstmt.setString(2, password);
			ResultSet rs = pstmt.executeQuery();
			if(rs.next()) {
				p = new Patient();
				
				p.setName(rs.getString(2));
				p.setEmail(email);
				p.setPassword(password);
				
				return p;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return p;
	}

}
