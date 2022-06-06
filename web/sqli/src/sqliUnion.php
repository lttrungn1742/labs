<?php
    include 'db.php';
?>

<html>
<head>
    <title>SQL  Injection Union</title>
    <link rel="icon" type="image/png" href="/static/favicon.png">
    <link rel="stylesheet" type="text/css" href="/static/css/prism.css" />
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" href="/static/css/main.css">
    <style>
        @charset "UTF-8";
        @import url(https://fonts.googleapis.com/css?family=Open+Sans:300,400,700);

        body {
        font-family: 'Open Sans', sans-serif;
        font-weight: 300;
        line-height: 1.42em;
        color:#A7A1AE;

        }

        h1 {
        font-size:3em; 
        font-weight: 300;
        line-height:1em;
        text-align: center;
        color: #4DC3FA;
        }

        h2 {
        font-size:1em; 
        font-weight: 300;
        text-align: center;
        display: block;
        line-height:1em;
        padding-bottom: 2em;
        color: #FB667A;
        }

        h2 a {
        font-weight: 700;
        text-transform: uppercase;
        color: #FB667A;
        text-decoration: none;
        }

        .blue { color: #185875; }
        .yellow { color: #FFF842; }

        .container th h1 {
            font-weight: bold;
            font-size: 1em;
        text-align: left;
        color: #185875;
        }

        .container td {
            font-weight: normal;
            font-size: 1em;
        -webkit-box-shadow: 0 2px 2px -2px #0E1119;
            -moz-box-shadow: 0 2px 2px -2px #0E1119;
                box-shadow: 0 2px 2px -2px #0E1119;
        }

        .container {
            text-align: left;
            overflow: hidden;
            width: 80%;
            margin: 0 auto;
        display: table;
        padding: 0 0 8em 0;
        }

        .container td, .container th {
            padding-bottom: 2%;
            padding-top: 2%;
        padding-left:2%;  
        }

        /* Background-color of the odd rows */
        .container tr:nth-child(odd) {
            background-color: #323C50;
        }

        /* Background-color of the even rows */
        .container tr:nth-child(even) {
            background-color: #2C3446;
        }

        .container th {
            background-color: #1F2739;
        }

        .container td {
            font-size: 30px;
        }


        .container td:first-child { color: #FB667A; }

        .container tr:hover {
        background-color: #464A52;
        -webkit-box-shadow: 0 6px 6px -6px #0E1119;
            -moz-box-shadow: 0 6px 6px -6px #0E1119;
                box-shadow: 0 6px 6px -6px #0E1119;
        }

        .container td:hover {
        background-color: #FFF842;
        color: #403E10;
        font-weight: bold;
        
        box-shadow: #7F7C21 -1px 1px, #7F7C21 -2px 2px, #7F7C21 -3px 3px, #7F7C21 -4px 4px, #7F7C21 -5px 5px, #7F7C21 -6px 6px;
        transform: translate3d(6px, -6px, 0);
        
        transition-delay: 0s;
            transition-duration: 0.4s;
            transition-property: all;
        transition-timing-function: line;
        }

    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light mb-4" style="background-color: #e3f2fd;">
        <a class="navbar-brand mb-0 h1" href="/">👨‍⚕️ SQL  Injection Error Base</a>
        <div class="collapse navbar-collapse" id="navbarSupportedContent"></div>
    </nav>
    <div class="container" style="max-width:1430px !important;">
        <div class="card">
            <div class="card-body">
                <div class="card-text">
                    <h3>Table employee</h3>
                    <form action="sqliUnion.php" method="GET">
                    <div class="input-group">
                        <h1>Search job by id  </h1>
                        <input type="text" id="id" name="id">
                        <input type="submit"  class="btn btn-primary">
                    </div>
                    <br>
                    <div>
                        <table class="container">
                            <thead>
                                <tr>
                                    <th>Id</th>
                                    <th>Title</th>
                                    <th>Salary</th>
                                    <th>Location</th>
                                    <th>Type</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php
                                    if (isset($_GET['id'])){
                                        $sql =  "SELECT * FROM jobs WHERE id=" . $_GET['id'];
                                        $result = $conn->query($sql);
                                        if ($result->num_rows > 0) {
                                        while($row = $result->fetch_assoc()) {
                                            echo "<tr>
                                                    <td>" . $row["id"] . " </td>
                                                    <td>" . $row["title"]. " </td>
                                                    <td>" . $row["salary"]. "$</td>
                                                    <td>" . $row["location"]. "</td>
                                                    <td>" . $row["type"]. "</td>
                                                    <td>" . $row["date"]. "</td>
                                            </tr>";
                                        }
                                        } else {
                                            echo "<h1>0 results</h1>";
                                        }
                                        $conn->close();
                                    }
                                ?>
                            </tbody>       
                        </table>
     
                    </div>
                </form>
                </div>
                <br>
                
            </div>
        </div>
    </div>
</body>

<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script><script src="/static/js/prism.js"></script>
</html>