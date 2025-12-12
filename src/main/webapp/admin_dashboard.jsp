<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cms.dao.UserDAO, com.cms.model.User, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm mb-4">
        <div class="container">
            <span class="navbar-brand mb-0 h1"><i class="fas fa-user-shield mr-2"></i>Admin Console</span>
            <div class="ml-auto">
                <a href="login.jsp" class="btn btn-outline-light btn-sm"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <% 
            User user = (User) session.getAttribute("user");
            if(user == null || !"admin".equals(user.getRole())) { 
                response.sendRedirect("login.jsp"); 
                return; 
            }
        %>

        <h2 class="mb-4 text-secondary">Dashboard Overview</h2>
        
        <div class="row mb-4">
             <div class="col-md-4">
                <div class="card text-white bg-primary shadow-sm mb-3">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="card-title mb-0">Total Teachers</h5>
                                <% 
                                    UserDAO userDAO = new UserDAO();
                                    List<User> teachers = userDAO.getAllTeachers();
                                %>
                                <h2 class="font-weight-bold"><%= teachers.size() %></h2>
                            </div>
                            <i class="fas fa-chalkboard-teacher fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
             <div class="col-md-4">
                <div class="card text-white bg-success shadow-sm mb-3">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="card-title mb-0">System Status</h5>
                                <h2 class="font-weight-bold">Active</h2>
                            </div>
                            <i class="fas fa-server fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
             <div class="col-md-4">
                <div class="card text-white bg-info shadow-sm mb-3">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="card-title mb-0">User Role</h5>
                                <h2 class="font-weight-bold">Admin</h2>
                            </div>
                            <i class="fas fa-user-cog fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <% String msg = request.getParameter("msg"); %>
        <% String error = request.getParameter("error"); %>
        <% if(msg != null) { %> 
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle mr-2"></i> <%= msg %>
                <button type="button" class="close" data-dismiss="alert">&times;</button>
            </div> 
        <% } %>
        <% if(error != null) { %> 
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="fas fa-exclamation-triangle mr-2"></i> <%= error %>
                <button type="button" class="close" data-dismiss="alert">&times;</button>
            </div> 
        <% } %>

        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card shadow">
                    <div class="card-header bg-white border-bottom-0 pt-4 pb-0">
                        <h4 class="text-primary"><i class="fas fa-book-medical mr-2"></i>Add New Course</h4>
                        <p class="text-muted small">Requirement R-3: Create a new course and assign a teacher.</p>
                    </div>
                    <div class="card-body">
                        <form action="AdminController" method="post">
                            <input type="hidden" name="action" value="addCourse">

                            <div class="form-group">
                                <label class="font-weight-bold">Course Name</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="fas fa-heading"></i></span>
                                    </div>
                                    <input type="text" name="courseName" class="form-control" placeholder="e.g. Introduction to AI" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="font-weight-bold">Assign Teacher</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="fas fa-chalkboard-teacher"></i></span>
                                    </div>
                                    <select name="teacherId" class="form-control">
                                        <% for(User teacher : teachers) { %>
                                            <option value="<%= teacher.getId() %>">
                                                <%= teacher.getUsername() %>
                                            </option>
                                        <% } %>
                                    </select>
                                </div>
                                <small class="form-text text-muted">Select from registered teachers only.</small>
                            </div>

                            <button type="submit" class="btn btn-success btn-block btn-lg mt-4 shadow-sm">
                                <i class="fas fa-plus mr-1"></i> Create Course
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <footer class="mt-5 mb-3 text-center text-muted">
            <small>&copy; 2025 LearningHub</small>
        </footer>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>