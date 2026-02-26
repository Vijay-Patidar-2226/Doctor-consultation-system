<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Select User Type</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 50px 40px;
            max-width: 500px;
            width: 100%;
        }
        
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 15px;
            font-size: 32px;
        }
        
        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 40px;
            font-size: 16px;
        }
        
        .selection-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .user-option {
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            padding: 30px;
            text-align: center;
            transition: all 0.3s ease;
            text-decoration: none;
            display: block;
        }
        
        .user-option:hover {
            border-color: #667eea;
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.2);
        }
        
        .icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        
        .doctor-option .icon {
            color: #667eea;
        }
        
        .patient-option .icon {
            color: #764ba2;
        }
        
        .user-option h2 {
            color: #333;
            margin-bottom: 10px;
            font-size: 24px;
        }
        
        .user-option p {
            color: #666;
            font-size: 14px;
            line-height: 1.6;
        }
        
        .button {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 15px;
            transition: transform 0.2s ease;
            display: inline-block;
        }
        
        .button:hover {
            transform: scale(1.05);
        }
        
        .footer {
            text-align: center;
            margin-top: 30px;
            color: #999;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome</h1>
        <p class="subtitle">Please select your user type to continue</p>
        
        <div class="selection-container">
            <a href="d-reg-login.jsp" class="user-option doctor-option">
                <div class="icon">👨‍⚕️</div>
                <h2>Doctor Login</h2>
                <p>Access medical records, manage appointments, and provide care to your patients</p>
                <span class="button">Login as Doctor</span>
            </a>
            
            <a href="p-reg-login.jsp" class="user-option patient-option">
                <div class="icon">👤</div>
                <h2>Patient Login</h2>
                <p>View your medical records, book appointments, and communicate with your doctor</p>
                <span class="button">Login as Patient</span>
            </a>
        </div>
        
        <p class="footer">Need help? Contact support</p>
    </div>
</body>
</html>