package com.cms.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.cms.dao.EnrollmentDAO;
import com.cms.model.User;

@WebServlet("/StudentController")
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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
                    response.sendRedirect("student_dashboard.jsp?error=Enrollment Failed");
                }
            } else {
                response.sendRedirect("login.jsp");
            }
        }
    }
}