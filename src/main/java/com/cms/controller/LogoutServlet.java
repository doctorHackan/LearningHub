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

	
	/**
     * Handles HTTP GET requests to perform user logout.
     *
     * Steps performed by this method:
     * - Retrieves the existing HTTP session without creating a new one
     * - Removes the user attribute from the session if it exists
     * - Invalidates the session to terminate the login state
     * - Redirects the user to the login page with a logout confirmation message
     *
     * @param request  the HttpServletRequest object containing client request data
     * @param response the HttpServletResponse object used to send the response
     * @throws ServletException if a servlet-related error occurs
     * @throws IOException if an input or output error occurs during redirection
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Fetch the current session. 'false' means don't create a new one if it doesn't exist.
        HttpSession session = request.getSession(false);
        
        // 2. If a session exists, invalidate it (destroy it).
        if (session != null) {
            session.removeAttribute("user"); 
            session.invalidate(); // This kills the session
        }
        
        // 3. Redirect the user to login page with a success message
        response.sendRedirect("login.jsp?msg=You have been logged out successfully.");
    }

}
