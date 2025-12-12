<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Course Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    <style>
        body {
            /* Beautiful Purple-Blue Gradient Background */
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            width: 100%;
            max-width: 600px;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2); /* Soft shadow */
        }
        .btn-primary {
            background-color: #764ba2;
            border: none;
        }
        .btn-primary:hover {
            background-color: #5a3780;
        }
    </style>
</head>
<body>

    <div class="card login-card">
        <div class="card-body text-center">
            <i class="fas fa-graduation-cap fa-3x text-primary mb-3"></i>
            <h4 class="mb-1">Welcome Back</h4>
            <p class="h3 font-weight-bold mb-4">Course Management System</p>

            <% if(request.getAttribute("message") != null) { %>
                <div class="alert alert-danger text-left">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("message") %>
                </div>
            <% } %>

            <form action="login" method="post">
                <div class="form-group text-left">
                    <label>Username</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                        </div>
                        <input type="text" name="username" class="form-control" placeholder="Enter username" required>
                    </div>
                </div>
                
                <div class="form-group text-left">
                    <label>Password</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                        </div>
                        <input type="password" name="password" class="form-control" placeholder="Enter password" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-block btn-lg mt-4">
                    Login Now
                </button>
            </form>
        </div>
    </div>
    <footer class="mt-5 mb-3 text-center text-muted">
        <small>&copy; 2025 LearningHub</small>
    </footer>

</body>
</html>