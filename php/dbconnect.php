<?php
$servername = "localhost";
$username 	= "lastyear_myfarm";
$password 	= "n9+a1ca!tXz%";
$dbname 	= "lastyear_myfarm";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>