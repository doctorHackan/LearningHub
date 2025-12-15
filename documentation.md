# LearningHub - Project Documentation

## Project Overview

**LearningHub** is a Java-based web application built with Servlets and JSP for managing course enrollments and user roles. The application supports three user roles: **Admin**, **Teacher**, and **Student**, each with specific functionalities and dashboard views.

### Key Features
- User authentication and role-based access control (Admin, Teacher, Student)
- Course management (create, view, manage courses)
- Student enrollment system
- Session-based user management
- Secure database connectivity

---

## Technology Stack

| Component | Technology |
|-----------|-----------|
| **Backend** | Java Servlets |
| **Frontend** | JSP (JavaServer Pages) |
| **Web Server** | Apache Tomcat 9+ |
| **Database** | MySQL |
| **JDBC Driver** | MySQL Connector/J (com.mysql.cj.jdbc.Driver) |
| **Build Tool** | Apache Maven (recommended) |
| **Java Version** | Java 8+ |

---

## Project Structure

```
LearningHub/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/cms/
│   │   │       ├── controller/          # Servlet Controllers
│   │   │       │   ├── AdminServlet.java
│   │   │       │   ├── LoginServlet.java
│   │   │       │   ├── LogoutServlet.java
│   │   │       │   └── StudentServlet.java
│   │   │       ├── dao/                # Data Access Objects
│   │   │       │   ├── CourseDAO.java
│   │   │       │   ├── DBConnection.java
│   │   │       │   ├── EnrollmentDAO.java
│   │   │       │   └── UserDAO.java
│   │   │       └── model/              # Data Models
│   │   │           ├── Course.java
│   │   │           └── User.java
│   │   └── webapp/
│   │       ├── login.jsp               # Login page
│   │       ├── admin_dashboard.jsp    # Admin dashboard
│   │       ├── teacher_dashboard.jsp  # Teacher dashboard
│   │       ├── student_dashboard.jsp  # Student dashboard
│   │       ├── META-INF/
│   │       │   └── MANIFEST.MF
│   │       └── WEB-INF/
│   │           ├── web.xml            # Servlet configuration
│   │           └── lib/               # External JAR dependencies
│   └── build/
│       └── classes/                    # Compiled classes
└── documentation.md                    # This file
```

---

## Database Configuration

### Connection Details
- **Database URL**: `jdbc:mysql://localhost:3306/course_management`
- **Username**: `cms_dev`
- **Password**: `0396`
- **JDBC Driver**: `com.mysql.cj.jdbc.Driver`

### Database Setup

Create the following tables in your MySQL database:

```sql
-- Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role ENUM('admin', 'teacher', 'student') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Courses table
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL,
    course_code VARCHAR(50) UNIQUE,
    description TEXT,
    teacher_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES users(id)
);

-- Enrollments table (junction table for student-course relationships)
CREATE TABLE enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_enrollment (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- Insert sample users
INSERT INTO users (username, password, role) VALUES
('admin', 'admin123', 'admin'),
('teacher1', 'pass123', 'teacher'),
('student1', 'pass123', 'student');
```

---

## Core Components

### Controllers (Servlets)

#### 1. **LoginServlet** (`/login`)
**Purpose**: Handles user authentication and session management.

**Functionality**:
- Validates username and password credentials
- Creates a session upon successful login
- Redirects users to role-specific dashboards:
  - Admin → `admin_dashboard.jsp`
  - Teacher → `teacher_dashboard.jsp`
  - Student → `student_dashboard.jsp`
- Returns to login page with error on failed authentication

**Request Method**: POST

**Parameters**:
- `username` (String): User's login username
- `password` (String): User's login password

---

#### 2. **LogoutServlet** (`/LogoutController`)
**Purpose**: Handles user session termination.

**Functionality**:
- Invalidates the current HTTP session
- Clears user session attributes
- Redirects to login page

**Request Method**: GET/POST

---

#### 3. **AdminServlet**
**Purpose**: Handles administrative operations.

**Functionality**:
- Course creation and management
- User account management
- System administration tasks
- Access control (admin only)

