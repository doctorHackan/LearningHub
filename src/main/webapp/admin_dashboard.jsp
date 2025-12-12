<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cms.dao.UserDAO, com.cms.model.User, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
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
        .card:hover {
            transform: translateY(-2px);
        }
        /* Stats Cards Borders */
        .border-left-primary { border-left: 5px solid #667eea; }
        .border-left-success { border-left: 5px solid #28a745; }
        .border-left-info { border-left: 5px solid #17a2b8; }
        
        /* Form Styling */
        .form-control {
            height: 45px;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
        }
        .form-control:focus {
            box-shadow: none;
            border-color: #667eea;
        }
        .input-group-text {
            border-radius: 8px 0 0 8px;
            background-color: white;
            border: 1px solid #e0e0e0;
            border-right: none;
            color: #667eea;
        }
        
        /* Buttons */
        .btn-gradient {
            background: linear-gradient(to right, #667eea, #764ba2);
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 600;
            box-shadow: 0 4px 6px rgba(118, 75, 162, 0.3);
            transition: all 0.3s;
        }
        .btn-gradient:hover {
            transform: translateY(-2px);
            color: white;
            box-shadow: 0 6px 8px rgba(118, 75, 162, 0.4);
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom shadow-sm mb-4">
        <div class="container">
            <span class="navbar-brand font-weight-bold mb-0 h1">
                <i class="fas fa-user-shield mr-2"></i>LearningHub <span class="small opacity-75">| Admin Console</span>
            </span>
            <div class="ml-auto">
                <a href="login.jsp" class="btn btn-outline-light btn-sm rounded-pill px-3">
                    <i class="fas fa-sign-out-alt mr-1"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container">
        <% 
            // Security Check
            User user = (User) session.getAttribute("user");
            if(user == null || !"admin".equals(user.getRole())) { 
                response.sendRedirect("login.jsp"); 
                return; 
            }
            
            // Fetch Data for Stats and Dropdown
            UserDAO userDAO = new UserDAO();
            List<User> teachers = userDAO.getAllTeachers();
        %>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="text-dark font-weight-bold">Dashboard Overview</h2>
                <p class="text-muted">Manage system resources and course assignments.</p>
            </div>
            <span class="badge badge-light p-2 shadow-sm text-muted">
                <i class="fas fa-calendar-day mr-1"></i> Session: Active
            </span>
        </div>
        
        <div class="row mb-5">
             <div class="col-md-4">
                <div class="card border-left-primary h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Teachers</div>
                                <div class="h3 mb-0 font-weight-bold text-gray-800"><%= teachers.size() %></div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-chalkboard-teacher fa-2x text-gray-300 text-primary opacity-25"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

             <div class="col-md-4">
                <div class="card border-left-success h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-success text-uppercase mb-1">System Status</div>
                                <div class="h3 mb-0 font-weight-bold text-gray-800">Online</div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-server fa-2x text-gray-300 text-success opacity-25"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

             <div class="col-md-4">
                <div class="card border-left-info h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Access Level</div>
                                <div class="h3 mb-0 font-weight-bold text-gray-800">Administrator</div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-user-lock fa-2x text-gray-300 text-info opacity-25"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <% String msg = request.getParameter("msg"); %>
        <% String error = request.getParameter("error"); %>
        <% if(msg != null) { %> 
            <div class="alert alert-success shadow-sm rounded-lg border-0 mb-4">
                <i class="fas fa-check-circle mr-2"></i> <%= msg %>
                <button type="button" class="close" data-dismiss="alert">&times;</button>
            </div> 
        <% } %>
        <% if(error != null) { %> 
            <div class="alert alert-danger shadow-sm rounded-lg border-0 mb-4">
                <i class="fas fa-exclamation-triangle mr-2"></i> <%= error %>
                <button type="button" class="close" data-dismiss="alert">&times;</button>
            </div> 
        <% } %>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-lg mb-5">
                    <div class="card-header bg-white pt-4 pb-0 border-bottom-0">
                        <h4 class="text-dark font-weight-bold"><i class="fas fa-plus-circle mr-2 text-primary"></i>Create New Course</h4>
                        <p class="text-muted small ml-1">Assign a course name and link it to a registered teacher (Requirement R-3).</p>
                    </div>
                    <div class="card-body px-5 pb-5">
                        <form action="AdminController" method="post">
                            <input type="hidden" name="action" value="addCourse">

                            <div class="form-group mb-4">
                                <label class="font-weight-bold text-secondary small text-uppercase">Course Title</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="fas fa-heading"></i></span>
                                    </div>
                                    <input type="text" name="courseName" class="form-control" placeholder="e.g. Advanced Web Engineering" required>
                                </div>
                            </div>

                            <div class="form-group mb-4">
                                <label class="font-weight-bold text-secondary small text-uppercase">Assign Instructor</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="fas fa-chalkboard-teacher"></i></span>
                                    </div>
                                    <select name="teacherId" class="form-control custom-select">
                                        <% for(User teacher : teachers) { %>
                                            <option value="<%= teacher.getId() %>">
                                                <%= teacher.getUsername() %> 
                                            </option>
                                        <% } %>
                                    </select>
                                </div>
                                <small class="form-text text-muted">Only users with the 'Teacher' role are displayed.</small>
                            </div>

                            <button type="submit" class="btn btn-gradient btn-block mt-4">
                                Create Course <i class="fas fa-arrow-right ml-2"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <footer class="mt-3 mb-5 text-center text-muted">
            <small>&copy; 2025 LearningHub | Web Engineering Lab</small>
        </footer>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>