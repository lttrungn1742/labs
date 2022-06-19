<?php 
  if (isset($_SESSION['username'])){
      header("Location: index.php?page=home.php");
      header("Connection: close");
      exit;
    }
    ini_set('display_errors', '1');
    ini_set('display_startup_errors', '1');
    error_reporting(E_ALL);
?>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Sign Up</title>
        <link rel="stylesheet" type="text/css" href="/static/css/bootstrap.min.css" />
        <link rel="stylesheet" type="text/css" href="/static/css/main.css" />
    </head>
    <body>
    <div class="container">
        <div class="row justify-content-center mt-5">
              <div class="col-lg-8">
                  <div class="card ancient-card mx-auto updoc-card">
                      <div class="card-body w-100" style="min-height: 400px;">  
                        <h1></h1>
                          <div class="row">
                            <div class="col text-center mt-5" style="width:50%;margin:25%;">
                                <form action="?page=login.php" method="post" >
                                    <h1>Login</h1>
                                    <div class="row" style="margin: 2%;">
                                        <input type="text" placeholder="username" name="username">    
                                    </div>
                                    <div class="row" style="margin: 2%;">
                                        <input type="text" placeholder="password" name="password">
                                    </div>
                                    <div class="row" style="margin: 2%;">
                                        <button type="submit" id="btn-submit">Login</button>
                                    </div>
                                    <div class="row" style="margin: 2%;">
                                        <a href="index.php?page=signup.php">Sign Up</a>
                                    </div>
                                    <?php
                                        if (isset($_POST['username'])&&!empty($_POST['username'])&&isset($_POST['password'])&&!empty($_POST['password'])){
                                            $username=$_POST['username'];
                                            $password=$_POST['password'];
                                            $stmt = $conn->prepare("SELECT * FROM users where username=? and passwd=?");
                                            $stmt->bind_param("ss", $username, $password);
                                            $stmt->execute();
                                            $result = $stmt->get_result(); // get the mysqli result
                                            $user = $result->fetch_assoc(); // fetch data   
                                            echo $user;
                                            if (empty($user)){
                                                echo "<div class='alert alert-danger' role='alert'>
                                                  <strong>Login fail</strong></div>";
                                            }
                                            else{
                                                $stmt = $conn->prepare("INSERT INTO log(username,time,browser) VALUES (?,CURRENT_TIMESTAMP(),?)");
                                                $stmt->bind_param("ss", $username,$_SERVER['HTTP_USER_AGENT']);
                                                $stmt->execute();
                                                $_SESSION['username']=$user['username'];
                                                header("Location: index.php?page=home.php");
                                                header("Connection: close");
                                                exit;
                                            }
                                        }
                                    ?>
                                </form>
                            </div>
                           
                        </div>
                      </div>
                  </div>
              </div>
          </div>
        </div>
       
        <script type="text/javascript" src="/static/js/jquery-3.6.0.min.js"></script>
        <script type="text/javascript" src="/static/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="/static/js/TweenMax.min.js"></script>
    </body>

</html>