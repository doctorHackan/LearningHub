<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cms.dao.CourseDAO, com.cms.dao.EnrollmentDAO, com.cms.model.Course, com.cms.model.User, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Teacher Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <nav class="navbar navbar-dark bg-dark">
        <span class="navbar-brand mb-0 h1">Course Management - Teacher</span>
        <a href="login.jsp" class="btn btn-outline-light">Logout</a>
    </nav>

    <div class="container mt-5">
        <% 
            // Session Security Check
            User user = (User) session.getAttribute("user");
            if(user == null) { response.sendRedirect("login.jsp"); return; }

            // Get the selected course ID from URL (if any)
            String selectedCourseId = request.getParameter("courseId");
        %>

        <div class="row">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header bg-primary text-white">My Courses</div>
                    <div class="list-group list-group-flush">
                        <% 
                            CourseDAO courseDAO = new CourseDAO();
                            // Fetch courses only for this specific teacher
                            List<Course> myCourses = courseDAO.getCoursesByTeacher(user.getId());

                            for(Course c : myCourses) {
                                // Highlight the selected course
                                String activeClass = (selectedCourseId != null && Integer.parseInt(selectedCourseId) == c.getId()) ? "active" : "";
                        %>
                            <a href="teacher_dashboard.jsp?courseId=<%= c.getId() %>" 
                               class="list-group-item list-group-item-action <%= activeClass %>">
                                <%= c.getCourseName() %>
                            </a>
                        <% } %>

                        <% if(myCourses.isEmpty()) { %>
                            <div class="p-3 text-muted">No courses assigned yet.</div>
                        <% } %>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-secondary text-white">Enrolled Students</div>
                    <div class="card-body">
                        <% if(selectedCourseId != null) { 
                            int cId = Integer.parseInt(selectedCourseId);
                            EnrollmentDAO enrollDAO = new EnrollmentDAO();
                            List<User> students = enrollDAO.getEnrolledStudents(cId);
                        %>
                            <h5>Students in this course:</h5>
                            <% if(students.size() > 0) { %>
                                <table class="table table-striped mt-3">
                                    <thead><tr><th>ID</th><th>Student Name</th></tr></thead>
                                    <tbody>
                                        <% for(User s : students) { %>
                                        <tr>
                                            <td><%= s.getId() %></td>
                                            <td><%= s.getUsername() %></td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            <% } else { %>
                                <div class="alert alert-warning mt-3">No students have enrolled in this course yet.</div>
                            <% } %>

                        <% } else { %>
                            <div class="alert alert-info">Please select a course from the left menu to view students.</div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>