<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Create Petition</title>
    <!-- Include Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f1f3f5;
        }
        .container {
            max-width: 600px;
            margin-top: 50px;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .btn-submit {
            width: 100%;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="mb-4 text-center">Create New Petition</h2>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form action="/petition/create" method="post">
            <div class="mb-3">
                <label for="title" class="form-label">Title:</label>
                <input type="text" name="title" id="title" class="form-control" required maxlength="100">
            </div>
            <div class="mb-3">
                <label for="content" class="form-label">Description:</label>
                <textarea name="content" id="content" class="form-control" required maxlength="2000" rows="5"></textarea>
            </div>
            <div class="mb-3">
                <label for="targetSignatures" class="form-label">Target Signatures:</label>
                <input type="number" name="targetSignatures" id="targetSignatures" class="form-control" required min="1">
            </div>
            <div class="mb-3">
                <label for="category" class="form-label">Category:</label>
                <select name="category" id="category" class="form-select" required>
                    <option value="" disabled selected>Select a category</option>
                    <option value="ENVIRONMENT">Environment</option>
                    <option value="EDUCATION">Education</option>
                    <option value="HEALTHCARE">Healthcare</option>
                    <option value="HUMAN_RIGHTS">Human Rights</option>
                    <option value="OTHER">Other</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary btn-submit">Create Petition</button>
        </form>
        
        <div class="mt-3 text-center">
            <a href="/dashboard" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </div>

    <!-- Include Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>