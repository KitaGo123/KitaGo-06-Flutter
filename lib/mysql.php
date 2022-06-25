<?php 
    $servername = "localhost";
    $user = "root";
    $pw = "";
    $db = "kitago";

    $action = $_POST['action'];
    $table = $_POST['table'];

    #Connect to Server
    $conn = new mysqli($servername, $user, $pw, $db);

    if($conn -> connect_error){
        die("Connection Failed: " . $conn->connect_error);
    }

    if("CUSTOMER" == $table){
        //CREATE TABLE
        if("CREATE_TABLE" == $action){
            $sql = "CREATE TABLE IF NOT EXISTS $table ( 
                id INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                usernameC VARCHAR(255) NOT NULL,
                passwordC VARCHAR(255) NOT NULL,
                nama_lengkap VARCHAR(255) NOT NULL,
                emailC VARCHAR(255) NOT NULL,
                birthDate DateTime NOT NULL,
                telpNumbC VARCHAR(255) NOT NULL,
                created_at timestamp,
                updated_at timestamp,
                )";
            
            if($conn->query($sql) == TRUE){
                echo "success";
            } else {
                echo "error";
            }
            $conn->close();
            return;
        }
        //GET ALL
        if("GET_ALL" == $action){
            $db_data = array();
            $sql = "SELECT id, usernameC, passwordC from $table ORDERBY id DESC";
            $result = $conn->query($sql);
            if($result->num_rows > 0){
                while($row = $result->fetch_assoc()){
                    $db_data[] =$row;
                }
                echo json_decode($db_data);
            } else {
                echo "error";
            }
            $conn->close();
            return;
        }
        //INSERT
        if("ADD" == $action){
            $usernameC = $_POST['usernameC'];
            $passwordC = $_POST['passwordC'];
            $nama_lengkap = $_POST['nama_lengkap'];
            $emailC = $_POST['emailC'];
            $birthDate = $_POST['birthDate'];
            $telpNumbC = $_POST['telpNumbC'];
            $created_at = time;
            $updated_at = time;
            
            $sql = "INSERT INTO $table (usernameC, passwordC, nama_lengkap, emailC, birthDate, telpNumbC, created_at, updated_at) VALUES ('$usernameC', '$passwordC', '$nama_lengkap', '$emailC', '$birthDate', '$telpNumbC', '$created_at', '$updated_at')";
            $result = $conn->query($sql);
            echo "success";
            $conn->close();
            return;
        }
        //UPDATE
        if("UPDATED" == $action){
            $id = $_POST['id'];
            $usernameC = $_POST['usernameC'];
            $passwordC = $_POST['passwordC'];
            $nama_lengkap = $_POST['nama_lengkap'];
            $emailC = $_POST['emailC'];
            $birthDate = $_POST['birthDate'];
            $telpNumbC = $_POST['telpNumbC'];
            $created_at = time;
            $updated_at = time;

            $sql = "UPDATE $table SET usernameC = '$usernameC', passwordC = '$passwordC', nama_lengkap = '$nama_lengkap', emailC = '$emailC', birthDate = '$birthDate', telpNumbC = '$telpNumbC', created_at = '$created_at', updated_at = '$updated_at' WHERE id = $id";
            if($conn->query($sql) == TRUE){
                echo "success";
            } else {
                echo "error";
            }
            $conn->close();
            return;
        }
        //DELETE
        if("DELETED" == $action){
            $id = $_POST['id'];
            $sql = "DELETE FROM $table WHERE id = $id";
            if($conn->query($sql) == TRUE){
                echo "success";
            } else {
                echo "error";
            }
            $conn->close();
            return;
        }
    }

    if (isset($_POST["value"])) {
        

        $value =htmlspecialchars(stripslashes(trim($_POST["value"])));

        $sql = $con->prepare("INSERT INTO tableName (value) VALUES ('$value')");
        $result = $sql->execute();
        if ($result) {
            echo "Success";
        }
        else {
            echo "Failed";
        }
        $con->close();
    } 
    else {
       echo "Not found";
    } 
?>