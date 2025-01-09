<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- src/main/webapp/WEB-INF/views/committeeDashboard.jsp -->
<!DOCTYPE html>
<html>
<head>
    <title>Committee Dashboard</title>
    <!-- Include Bootstrap CSS and Chart.js -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .table th, .table td {
            vertical-align: middle;
        }
        .btn-info {
            margin-right: 5px;
        }
        .chart-container {
            position: relative;
            margin: auto;
            height: 40vh;
            width: 40vw;
        }
        .container-title {
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h2 class="container-title text-center">Committee Dashboard</h2>

        <!-- Data Visualization: Petitions by Category -->
        <div class="my-4">
            <div class="chart-container">
                <canvas id="categoryChart"></canvas>
            </div>
        </div>

        <!-- Petitions List with Admin Controls -->
        <h3>All Petitions</h3>
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>Title</th>
                        <th>Created By</th>
                        <th>Status</th>
                        <th>Signatures</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="petition" items="${petitions}">
                        <tr>
                            <td>${petition.title}</td>
                            <td>${petition.createdBy.username}</td>
                            <td><span class="badge bg-${petition.status == 'OPEN' ? 'success' : petition.status == 'CLOSED' ? 'secondary' : 'warning'}">${petition.status}</span></td>
                            <td>${petition.signatures.size()}</td>
                            <td>
                                <a href="/petition/${petition.petitionId}" class="btn btn-info btn-sm">View</a>
                                <form action="/admin/${petition.petitionId}/delete" method="post" style="display:inline;">
                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this petition?');">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Admin Controls: Responding and Updating Status -->
        <h3 class="mt-5">Respond to and Update Petition Status</h3>
        <form action="/admin/dashboard/action" method="post" class="row g-3">
            <!-- Select Petition -->
            <div class="col-md-6">
                <label for="petitionSelect" class="form-label">Select Petition</label>
                <select id="petitionSelect" name="petitionId" class="form-select" required>
                    <option value="" disabled selected>Choose a petition</option>
                    <c:forEach var="petition" items="${petitions}">
                        <option value="${petition.petitionId}">${petition.title}</option>
                    </c:forEach>
                </select>
            </div>
            
            <!-- Select Action -->
            <div class="col-md-6">
                <label for="actionSelect" class="form-label">Action</label>
                <select id="actionSelect" name="action" class="form-select" required>
                    <option value="" disabled selected>Choose an action</option>
                    <option value="respond">Respond</option>
                    <option value="updateStatus">Update Status</option>
                </select>
            </div>
            
            <!-- Response Textarea (Visible Only When Responding) -->
            <div class="col-12" id="responseSection" style="display: none;">
                <label for="response" class="form-label">Admin Response</label>
                <textarea name="response" id="response" rows="4" class="form-control"></textarea>
            </div>
            
            <!-- Status Selection (Visible Only When Updating Status) -->
            <div class="col-md-6" id="statusSection" style="display: none;">
                <label for="status" class="form-label">New Status</label>
                <select name="status" id="status" class="form-select">
                    <option value="OPEN">Open</option>
                    <option value="CLOSED">Closed</option>
                    <option value="REJECTED">Rejected</option>
                </select>
            </div>
            
            <!-- Submit Button -->
            <div class="col-12">
                <button type="submit" class="btn btn-primary">Apply</button>
            </div>
        </form>

        <!-- JavaScript to Toggle Response and Status Sections -->
        <script>
            document.getElementById('actionSelect').addEventListener('change', function() {
                var action = this.value;
                var responseSection = document.getElementById('responseSection');
                var statusSection = document.getElementById('statusSection');
                
                if (action === 'respond') {
                    responseSection.style.display = 'block';
                    statusSection.style.display = 'none';
                    document.getElementById('response').setAttribute('required', 'required');
                    document.getElementById('status').removeAttribute('required');
                } else if (action === 'updateStatus') {
                    statusSection.style.display = 'block';
                    responseSection.style.display = 'none';
                    document.getElementById('status').setAttribute('required', 'required');
                    document.getElementById('response').removeAttribute('required');
                } else {
                    responseSection.style.display = 'none';
                    statusSection.style.display = 'none';
                    document.getElementById('response').removeAttribute('required');
                    document.getElementById('status').removeAttribute('required');
                }
            });
        </script>

        <!-- Logout Link -->
        <a href="/auth/logout" class="btn btn-secondary mt-4">Logout</a>
    </div>

    <!-- Chart.js Script for Data Visualization -->
    <script>
        const categories = [<c:forEach var="petition" items="${petitions}" varStatus="status">
                                "'${petition.category}'"<c:if test="${!status.last}">,</c:if>
                             </c:forEach>];
        const categoryCounts = [];
        const categorySet = new Set(categories);
        categorySet.forEach(category => {
            const count = categories.filter(c => c === category).length;
            categoryCounts.push(count);
        });

        const ctx = document.getElementById('categoryChart').getContext('2d');
        const categoryChart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: Array.from(categorySet),
                datasets: [{
                    label: '# of Petitions',
                    data: categoryCounts,
                    backgroundColor: [
                        'rgba(54, 162, 235, 0.6)',
                        'rgba(255, 99, 132, 0.6)',
                        'rgba(255, 206, 86, 0.6)',
                        'rgba(75, 192, 192, 0.6)',
                        'rgba(153, 102, 255, 0.6)',
                        'rgba(255, 159, 64, 0.6)',
                        'rgba(199, 199, 199, 0.6)'
                    ],
                    borderColor: [
                        'rgba(54, 162, 235, 1)',
                        'rgba(255,99,132,1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)',
                        'rgba(199, 199, 199, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
            }
        });
    </script>

    <!-- Include Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>