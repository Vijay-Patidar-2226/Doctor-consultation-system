<!DOCTYPE html>
<html>
<head>
<title>Add Prescription</title>

<style>

body{
font-family: Arial;
background-color:#f2f2f2;
}

.container{
width:500px;
margin:40px auto;
background:white;
padding:25px;
border-radius:10px;
box-shadow:0 0 10px gray;
}

h2{
text-align:center;
margin-bottom:20px;
}

label{
font-weight:bold;
}

input, textarea, select{
width:100%;
padding:8px;
margin-top:5px;
margin-bottom:15px;
border:1px solid #ccc;
border-radius:5px;
}

button{
width:100%;
padding:10px;
background-color:#2e7d32;
color:white;
border:none;
border-radius:5px;
font-size:16px;
cursor:pointer;
}

button:hover{
background-color:#1b5e20;
}

</style>

</head>

<body>

<div class="container">

<h2>Add Prescription</h2>

<form action="SavePrescription" method="get">

<label>Patient Name</label>
<input type="text" name="patientName" required>

<label>Disease</label>
<input type="text" name="disease" required>

<label>Symptoms</label>
<textarea name="symptoms" rows="3"></textarea>

<label>Medicine</label>
<select name="medicines">

<option value="Paracetamol 500mg">Paracetamol 500mg</option>
<option value="Cetirizine">Cetirizine</option>
<option value="Dolo 650">Dolo 650</option>
<option value="Azithromycin">Azithromycin</option>
<option value="Ibuprofen">Ibuprofen</option>

</select>

<label>Dosage</label>
<select name="dosage">

<option value="1 time daily">1 time daily</option>
<option value="2 times daily">2 times daily</option>
<option value="3 times daily">3 times daily</option>
<option value="Morning">Morning</option>
<option value="Night">Night</option>

</select>

<label>Days</label>
<input type="number" name="days" required>

<label>Notes</label>
<textarea name="notes" rows="3"></textarea>

<button type="submit">Save Prescription</button>

</form>

</div>

</body>
</html>