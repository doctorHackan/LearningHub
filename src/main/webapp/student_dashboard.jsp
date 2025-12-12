<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cms.dao.CourseDAO, com.cms.dao.EnrollmentDAO, com.cms.model.Course, com.cms.model.User, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <nav class="navbar navbar-dark bg-dark">
        <span class="navbar-brand mb-0 h1">Course Management - Student</span>
        <a href="login.jsp" class="btn btn-outline-light">Logout</a>
    </nav>

    <div class="container mt-5">
        <% 
            // Session Check
            User user = (User) session.getAttribute("user");
            if(user == null) { response.sendRedirect("login.jsp"); return; }
        %>

        <% if(request.getParameter("msg") != null) { %> 
            <div class="alert alert-success"><%= request.getParameter("msg") %></div> 
        <% } %>
        
        <% if(request.getParameter("error") != null) { %> 
		    <div class="alert alert-danger">
		        <%= request.getParameter("error") %>
		    </div> 
		<% } %>

        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-success text-white">Available Courses</div>
                    <div class="card-body">
                        <table class="table">
                            <thead><tr><th>Course</th><th>Teacher</th><th>Action</th></tr></thead>
                            <tbody>
                                <% 
                                    CourseDAO courseDAO = new CourseDAO();
                                    List<Course> allCourses = courseDAO.getAllCoursesWithDetails();
                                    for(Course c : allCourses) {
                                %>
                                <tr>
                                    <td><%= c.getCourseName() %></td>
                                    <td><%= c.getTeacherName() %></td>
                                    <td>
                                        <form action="StudentController" method="post">
                                            <input type="hidden" name="action" value="enroll">
                                            <input type="hidden" name="courseId" value="<%= c.getId() %>">
                                            <button type="submit" class="btn btn-sm btn-primary">Enroll</button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-info text-white">My Registered Courses</div>
                    <div class="card-body">
                        <ul class="list-group">
                            <% 
                                EnrollmentDAO enrollDAO = new EnrollmentDAO();
                                List<Course> myCourses = enrollDAO.getStudentCourses(user.getId());
                                for(Course c : myCourses) {
                            %>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <%= c.getCourseName() %>
                                    <span class="badge badge-primary badge-pill"><%= c.getTeacherName() %></span>
                                </li>
                            <% } %>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>