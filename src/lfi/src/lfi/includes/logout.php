<?php 
	session_destroy();
	header("Location: index.php?page=login.php");
    header("Connection: close");
    exit;
?>