<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cms.dao.UserDAO, com.cms.model.User, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <nav class="navbar navbar-dark bg-dark">
        <span class="navbar-brand mb-0 h1">Course Management - Admin</span>
        <a href="login.jsp" class="btn btn-outline-light">Logout</a>
    </nav>

    <div class="container mt-5">
        <% String msg = request.getParameter("msg"); %>
        <% String error = request.getParameter("error"); %>
        <% if(msg != null) { %> <div class="alert alert-success"><%= msg %></div> <% } %>
        <% if(error != null) { %> <div class="alert alert-danger"><%= error %></div> <% } %>

        <div class="row">
            <div class="col-md-6 offset-md-3">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h4>Add New Course (R-3)</h4>
                    </div>
                    <div class="card-body">
                        <form action="AdminController" method="post">
                            <input type="hidden" name="action" value="addCourse">

                            <div class="form-group">
                                <label>Course Name</label>
                                <input type="text" name="courseName" class="form-control" required>
                            </div>

                            <div class="form-group">
                                <label>Assign Teacher</label>
                                <select name="teacherId" class="form-control">
                                    <% 
                                        // Fetch teachers for the dropdown
                                        UserDAO userDAO = new UserDAO();
                                        List<User> teachers = userDAO.getAllTeachers();
                                        for(User teacher : teachers) {
                                    %>
                                        <option value="<%= teacher.getId() %>">
                                            <%= teacher.getUsername() %>
                                        </option>
                                    <% } %>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-success btn-block">Create Course</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>