<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cms.dao.CourseDAO, com.cms.dao.EnrollmentDAO, com.cms.model.Course, com.cms.model.User, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-info shadow-sm mb-4">
        <div class="container">
            <a class="navbar-brand" href="#"><i class="fas fa-user-graduate mr-2"></i>Student Portal</a>
            <div class="ml-auto">
                <a href="login.jsp" class="btn btn-outline-light btn-sm">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container">
        <% 
            User user = (User) session.getAttribute("user");
            if(user == null) { response.sendRedirect("login.jsp"); return; }
        %>

        <h2 class="mb-4 text-secondary">Welcome, <b><%= user.getUsername() %></b>!</h2>

        <% if(request.getParameter("msg") != null) { %> 
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= request.getParameter("msg") %></div> 
        <% } %>
        
        <% if(request.getParameter("error") != null) { %> 
            <div class="alert alert-danger"> <%= request.getParameter("error") %></div> 
        <% } %>

        <div class="row">
            <div class="col-md-7">
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-white border-bottom-0">
                        <h5 class="text-primary m-0"><i class="fas fa-list mr-2"></i>Available Courses</h5>
                    </div>
                    <div class="card-body p-0">
                        <table class="table table-striped mb-0">
                            <thead class="thead-light"><tr><th>Course Name</th><th>Teacher</th><th>Action</th></tr></thead>
                            <tbody>
                                <% 
                                    CourseDAO courseDAO = new CourseDAO();
                                    List<Course> allCourses = courseDAO.getAllCoursesWithDetails();
                                    for(Course c : allCourses) {
                                %>
                                <tr>
                                    <td class="align-middle font-weight-bold"><%= c.getCourseName() %></td>
                                    <td class="align-middle"><%= c.getTeacherName() %></td>
                                    <td>
                                        <form action="StudentController" method="post">
                                            <input type="hidden" name="action" value="enroll">
                                            <input type="hidden" name="courseId" value="<%= c.getId() %>">
                                            <button type="submit" class="btn btn-sm btn-primary rounded-pill px-3">
                                                Enroll <i class="fas fa-plus-circle ml-1"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="col-md-5">
                <div class="card shadow-sm bg-white">
                    <div class="card-header bg-secondary text-white">
                        <h5 class="m-0"><i class="fas fa-calendar-alt mr-2"></i>My Registered Courses</h5>
                    </div>
                    <ul class="list-group list-group-flush">
                        <% 
                            EnrollmentDAO enrollDAO = new EnrollmentDAO();
                            List<Course> myCourses = enrollDAO.getStudentCourses(user.getId());
                            if(myCourses.isEmpty()) {
                        %>
                            <li class="list-group-item text-muted text-center py-4">You haven't enrolled in any courses yet.</li>
                        <% } else { 
                            for(Course c : myCourses) { %>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <%= c.getCourseName() %>
                                <span class="badge badge-info p-2"><i class="fas fa-chalkboard-teacher mr-1"></i> <%= c.getTeacherName() %></span>
                            </li>
                        <% } } %>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <footer class="mt-5 mb-3 text-center text-muted">
        <small>&copy; 2025 LearningHub</small>
    </footer>

</body>
</html>