package com.cms.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.cms.model.Course;

public class CourseDAO {
	
	public List<Course> getCoursesByTeacher(int teacherId) {
	    List<Course> courses = new ArrayList<>();
	    String sql = "SELECT * FROM courses WHERE teacher_id = ?";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, teacherId);
	        ResultSet rs = pstmt.executeQuery();

	        while (rs.next()) {
	            Course c = new Course();
	            c.setId(rs.getInt("id"));
	            c.setCourseName(rs.getString("course_name"));
	            c.setTeacherId(teacherId);
	            courses.add(c);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return courses;
	}
	
	// Add imports: import java.util.ArrayList; import java.util.List; import com.cms.model.User;

	public List<Course> getAllCoursesWithDetails() {
	    List<Course> courses = new ArrayList<>();
	    // Join with users table to get the Teacher's name instead of just ID
	    String sql = "SELECT c.id, c.course_name, c.teacher_id, u.username as teacher_name " +
	                 "FROM courses c JOIN users u ON c.teacher_id = u.id";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {

	        while (rs.next()) {
	            Course c = new Course();
	            c.setId(rs.getInt("id"));
	            c.setCourseName(rs.getString("course_name"));
	            c.setTeacherId(rs.getInt("teacher_id"));
	            c.setTeacherName(rs.getString("teacher_name")); // Set the teacher's name
	            courses.add(c);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return courses;
	}

    public boolean addCourse(Course course) {
        String sql = "INSERT INTO courses (course_name, teacher_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, course.getCourseName());
            pstmt.setInt(2, course.getTeacherId());

            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}