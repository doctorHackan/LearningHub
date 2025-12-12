package com.cms.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.cms.dao.UserDAO;
import com.cms.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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

            // Redirect based on Role (R-1)
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