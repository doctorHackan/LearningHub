<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cms.dao.CourseDAO, com.cms.dao.EnrollmentDAO, com.cms.model.Course, com.cms.model.User, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Teacher Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    <style>
        body {
            background-color: #f4f7f6;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        /* Gradient Navbar */
        .navbar-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        /* Cards */
        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: transform 0.2s;
        }
        /* Sidebar Menu Items */
        .list-group-item {
            border: none;
            border-radius: 8px !important;
            margin-bottom: 5px;
            transition: all 0.2s;
            color: #555;
            font-weight: 500;
        }
        .list-group-item:hover {
            background-color: #e9ecef;
            color: #333;
            transform: translateX(5px);
        }
        /* Active State for Sidebar */
        .list-group-item.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            box-shadow: 0 4px 6px rgba(118, 75, 162, 0.4);
        }
        .list-group-item.active:hover {
            transform: none; /* Disable hover movement for active item */
        }
        /* Table Styling */
        .table thead th {
            border-top: none;
            border-bottom: 2px solid #f0f0f0;
            color: #888;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .avatar-circle {
            width: 35px;
            height: 35px;
            background-color: #e2e6ea;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            margin-right: 10px;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom shadow-sm mb-4">
        <div class="container">
            <a class="navbar-brand font-weight-bold" href="#">
                <i class="fas fa-chalkboard-teacher mr-2"></i>LearningHub <span class="small opacity-75">| Instructor</span>
            </a>
            <div class="ml-auto">
                <a href="LogoutController" class="btn btn-outline-light btn-sm rounded-pill px-3">
                    <i class="fas fa-sign-out-alt mr-1"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container">
        <% 
            User user = (User) session.getAttribute("user");
            if(user == null) { response.sendRedirect("login.jsp"); return; }
            String selectedCourseId = request.getParameter("courseId");
            
            CourseDAO courseDAO = new CourseDAO();
            List<Course> myCourses = courseDAO.getCoursesByTeacher(user.getId());
        %>

        <div class="row align-items-center mb-4">
            <div class="col-md-12">
                <h2 class="text-dark">Welcome back, <b><%= user.getUsername() %></b></h2>
                <p class="text-muted">Manage your courses and view student rosters below.</p>
            </div>
        </div>

        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card h-100">
                    <div class="card-header bg-white border-bottom-0 pt-4 pb-2">
                        <h5 class="m-0 text-dark"><i class="fas fa-book mr-2 text-primary"></i>My Courses</h5>
                    </div>
                    <div class="card-body p-3">
                        <div class="list-group list-group-flush">
                            <% 
                                for(Course c : myCourses) {
                                    String active = (selectedCourseId != null && Integer.parseInt(selectedCourseId) == c.getId()) ? "active" : "bg-light";
                            %>
                                <a href="teacher_dashboard.jsp?courseId=<%= c.getId() %>" class="list-group-item list-group-item-action <%= active %>">
                                    <div class="d-flex w-100 justify-content-between align-items-center">
                                        <span><%= c.getCourseName() %></span>
                                        <% if(active.contains("active")) { %>
                                            <i class="fas fa-chevron-right small"></i>
                                        <% } %>
                                    </div>
                                </a>
                            <% } %>
                            
                            <% if(myCourses.isEmpty()) { %>
                                <div class="text-center py-4 text-muted">
                                    <i class="fas fa-folder-open fa-2x mb-2 opacity-50"></i>
                                    <p class="small">No courses have been assigned to you yet.</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-8 mb-4">
                <div class="card h-100">
                    <div class="card-header bg-white border-bottom-0 pt-4">
                        <h5 class="text-dark m-0">
                            <% if(selectedCourseId != null) { %>
                                <i class="fas fa-users mr-2 text-success"></i>Enrolled Students
                            <% } else { %>
                                <i class="fas fa-info-circle mr-2 text-info"></i>Course Details
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
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead>
                                            <tr>
                                                <th style="width: 100px;">Student ID</th>
                                                <th>Full Name</th>
                                                <th class="text-right">Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for(User s : students) { %>
                                            <tr>
                                                <td class="align-middle">
                                                    <span class="badge badge-light border text-muted">#<%= s.getId() %></span>
                                                </td>
                                                <td class="align-middle font-weight-bold text-dark">
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-circle">
                                                            <i class="fas fa-user"></i>
                                                        </div>
                                                        <%= s.getUsername() %>
                                                    </div>
                                                </td>
                                                <td class="align-middle text-right">
                                                    <span class="badge badge-success badge-pill px-2">Enrolled</span>
                                                </td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            <% } else { %>
                                <div class="text-center py-5">
                                    <div class="mb-3">
                                        <i class="fas fa-user-clock fa-3x text-warning opacity-50"></i>
                                    </div>
                                    <h5 class="text-muted">No students yet</h5>
                                    <p class="text-muted small">Students have not registered for this course yet.</p>
                                </div>
                            <% } %>
                            
                        <% } else { %>
                            <div class="text-center py-5">
                                <img src="https://via.placeholder.com/150?text=Select+Course" alt="Select" class="img-fluid mb-3 d-none"> <i class="fas fa-chalkboard fa-4x text-primary opacity-25 mb-3"></i>
                                <h4 class="text-muted font-weight-normal">Ready to teach?</h4>
                                <p class="text-muted">Please select a course from the left menu to view the student roster.</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <footer class="mt-5 mb-4 text-center text-muted">
        <small>&copy; 2025 LearningHub | Web Engineering Lab</small>
    </footer>
</body>
</html>