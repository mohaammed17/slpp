<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>Petitioner Dashboard</title>
    <!-- Include Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #e9ecef;
        }
        .container-title {
            margin-top: 30px;
            margin-bottom: 20px;
        }
        .petition-item, .available-petition-item {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .petition-actions a, .petition-actions form {
            margin-right: 10px;
        }
        .available-petitions {
            margin-top: 40px;
        }
        .petititon-item {
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
    </style>
</head>
<body>
    <div class="container mt-5 position-relative">
        <div class="logout-button position-absolute top-0 end-0 mt-2 me-2">
            <a href="/auth/logout" class="btn btn-secondary">Logout</a>
        </div>
        
        <h2 class="container-title text-center">Petitioner Dashboard</h2>
        
        <c:if test="${not empty user}">
            <p class="text-center">Hello, <strong>${user.username}</strong>!</p>
        </c:if>
        
        <div class="d-flex justify-content-between align-items-center my-4">
            <h3>Your Petitions</h3>
            <a href="/petition/create" class="btn btn-success">Create New Petition</a>
        </div>
        
        <c:if test="${not empty petitions}">
            <div class="row">
                <c:forEach items="${petitions}" var="petition">
                    <div class="col-md-6">
                        <div class="petition-item">
                            <h4>${petition.title}</h4>
                            <p>Status: <span class="badge bg-${petition.status == 'OPEN' ? 'success' : petition.status == 'CLOSED' ? 'secondary' : 'warning'}">${petition.status}</span></p>
                            <p>Signatures: ${petition.signatures.size()} / ${petition.targetSignatures}</p>
                            <div class="petition-actions">
                                <a href="/petition/${petition.petitionId}" class="btn btn-info btn-sm btn-view">View Details</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        
        <c:if test="${empty petitions}">
            <div class="alert alert-warning">
                You have not created any petitions yet. <a href="/petition/create" class="alert-link">Create one now!</a>
            </div>
        </c:if>
        
        
    </div>

    <!-- Available Petitions to Sign -->
    <div class="container mt-5 position-relative">
        <h3>Available Petitions to Sign</h3>
        <c:if test="${not empty availablePetitions}">
            <div class="row">
                <c:forEach items="${availablePetitions}" var="petition">
                    <div class="col-md-6 mb-4">
                        <div class="petition-item">
                            <h4>${petition.title}</h4>
                            <p><strong>Created by:</strong> ${petition.createdBy.username}</p>
                            <p><strong>Status:</strong> 
                                <span class="badge bg-${petition.status == 'OPEN' ? 'success' : petition.status == 'CLOSED' ? 'secondary' : 'warning'}">
                                    ${petition.status}
                                </span>
                            </p>
                            <p><strong>Signatures:</strong> ${petition.signatures.size()} / ${petition.targetSignatures}</p>
                            <p><strong>Category:</strong> ${petition.category}</p>
                            <div class="petition-actions mt-3">
                                <form action="/petition/${petition.petitionId}/sign" method="post" style="display:inline;">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="submit" class="btn btn-primary btn-sm">Sign Petition</button>
                                </form>
                                <a href="/petition/${petition.petitionId}" class="btn btn-info btn-sm">View Details</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        <c:if test="${empty availablePetitions}">
            <div class="alert alert-info">
                No available petitions to sign at the moment.
            </div>
        </c:if>
    </div>


    <!-- Include Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>