<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>All Petitions</title>
    <!-- Include Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container-title {
            margin-top: 30px;
            margin-bottom: 20px;
        }
        .petition-card {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .filters {
            margin-bottom: 20px;
        }
        .filters form {
            max-width: 600px;
            margin: auto;
        }
        .btn-filter {
            margin-top: 10px;
        }
        .navigation a {
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h2 class="container-title text-center">Active Petitions</h2>
        
        <!-- Filters Section -->
        <div class="filters">
            <form action="/petition/list" method="get" class="row g-3">
                <div class="col-md-5">
                    <label for="category" class="form-label">Category:</label>
                    <select name="category" id="category" class="form-select">
                        <option value="">All Categories</option>
                        <option value="ENVIRONMENT">Environment</option>
                        <option value="EDUCATION">Education</option>
                        <option value="HEALTHCARE">Healthcare</option>
                        <option value="HUMAN_RIGHTS">Human Rights</option>
                        <option value="OTHER">Other</option>
                    </select>
                </div>
                <div class="col-md-5">
                    <label for="status" class="form-label">Status:</label>
                    <select name="status" id="status" class="form-select">
                        <option value="">All Status</option>
                        <option value="OPEN">Open</option>
                        <option value="CLOSED">Closed</option>
                        <option value="RESPONDED">Responded</option>
                    </select>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary btn-filter w-100">Filter</button>
                </div>
            </form>
        </div>

        <!-- Petitions List -->
        <div class="petitions-list">
            <c:forEach items="${petitions}" var="petition">
                <div class="petition-card">
                    <h3><a href="/petition/${petition.id}" class="text-decoration-none">${petition.title}</a></h3>
                    <p><strong>Created by:</strong> ${petition.createdBy.username}</p>
                    <p><strong>Status:</strong> <span class="badge bg-${petition.status == 'OPEN' ? 'success' : petition.status == 'CLOSED' ? 'secondary' : 'warning'}">${petition.status}</span></p>
                    <p><strong>Signatures:</strong> ${petition.signatures.size()} / ${petition.targetSignatures}</p>
                    <p><strong>Category:</strong> ${petition.category}</p>
                    <p><strong>Created:</strong> <fmt:formatDate value="${petition.createdDate}" pattern="dd MMM yyyy" /></p>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty petitions}">
            <div class="alert alert-info text-center">
                No petitions found matching your criteria.
            </div>
        </c:if>

        <!-- Navigation Links -->
        <div class="navigation text-center mt-4">
            <a href="/dashboard" class="btn btn-secondary">Back to Dashboard</a>
            <a href="/petition/create" class="btn btn-success">Create New Petition</a>
        </div>
    </div>

    <!-- Include Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>