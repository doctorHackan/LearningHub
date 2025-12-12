package com.cms.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.cms.model.Course;
import com.cms.model.User;

public class EnrollmentDAO {
	
	// R-5: View registered students for a particular course
	public List<User> getEnrolledStudents(int courseId) {
	    List<User> students = new ArrayList<>();
	    String sql = "SELECT u.id, u.username FROM enrollments e " +
	                 "JOIN users u ON e.student_id = u.id " +
	                 "WHERE e.course_id = ?";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, courseId);
	        ResultSet rs = pstmt.executeQuery();

	        while (rs.next()) {
	            User s = new User();
	            s.setId(rs.getInt("id"));
	            s.setUsername(rs.getString("username"));
	            students.add(s);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return students;
	}

    // R-4: Register for a new course
	public boolean enrollStudent(int studentId, int courseId) {
	    // Query 1: Check if the enrollment exists
	    String checkSql = "SELECT 1 FROM enrollments WHERE student_id = ? AND course_id = ?";
	    // Query 2: The original insert query
	    String insertSql = "INSERT INTO enrollments (student_id, course_id) VALUES (?, ?)";

	    try (Connection conn = DBConnection.getConnection();
	         // Prepare the check statement first
	         PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

	        // --- Step 1: Check if already enrolled ---
	        checkStmt.setInt(1, studentId);
	        checkStmt.setInt(2, courseId);
	        
	        try (ResultSet rs = checkStmt.executeQuery()) {
	            if (rs.next()) {
	                // If rs.next() is true, a record exists.
	                // We do nothing and return false (indicating no new enrollment was made).
	                System.out.println("Student " + studentId + " is already enrolled in course " + courseId);
	                return false;
	            }
	        }

	        // --- Step 2: Insert the new enrollment ---
	        // If we passed the check, create the insert statement
	        try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
	            insertStmt.setInt(1, studentId);
	            insertStmt.setInt(2, courseId);

	            int rows = insertStmt.executeUpdate();
	            return rows > 0;
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    }
	}

    // R-4: View registered courses
    public List<Course> getStudentCourses(int studentId) {
        List<Course> courses = new ArrayList<>();
        // Join enrollments -> courses -> users (to get teacher name)
        String sql = "SELECT c.id, c.course_name, u.username as teacher_name " +
                     "FROM enrollments e " +
                     "JOIN courses c ON e.course_id = c.id " +
                     "JOIN users u ON c.teacher_id = u.id " +
                     "WHERE e.student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();

            while(rs.next()) {
                Course c = new Course();
                c.setId(rs.getInt("id"));
                c.setCourseName(rs.getString("course_name"));
                c.setTeacherName(rs.getString("teacher_name"));
                courses.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }
}