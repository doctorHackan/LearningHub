package com.cms.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.cms.dao.EnrollmentDAO;
import com.cms.model.User;

/**
 * Controller Servlet for Student operations.
 * This servlet handles the business logic for students, specifically the ability
 * to register for new courses.
 */
@WebServlet("/StudentController")
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * Handles HTTP POST requests from the Student Dashboard.
     * Manages the course enrollment process by linking the logged-in student
     * to a selected course in the database.
     *
     * @param request  The HttpServletRequest object containing the "action" and "courseId".
     * @param response The HttpServletResponse object used to redirect the user after processing.
     * @throws ServletException If a servlet-specific error occurs.
     * @throws IOException      If an I/O error occurs.
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("enroll".equals(action)) {
            // Get current student from session
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user != null) {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                int studentId = user.getId();

                EnrollmentDAO dao = new EnrollmentDAO();
                boolean success = dao.enrollStudent(studentId, courseId);

                if (success) {
                    response.sendRedirect("student_dashboard.jsp?msg=Enrolled Successfully");
                } else {
                    response.sendRedirect("student_dashboard.jsp?error=Already Enrolled");
                }
            } else {
                response.sendRedirect("login.jsp");
            }
        }
    }
}