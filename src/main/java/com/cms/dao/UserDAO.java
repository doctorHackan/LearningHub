package com.cms.dao;

import java.sql.*;
import java.util.ArrayList;

import com.cms.model.User;
//import com.sun.tools.javac.util.List;
import java.util.List;

public class UserDAO {
	public List<User> getAllTeachers() {
	    List<User> teachers = new ArrayList<>();
	    String sql = "SELECT * FROM users WHERE role = 'teacher'";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {

	        while (rs.next()) {
	            User user = new User();
	            user.setId(rs.getInt("id"));
	            user.setUsername(rs.getString("username"));
	            teachers.add(user);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return teachers;
	}
    public User checkLogin(String username, String password) {
        User user = null;
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);
            pstmt.setString(2, password);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }
}