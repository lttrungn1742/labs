<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Slippy</title>
        <link rel="stylesheet" type="text/css" href="/static/css/bootstrap.min.css" />
        <link rel="stylesheet" type="text/css" href="/static/css/main.css" />
    </head>
    <body>
    <div class="container">
        <div class="row justify-content-center mt-5">
              <div class="col-lg-8">
                  <div class="card ancient-card mx-auto updoc-card">
                      <div class="card-body w-100" style="min-height: 400px;">
                          <p class="w-100">Slippy Firmware Upgrader</p>
                          <div class="row justify-content-center">
                              <div class="col text-center">
                                <p class="mid-help">Current Slippy Jet version is 3.03</p>
                                <p class="mid-help">Please select a newer version of firmware tar.gz file to upload..</p>
                              </div>
                          </div>
                          
                          <div class="row">
                              <div class="col text-center mt-5">
                                  <div class="upload-area">
                                    <form action="index.php" method="post" enctype="multipart/form-data">
                                        <input type="file"  name="file" />
                                        <!-- <img src="/static/images/upload-doc.png" height="150px" id="upload-btn"> -->
                                        <button type="submit">submit</button>
                                    </form>
                                  </div>
                              </div>
                          </div>
                          <div class="container text-center mt-5" id="loading-container">
                              <div class="progress">
                                  <div class="progress-bar progress-bar-striped progress-bar-animated" id="progressbar" style="width: 60%;"></div>
                              </div>
                          </div>
                          <p class="card-text text-center pt-2 text-black" id="resp-msg">Please wait..</p>
                          <div  class="mt-5 text-left hidden" id="uploaded_list">
                        <?php
                            require('xxe.php');

                            $target_dir = "uploads/";
                            $target_file = $target_dir . basename($_FILES["file"]["name"]);
                            $uploadOk = 1;
                            $imageFileType = strtolower(pathinfo($target_file,PATHINFO_EXTENSION));


                            // Check file size
                            if ($_FILES["file"]["size"] > 500000) {
                                echo  "Sorry, your file is too large.";
                                $uploadOk = 0;
                            }

                            // Allow certain file formats
                            if($imageFileType != "docx"  ) {
                                echo  "Sorry, only docx file is allowed.";
                                $uploadOk = 0;
                            }

                            // Check if $uploadOk is set to 0 by an error
                            if ($uploadOk == 0) {
                                echo  "Sorry, your file was not uploaded.";
                            // if everything is ok, try to upload file
                            } else {
                            if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_file)) {
                                docx2text("uploads/".basename( $_FILES["file"]["name"]));
                                echo "Success";
                            } else {
                                echo "Sorry, there was an error uploading your file.";
                            }
                            }
                        ?>

                         </div>
                            
                      </div>
                  </div>
              </div>
          </div>
        </div>
       
        <script type="text/javascript" src="/static/js/jquery-3.6.0.min.js"></script>
        <script type="text/javascript" src="/static/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="/static/js/TweenMax.min.js"></script>
        <script type="text/javascript" src="/static/js/main.js"></script>
    </body>
</html>