**Key Dependencies**: `CourseDAO`, `UserDAO`

---

#### 4. **StudentServlet**
**Purpose**: Manages student-specific operations.

**Functionality**:
- Course enrollment/unenrollment
- View enrolled courses
- Access student dashboard

**Key Dependencies**: `EnrollmentDAO`, `CourseDAO`

---

### Data Access Objects (DAOs)

#### 1. **DBConnection** (Singleton)
**Purpose**: Centralized database connection management.

**Key Methods**:
- `getConnection()`: Returns a MySQL database connection

**Configuration**:
```java
private static final String URL = "jdbc:mysql://localhost:3306/course_management";
private static final String USERNAME = "cms_dev";
private static final String PASSWORD = "0396";
```

**Note**: Credentials should be moved to environment variables for production use.

---

#### 2. **UserDAO**
**Purpose**: Manages user-related database operations.

**Key Methods**:
- `checkLogin(username, password)`: Validates user credentials
- `getUserById(id)`: Retrieves user by ID
- `getAllUsers()`: Fetches all users
- `addUser(user)`: Creates a new user
- `updateUser(user)`: Updates user information
- `deleteUser(id)`: Removes a user

---

#### 3. **CourseDAO**
**Purpose**: Manages course-related database operations.

**Key Methods**:
- `getAllCourses()`: Retrieves all courses
- `getCourseById(id)`: Fetches a specific course
- `getCoursesByTeacher(teacherId)`: Gets courses taught by a teacher
- `addCourse(course)`: Creates a new course
- `updateCourse(course)`: Modifies course details
- `deleteCourse(id)`: Removes a course

---

#### 4. **EnrollmentDAO**
**Purpose**: Manages student course enrollments.

**Key Methods**:
- `enrollStudent(studentId, courseId)`: Enrolls a student in a course
- `unenrollStudent(studentId, courseId)`: Removes student enrollment
- `getStudentEnrollments(studentId)`: Gets all courses for a student
- `getCourseEnrollments(courseId)`: Gets all students in a course

---

### Models (POJOs)

#### 1. **User**
```java
public class User {
    private int id;
    private String username;
    private String password;
    private String role;  // "admin", "teacher", "student"
}
```

---

#### 2. **Course**
```java
public class Course {
    private int id;
    private String courseName;
    private String courseCode;
    private String description;
    private int teacherId;
}
```

---

## User Interface (JSP Pages)

### 1. **login.jsp**
- Form-based login interface
- Username and password input fields
- Submit button to `/login` servlet
- Error message display for failed logins

### 2. **admin_dashboard.jsp**
- Admin-only access
- Course management interface
- User account management
- System administration controls

### 3. **teacher_dashboard.jsp**
- Teacher-only access
- View assigned courses
- Manage course content
- View enrolled students

### 4. **student_dashboard.jsp**
- Student-only access
- View available courses
- Manage course enrollments
- View enrolled courses

---

## Authentication & Authorization Flow

```
User Visits Application
    ↓
Login Page (login.jsp)
    ↓
Submit Credentials → LoginServlet
    ↓
    ├─→ Valid → Create Session → Redirect to Dashboard
    │              ├─ Admin → admin_dashboard.jsp
    │              ├─ Teacher → teacher_dashboard.jsp
    │              └─ Student → student_dashboard.jsp
    │
    └─→ Invalid → Redirect to login.jsp with error message
```

---

## Typical User Workflows

### Admin Workflow
1. Login with admin credentials
2. Access admin dashboard
3. Create/manage courses
4. Manage user accounts
5. Logout

### Teacher Workflow
1. Login with teacher credentials
2. Access teacher dashboard
3. View assigned courses
4. Manage course content
5. View enrolled students
6. Logout

### Student Workflow
1. Login with student credentials
2. Access student dashboard
3. Browse available courses
4. Enroll in courses
5. View enrolled courses
6. Logout

---

## Deployment Instructions

### Prerequisites
- Apache Tomcat 9+ installed
- MySQL server running with `course_management` database
- JDK 8+ installed
- Eclipse IDE with Dynamic Web Project support (recommended)

