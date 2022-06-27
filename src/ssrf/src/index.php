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

                          <div class="row">
                            <div class="col text-center mt-5">
                               <form action="index.php" method="post">
                                <input type="text" placeholder="url" name="url">
                                <button type="submit" id="btn-submit">crawl</button>
                               </form>
                            </div>
                        </div>
                         
                        <div class="row" >
                            
                                <pre>
                                    <?php
                                        if(isset($_POST['url']) && empty($_POST['url']) != true){
                                            $url = $_POST['url'];
                                            $safe_url = escapeshellcmd($url);
                                            $command = "curl -sL $safe_url 2>&1";
                                            exec($command, $output);
                                            echo is_array($output) ? implode("\n", $output) : $output;
                                        }

                                        // $redis = new Redis();
                                        // //Connecting to Redis
                                        // $redis->connect('localhost', 6379);
                                        // $redis->auth('password');

                                        // if ($redis->ping()) {
                                        //    echo "PONGn";
                                        // }
                                    ?>
                                </pre>
                   
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