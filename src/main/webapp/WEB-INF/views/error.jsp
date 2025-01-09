<!-- src/main/webapp/WEB-INF/views/error.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <div class="alert alert-danger">
        <h4 class="alert-heading">Error</h4>
        <p>${errorMessage}</p>
        <hr>
        <a href="javascript:history.back()" class="btn btn-secondary">Go Back</a>
    </div>
</div>
</body>
</html>