package com.cms.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
/**
 * Servlet implementation class LogoutServlet
 */
@WebServlet("/LogoutController")
public class LogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Fetch the current session. 'false' means don't create a new one if it doesn't exist.
        HttpSession session = request.getSession(false);
        
        // 2. If a session exists, invalidate it (destroy it).
        if (session != null) {
            session.removeAttribute("user"); // Optional, but good practice to clear specific attributes
            session.invalidate(); // This kills the session
        }
        
        // 3. Redirect the user to login page with a success message
        response.sendRedirect("login.jsp?msg=You have been logged out successfully.");
    }

}
