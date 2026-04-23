<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<title>View Prescription</title>

<style>

body{
font-family:Arial;
background:#f4f6f9;
}

.container{
width:50%;
margin:auto;
margin-top:40px;
background:white;
padding:20px;
border-radius:5px;
box-shadow:0 0 10px #ccc;
}

h2{
text-align:center;
margin-bottom:20px;
}

table{
width:100%;
border-collapse:collapse;
}

td{
padding:10px;
border-bottom:1px solid #ddd;
}

.label{
font-weight:bold;
width:160px;
background:#f2f2f2;
}

.btn{
text-decoration:none;
background:#3498db;
color:white;
padding:8px 15px;
border-radius:4px;
}

.center{
text-align:center;
margin-top:20px;
}

</style>

</head>

<body>

<div class="container">

<h2>Prescription Details</h2>

<%

Connection con=null;
Statement st=null;
ResultSet rs=null;

try{

String id=request.getParameter("id");

Class.forName("com.mysql.cj.jdbc.Driver");

con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/pre?allowPublicKeyRetrieval=true&useSSL=false",
"root",
"root"
);

st = con.createStatement();

String query="select * from prescription where id="+id;

rs = st.executeQuery(query);

if(rs.next()){
%>

<table>

<tr>
<td class="label">Patient Name</td>
<td><%=rs.getString("patient_name")%></td>
</tr>

<tr>
<td class="label">Disease</td>
<td><%=rs.getString("disease")%></td>
</tr>

<tr>
<td class="label">Symptoms</td>
<td><%=rs.getString("symptoms")%></td>
</tr>

<tr>
<td class="label">Medicine</td>
<td><%=rs.getString("medicines")%></td>
</tr>

<tr>
<td class="label">Dosage</td>
<td><%=rs.getString("dosage")%></td>
</tr>

<tr>
<td class="label">Days</td>
<td><%=rs.getInt("days")%></td>
</tr>

<tr>
<td class="label">Date</td>
<td><%=rs.getString("date")%></td>
</tr>

</table>

<%
}else{
%>

<p style="text-align:center;color:red;">Prescription not found</p>

<%
}

}catch(Exception e){
out.println("<p style='color:red;text-align:center;'>Error: "+e+"</p>");
}

finally{

try{
if(rs!=null) rs.close();
if(st!=null) st.close();
if(con!=null) con.close();
}catch(Exception e){}

}

%>

<div class="center">
<a href="javascript:history.back()" class="btn">Back</a>
</div>

</div>

</body>
</html>