package com.cms.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.cms.dao.CourseDAO;
import com.cms.model.Course;


/**
 * Controller Servlet for Administrator operations.
 * This servlet handles requests related to course management, such as adding new courses
 * and assigning teachers to them.
 */
@WebServlet("/AdminController")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    
    /**
     * Handles HTTP POST requests coming from the Admin Dashboard.
     * Processes form submissions to add new courses to the database.
     *
     * @param request  The HttpServletRequest object containing form data (action, courseName, teacherId).
     * @param response The HttpServletResponse object used to redirect the user after processing.
     * @throws ServletException If a servlet-specific error occurs.
     * @throws IOException      If an I/O error occurs.
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("addCourse".equals(action)) {
            String courseName = request.getParameter("courseName");
            int teacherId = Integer.parseInt(request.getParameter("teacherId"));

            Course course = new Course();
            course.setCourseName(courseName);
            course.setTeacherId(teacherId);

            CourseDAO dao = new CourseDAO();
            boolean success = dao.addCourse(course);

            if (success) {
                response.sendRedirect("admin_dashboard.jsp?msg=Course Added Successfully");
            } else {
                response.sendRedirect("admin_dashboard.jsp?error=Failed to Add Course");
            }
        }
    }
}