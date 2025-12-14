package com.cms.dao;

import java.sql.*;
import java.util.ArrayList;

import com.cms.model.User;
import java.util.List;


/**
 * Data Access Object for User-related database operations.
 * Handles authentication and retrieval of teacher lists.
 */
public class UserDAO {
	/**
     * Retrieves a list of all users with the role 'teacher'.
     * Used by Admin to assign teachers to courses.
     * @return List of User objects.
     */
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
	
	/**
     * Authenticates a user against the database.
     * @param username The input username.
     * @param password The input password.
     * @return User object if credentials match, null otherwise.
     */
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