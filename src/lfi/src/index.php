<?php 
	session_start();
	require("db.php");
	if (isset($_GET['page'])&&!empty($_GET['page'])){
		$page=$_GET['page'];
		include($page);
	}
	else{
		include("login.php");
	}
?>
