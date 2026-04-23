<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<title>Prescription History</title>

<style>

body{
font-family:Arial;
background:#f4f6f9;
}

.container{
width:90%;
margin:auto;
margin-top:40px;
}

table{
width:100%;
border-collapse:collapse;
background:white;
}

th,td{
padding:10px;
border:1px solid #ddd;
text-align:center;
}

th{
background:#2c3e50;
color:white;
}

a{
text-decoration:none;
color:white;
background:#3498db;
padding:5px 10px;
border-radius:4px;
}

</style>

</head>

<body>

<div class="container">

<h2>Prescription History</h2>

<table>

<tr>
<th>ID</th>
<th>Patient</th>
<th>Disease</th>
<th>Symptoms</th>
<th>Medicine</th>
<th>Dosage</th>
<th>Days</th>
<th>Date</th>
<th>View</th>
</tr>

<%

Connection con=null;
Statement st=null;
ResultSet rs=null;

try{

Class.forName("com.mysql.cj.jdbc.Driver");

con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/pre?allowPublicKeyRetrieval=true&useSSL=false",
"root",
"root"
);

String query="select * from prescription";

st = con.createStatement();

rs = st.executeQuery(query);

while(rs.next()){

%>

<tr>

<td><%=rs.getInt("id")%></td>

<td><%=rs.getString("patient_name")%></td>

<td><%=rs.getString("disease")%></td>

<td><%=rs.getString("symptoms")%></td>

<td><%=rs.getString("medicines")%></td>

<td><%=rs.getString("dosage")%></td>

<td><%=rs.getInt("days")%></td>

<td><%=rs.getString("date")%></td>

<td>
<a href="viewPrescription.jsp?id=<%=rs.getInt("id")%>">View</a>
</td>

</tr>

<%

}

}catch(Exception e){
out.println("Error: "+e);
}

finally{

try{
if(rs!=null) rs.close();
if(st!=null) st.close();
if(con!=null) con.close();
}catch(Exception e){}

}

%>

</table>

</div>

</body>
</html>