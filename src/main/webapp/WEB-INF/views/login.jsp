<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login/Register</title>
    <!-- Include Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f1f3f5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            display: flex;
            justify-content: center;
            gap: 40px;
        }
        .form-container {
            background: #ffffff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            width: 350px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
        }
        .btn-submit {
            width: 100%;
            padding: 10px;
        }
        .error, .success {
            margin-top: 15px;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Login Form -->
        <div class="form-container">
            <h2 class="text-center mb-4">Login</h2>
            <form action="${pageContext.request.contextPath}/auth/login" method="post">
                <div class="form-group">
                    <label for="loginUsername">Username:</label>
                    <input type="text" name="username" id="loginUsername" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="loginPassword">Password:</label>
                    <input type="password" name="password" id="loginPassword" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary btn-submit">Login</button>
                <c:if test="${not empty error}">
                    <div class="error text-danger">${error}</div>
                </c:if>
            </form>
        </div>

        <!-- Registration Form -->
        <div class="form-container">
            <h2 class="text-center mb-4">Register</h2>
            <form action="${pageContext.request.contextPath}/auth/register" method="post">
                <div class="form-group">
                    <label for="regUsername">Username:</label>
                    <input type="text" name="username" id="regUsername" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="regEmail">Email:</label>
                    <input type="email" name="email" id="regEmail" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="regFullName">Full Name:</label>
                    <input type="text" name="fullName" id="regFullName" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="regPassword">Password:</label>
                    <input type="password" name="password" id="regPassword" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="regDob">Date of Birth:</label>
                    <input type="date" id="regDob" name="dob" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="bioId">BioID:</label>
                    <input type="text" name="bioId" id="bioId" class="form-control" required>
                </div>
                <!-- QR Code Scanner Container -->
                <div id="qr-reader" class="mb-3"></div>
                <button type="submit" class="btn btn-success btn-submit">Register</button>
                <c:if test="${not empty success}">
                    <div class="success text-success">${success}</div>
                </c:if>
            </form>
        </div>
    </div>

    <!-- Include Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Include html5-qrcode library -->
    <script src="https://unpkg.com/html5-qrcode"></script>
    <script>
        window.onload = function() {
            startQrScanner();
        };

        function startQrScanner() {
            Html5Qrcode.getCameras().then(devices => {
                if (devices && devices.length) {
                    const html5QrCode = new Html5Qrcode("qr-reader");
                    const qrCodeSuccessCallback = (decodedText, decodedResult) => {
                        document.getElementById('bioId').value = decodedText;
                        html5QrCode.stop().then(ignore => {
                            document.getElementById('qr-reader').innerHTML = "";
                        }).catch(err => {
                            console.error("Failed to stop QR scanner: ", err);
                        });
                    };
                    const config = { fps: 10, qrbox: 250 };
                    html5QrCode.start({ facingMode: "environment" }, config, qrCodeSuccessCallback)
                        .catch(err => {
                            console.error("Unable to start QR scanner: ", err);
                        });
                } else {
                    alert("No cameras found.");
                }
            }).catch(err => {
                console.error("Error getting cameras: ", err);
            });
        }
    </script>
</body>
</html>