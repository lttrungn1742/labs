<?php 
	session_start();
	require("db.php");
	if (isset($_GET['page'])&&!empty($_GET['page'])){
		$page= "./includes/". $_GET['page'];
		include($page);
	}
	else{
		include("./includes/login.php");
	}
?>
