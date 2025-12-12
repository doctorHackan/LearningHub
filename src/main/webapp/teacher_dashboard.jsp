<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cms.dao.CourseDAO, com.cms.dao.EnrollmentDAO, com.cms.model.Course, com.cms.model.User, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Teacher Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm mb-4">
        <div class="container">
            <a class="navbar-brand" href="#"><i class="fas fa-chalkboard-teacher mr-2"></i>Teacher Portal</a>
            <div class="ml-auto">
                <a href="login.jsp" class="btn btn-outline-light btn-sm"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <% 
            User user = (User) session.getAttribute("user");
            if(user == null) { response.sendRedirect("login.jsp"); return; }
            String selectedCourseId = request.getParameter("courseId");
        %>

        <div class="row">
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="m-0">My Courses</h5>
                    </div>
                    <div class="list-group list-group-flush">
                        <% 
                            CourseDAO courseDAO = new CourseDAO();
                            List<Course> myCourses = courseDAO.getCoursesByTeacher(user.getId());
                            for(Course c : myCourses) {
                                String active = (selectedCourseId != null && Integer.parseInt(selectedCourseId) == c.getId()) ? "active" : "";
                        %>
                            <a href="teacher_dashboard.jsp?courseId=<%= c.getId() %>" class="list-group-item list-group-item-action <%= active %>">
                                <div class="d-flex w-100 justify-content-between">
                                    <h6 class="mb-1"><i class="fas fa-book mr-2"></i><%= c.getCourseName() %></h6>
                                </div>
                            </a>
                        <% } %>
                        <% if(myCourses.isEmpty()) { %>
                            <div class="p-3 text-muted text-center">No courses assigned.</div>
                        <% } %>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-header bg-white border-bottom-0">
                        <h5 class="text-secondary m-0">
                            <% if(selectedCourseId != null) { %>
                                <i class="fas fa-users mr-2"></i>Enrolled Students
                            <% } else { %>
                                <i class="fas fa-arrow-left mr-2"></i>Select a course
                            <% } %>
                        </h5>
                    </div>
                    <div class="card-body">
                        <% if(selectedCourseId != null) { 
                            int cId = Integer.parseInt(selectedCourseId);
                            EnrollmentDAO enrollDAO = new EnrollmentDAO();
                            List<User> students = enrollDAO.getEnrolledStudents(cId);
                        %>
                            <% if(students.size() > 0) { %>
                                <table class="table table-hover">
                                    <thead class="thead-light"><tr><th>ID</th><th>Student Name</th></tr></thead>
                                    <tbody>
                                        <% for(User s : students) { %>
                                        <tr>
                                            <td><span class="badge badge-secondary"><%= s.getId() %></span></td>
                                            <td><%= s.getUsername() %></td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            <% } else { %>
                                <div class="alert alert-warning">No students enrolled yet.</div>
                            <% } %>
                        <% } else { %>
                            <div class="text-center py-5 text-muted">
                                <i class="fas fa-chalkboard fa-3x mb-3"></i>
                                <p>Please select a course from the left menu to view details.</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <footer class="mt-5 mb-3 text-center text-muted">
        <small>&copy; 2025 LearningHub</small>
    </footer>
</body>
</html>