### Steps
1. **Set up database**: Run the SQL scripts in the Database Configuration section above.
2. **Update database credentials**: If needed, modify `DBConnection.java` with your MySQL credentials.
3. **Build the project**: 
   - Right-click project → Build Project (in Eclipse)
   - Or use Maven: `mvn clean package`
4. **Deploy to Tomcat**:
   - Copy the WAR file to `$TOMCAT_HOME/webapps/`
   - Or deploy directly from Eclipse
5. **Start Tomcat**: `$TOMCAT_HOME/bin/startup.sh`
6. **Access the application**: `http://localhost:8080/LearningHub/`

---

## Configuration Files

### web.xml
Located at `src/main/webapp/WEB-INF/web.xml`

Defines:
- Application display name: "LearningHub"
- Welcome files: index.html, index.jsp, default.jsp
- Servlet configurations and mappings (if using XML configuration instead of annotations)

---

## Security Considerations

⚠️ **Important**: The following security measures should be implemented before production:

1. **Password Security**:
   - Never store plain-text passwords
   - Use bcrypt or similar hashing algorithms
   - Implement salt-based password storage

2. **Database Credentials**:
   - Move credentials to environment variables
   - Use configuration files outside the codebase
   - Never commit sensitive credentials to version control

3. **Session Management**:
   - Implement session timeout
   - Use HTTPS for all communications
   - Implement CSRF tokens for form submissions

4. **Input Validation**:
   - Validate all user inputs
   - Prevent SQL injection attacks
   - Sanitize output on JSP pages

5. **Access Control**:
   - Implement filters or interceptors for role-based access
   - Verify user roles before processing requests
   - Log all admin actions for audit trails

---

## Troubleshooting

### Database Connection Issues
**Problem**: `SQLException: Connection refused`

**Solution**:
- Ensure MySQL server is running: `sudo systemctl status mysql`
- Verify database credentials in `DBConnection.java`
- Confirm the `course_management` database exists
- Check that MySQL JDBC driver is in `WEB-INF/lib/`

### Login Not Working
**Problem**: Authentication fails even with correct credentials

**Solution**:
- Verify user records exist in the `users` table
- Check password matches database (case-sensitive)
- Ensure `UserDAO.checkLogin()` is implemented correctly
- Review Tomcat logs for stack traces

### Pages Not Displaying
**Problem**: 404 error or blank pages

**Solution**:
- Verify JSP files are in `src/main/webapp/`
- Check servlet URL mappings match form actions
- Ensure Tomcat is redeployed after changes
- Review Tomcat logs for compilation errors

### Session Issues
**Problem**: User logged out unexpectedly or cannot access dashboard

**Solution**:
- Increase session timeout in `web.xml`
- Verify session attributes are set correctly in `LoginServlet`
- Check for session invalidation in `LogoutServlet`
- Review browser cookies/session settings

---

## Future Enhancements

1. **Unit Testing**: Add JUnit tests for DAO classes
2. **API Layer**: Create REST API endpoints
3. **Email Notifications**: Send enrollment confirmations
4. **Pagination**: Add pagination for course and enrollment lists
5. **Search & Filters**: Implement advanced search functionality
6. **Reporting**: Generate enrollment and course performance reports
7. **Profile Management**: Allow users to update their profiles
8. **Multi-language Support**: Internationalize the application
9. **Two-Factor Authentication**: Enhance security with 2FA
10. **Audit Logging**: Log all user actions for compliance

---

## Dependencies

Ensure the following JAR files are included in `WEB-INF/lib/`:

- **mysql-connector-java-x.x.x.jar** (MySQL JDBC Driver)
- **servlet-api.jar** (Servlet API, usually provided by Tomcat)
- **jsp-api.jar** (JSP API, usually provided by Tomcat)

---

## Support & Contact

For issues or questions regarding this project, contact the development team or review the inline code documentation in each source file.

---

## License

Internal project for coursework. Modify and distribute according to your institution's policies.

---

**Last Updated**: December 15, 2025
**Version**: 1.0
