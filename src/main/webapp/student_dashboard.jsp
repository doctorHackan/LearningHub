<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cms.dao.CourseDAO, com.cms.dao.EnrollmentDAO, com.cms.model.Course, com.cms.model.User, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    <style>
        body {
            background-color: #f4f7f6; /* Softer background color */
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        /* Modern Gradient Navbar */
        .navbar-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        /* Card Styling: Remove border, add soft shadow */
        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: transform 0.2s;
        }
        .card-header {
            background-color: white;
            border-bottom: 1px solid #eee;
            border-radius: 12px 12px 0 0 !important;
            padding-top: 20px;
            padding-bottom: 20px;
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
        .course-row:hover {
            background-color: #f9f9f9;
        }
        /* Button Styling */
        .btn-enroll {
            background: linear-gradient(to right, #667eea, #764ba2);
            border: none;
            color: white;
            padding: 5px 20px;
            border-radius: 50px;
            font-size: 0.9rem;
            box-shadow: 0 4px 6px rgba(118, 75, 162, 0.3);
            transition: all 0.3s;
        }
        .btn-enroll:hover {
            transform: translateY(-2px);
            color: white;
            box-shadow: 0 6px 8px rgba(118, 75, 162, 0.4);
        }
        /* Stat Card */
        .stat-card {
            background: white;
            border-left: 5px solid #764ba2;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom shadow-sm mb-4">
        <div class="container">
            <a class="navbar-brand font-weight-bold" href="#">
                <i class="fas fa-graduation-cap mr-2"></i>LearningHub
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
            
            // Fetch Data for Display
            EnrollmentDAO enrollDAO = new EnrollmentDAO();
            List<Course> myCourses = enrollDAO.getStudentCourses(user.getId());
            
            CourseDAO courseDAO = new CourseDAO();
            List<Course> allCourses = enrollDAO.getOtherCourses(user.getId());
        %>

        <div class="row align-items-center mb-4">
            <div class="col-md-8">
                <h2 class="text-dark">Hello, <b><%= user.getUsername() %></b>! 👋</h2>
                <p class="text-muted">Welcome to your student dashboard. Check your courses below.</p>
            </div>
            <div class="col-md-4">
                <div class="card stat-card p-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase text-muted mb-0 small">Enrolled Courses</h6>
                            <h2 class="font-weight-bold mb-0 text-primary"><%= myCourses.size() %></h2>
                        </div>
                        <i class="fas fa-book-reader fa-2x text-primary opacity-25"></i>
                    </div>
                </div>
            </div>
        </div>

        <% if(request.getParameter("msg") != null) { %> 
            <div class="alert alert-success shadow-sm rounded-lg border-0 mb-4">
                <i class="fas fa-check-circle mr-2"></i> <%= request.getParameter("msg") %>
            </div> 
        <% } %>
        
        <% if(request.getParameter("error") != null) { %> 
            <div class="alert alert-danger shadow-sm rounded-lg border-0 mb-4">
                <i class="fas fa-exclamation-circle mr-2"></i> <%= request.getParameter("error") %>
            </div> 
        <% } %>

        <div class="row">
            <div class="col-md-8 mb-4">
                <div class="card h-100">
                    <div class="card-header">
                        <h5 class="m-0 text-dark"><i class="fas fa-search mr-2 text-info"></i>Explore Courses</h5>
                    </div>
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th class="pl-4">Course Name</th>
                                    <th>Instructor</th>
                                    <th class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Course c : allCourses) { %>
                                <tr class="course-row">
                                    <td class="pl-4 py-3 font-weight-bold text-dark">
                                        <i class="fas fa-book text-muted mr-2"></i><%= c.getCourseName() %>
                                    </td>
                                    <td class="py-3 text-muted">
                                        <i class="fas fa-chalkboard-teacher mr-1"></i> <%= c.getTeacherName() %>
                                    </td>
                                    <td class="text-center py-3">
                                        <form action="StudentController" method="post">
                                            <input type="hidden" name="action" value="enroll">
                                            <input type="hidden" name="courseId" value="<%= c.getId() %>">
                                            <button type="submit" class="btn btn-enroll btn-sm">
                                                Enroll
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

            <div class="col-md-4 mb-4">
                <div class="card h-100">
                    <div class="card-header">
                        <h5 class="m-0 text-dark"><i class="fas fa-calendar-check mr-2 text-success"></i>My Courses</h5>
                    </div>
                    <div class="card-body p-0">
                        <ul class="list-group list-group-flush">
                            <% if(myCourses.isEmpty()) { %>
                                <li class="list-group-item text-center py-5 border-0">
                                    <i class="fas fa-clipboard-list fa-3x text-muted mb-3 opacity-25"></i>
                                    <br>
                                    <span class="text-muted">You haven't enrolled in any courses yet.</span>
                                </li>
                            <% } else { 
                                for(Course c : myCourses) { %>
                                <li class="list-group-item d-flex justify-content-between align-items-center py-3 border-bottom-0" style="border-bottom: 1px solid #f8f9fa !important;">
                                    <div>
                                        <h6 class="mb-0 font-weight-bold text-dark"><%= c.getCourseName() %></h6>
                                        <small class="text-muted"><i class="fas fa-user mr-1"></i> <%= c.getTeacherName() %></small>
                                    </div>
                                    <span class="badge badge-success badge-pill shadow-sm px-2">Active</span>
                                </li>
                            <% } } %>
                        </ul>
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