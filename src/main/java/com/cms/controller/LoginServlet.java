package com.cms.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.cms.dao.UserDAO;
import com.cms.model.User;


/**
 * Controller Servlet for handling User Authentication.
 * Redirects users to their specific dashboards based on their role.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles HTTP POST requests triggered by the login form.
     * This method performs the following steps:
     * 1. Retrieves username and password from the request parameters.
     * 2. Uses the UserDAO to verify credentials.
     * 3. If valid, creates a secure session and redirects the user to the
     * appropriate dashboard (Admin, Teacher, or Student).
     * 4. If invalid, returns the user to the login page with an error message.
     *
     * @param request  The HttpServletRequest object containing login credentials.
     * @param response The HttpServletResponse object used for redirection or forwarding.
     * @throws ServletException If a servlet-specific error occurs.
     * @throws IOException      If an I/O error occurs during redirection.
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String uName = request.getParameter("username");
        String pass = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.checkLogin(uName, pass);

        if (user != null) {
            // Create Session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Redirect based on Role
            String destPage = "login.jsp";
            switch(user.getRole()) {
                case "admin":
                    destPage = "admin_dashboard.jsp";
                    break;
                case "teacher":
                    destPage = "teacher_dashboard.jsp";
                    break;
                case "student":
                    destPage = "student_dashboard.jsp";
                    break;
            }
            response.sendRedirect(destPage);
        } else {
            // Login Failed
            String message = "Invalid email or password";
            request.setAttribute("message", message);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}