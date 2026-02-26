<%@page import="com.doctorconsult.model.Patient"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>


<body>

<%
session = request.getSession(false); // existing session only
if (session != null) {
    session.invalidate();
}
response.sendRedirect("index.jsp");
%>

</body>
</html>