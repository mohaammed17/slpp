<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>${petition.title}</title>
    <!-- Include Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            max-width: 800px;
            margin-top: 50px;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .petition-info, .petition-content, .official-response, .recent-signatures, .admin-controls {
            margin-bottom: 25px;
        }
        .admin-controls textarea {
            width: 100%;
            padding: 10px;
            border-radius: 4px;
            border: 1px solid #ced4da;
        }
        .admin-controls select {
            width: 100%;
            padding: 10px;
            border-radius: 4px;
            border: 1px solid #ced4da;
        }
        .btn-action {
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="mb-4">${petition.title}</h2>
        
        <!-- Petition Information -->
        <div class="petition-info">
            <p><strong>Created by:</strong> ${petition.createdBy.username}</p>
            <p><strong>Status:</strong> <span class="badge bg-${petition.status == 'OPEN' ? 'success' : petition.status == 'CLOSED' ? 'secondary' : 'warning'}">${petition.status}</span></p>
            <p><strong>Signatures:</strong> ${petition.signatures.size()} / ${petition.targetSignatures}</p>
            <p><strong>Category:</strong> ${petition.category}</p>
        </div>

        <!-- Petition Description -->
        <div class="petition-content">
            <h4>Description:</h4>
            <p>${petition.content}</p>
        </div>

        <!-- Official Response (if any) -->
        <c:if test="${petition.status == 'RESPONDED'}">
            <div class="official-response">
                <h4>Official Response:</h4>
                <p>${petition.responseText}</p>
            </div>
        </c:if>

        <!-- Sign Petition -->
        <c:if test="${canSign}">
            <div class="sign-petition mb-4">
                <form action="/petition/${petition.petitionId}/sign" method="post">
                    <button type="submit" class="btn btn-primary">Sign this Petition</button>
                </form>
            </div>
        </c:if>

        <!-- Recent Signatures -->
        <div class="recent-signatures">
            <h4>Recent Signatures</h4>
            <c:if test="${not empty petition.signatures}">
                <ul class="list-group">
                    <c:forEach items="${petition.signatures}" var="signature" varStatus="status">
                        <c:if test="${status.index < 10}">
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <span>${signature.user.username}</span>
                                <span><fmt:formatDate value="${signature.signedDate}" pattern="dd MMM yyyy"/></span>
                            </li>
                        </c:if>
                    </c:forEach>
                </ul>
            </c:if>
            <c:if test="${empty petition.signatures}">
                <p>No signatures yet.</p>
            </c:if>
        </div>

        <!-- Admin Controls -->
        <c:if test="${isAdmin}">
            <div class="admin-controls">
                <h4>Admin Controls</h4>
                <div class="mb-3">
                    <form action="/petition/${petition.petitionId}/respond" method="post">
                        <label for="response" class="form-label">Post Official Response:</label>
                        <textarea name="response" id="response" rows="4" class="form-control" required></textarea>
                        <button type="submit" class="btn btn-success mt-2">Post Response</button>
                    </form>
                </div>
                <div>
                    <form action="/petition/${petition.petitionId}/status" method="post" class="row g-3 align-items-center">
                        <label for="status" class="col-auto col-form-label">Update Status:</label>
                        <div class="col-auto">
                            <select name="status" id="status" class="form-select" required>
                                <option value="OPEN" ${petition.status == 'OPEN' ? 'selected' : ''}>Open</option>
                                <option value="CLOSED" ${petition.status == 'CLOSED' ? 'selected' : ''}>Close</option>
                                <option value="REJECTED" ${petition.status == 'REJECTED' ? 'selected' : ''}>Reject</option>
                            </select>
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-warning">Update Status</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <!-- Navigation Links -->
        <div class="navigation text-center mt-4">
            <a href="/dashboard" class="btn btn-secondary">Back to Dashboard</a>
            <c:if test="${petition.createdBy.username == currentUser.username}">
                <a href="/petition/${petition.petitionId}/edit" class="btn btn-primary">Edit Petition</a>
            </c:if>
        </div>
    </div>

    <!-- Include Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>