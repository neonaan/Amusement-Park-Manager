<?php
function executePlainSQL($cmdstr) { // executes SQL
    //echo "<br>running ".$cmdstr."<br>";
    global $db_conn, $success;

    $statement = OCIParse($db_conn, $cmdstr);
    
    if (!$statement) {
        echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
        $e = OCI_Error($db_conn); // Pass the connection handle for OCIExecute errors
        echo htmlentities($e['message']);
        $success = False;
    }

    $r = OCIExecute($statement, OCI_DEFAULT);
    if (!$r) {
        echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
        $e = oci_error($statement); // Pass the statement handle for OCIExecute errors
        echo htmlentities($e['message']);
        $success = False;
    }
    return $statement;
}

function executeBoundSQL($cmdstr, $list) {
    global $db_conn, $success;
    $statement = OCIParse($db_conn, $cmdstr);

    if (!$statement) {
        echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
        $e = OCI_Error($db_conn);
        echo htmlentities($e['message']);
        $success = False;
    }

    foreach ($list as $tuple) {
        foreach ($tuple as $bind => $val) {
            //echo $val;
            //echo "<br>".$bind."<br>";
            OCIBindByName($statement, $bind, $val);
            unset ($val); // Do not remove this. Otherwise $val will remain in an array object wrapper and recognized as a proper datatype by Oracle
        }

        $r = OCIExecute($statement, OCI_DEFAULT);
        if (!$r) {
            echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
            $e = OCI_Error($statement); 
            echo htmlentities($e['message']);
            echo "<br>";
            $success = False;
        }
    }
}

function printResult($result) { //prints results from a select statement
    // code sourced from https://stackoverflow.com/questions/50654910/output-entire-table-of-oracle-db-in-website-with-php-and-save-as-csv
    $row = oci_fetch_array($result, OCI_ASSOC);
    if (!$row) {
        echo "NO VALUES.";
        return;
    }

    echo "<table class='result-table'>";
    $num_cols = oci_num_fields($result);
    echo "<tr>";
    for ($i = 1; $i <= $num_cols; $i++) {
        $col_name = oci_field_name($result, $i);
        echo "<th>" . ucwords(strtolower(str_replace("_", " ", $col_name))) . "</th>";
    }
    echo "</tr>";

    while ($row != false) {
        echo "<tr>";
        // for ($i = 0; $i < $num_cols; ++$i) {
        //     if ($row[$i] != NULL) {
        //         echo "<td> $row[$i] </td>";
        //     } else {
        //         echo "<td> - </td>";
        //     }
        // }
        foreach ($row as $col_name => $col_value) {
            if ($col_value != "NULL") {
                echo "<td> $col_value </td>";
            } else {
                echo "<td> - </td>";
            }
        }
        echo "</tr>";
        $row = oci_fetch_array($result, OCI_ASSOC);
    }
    echo "</table>";

}

function handleUpdateRidesRequest() {
    global $db_conn;
    
    $name = $_POST['name'];
    
    $new_waitingTime = $_POST['newWaitingTime'];
  
    $new_kind = $_POST['newKind'];
   
    $new_duration = $_POST['newDuration'];
    
    $new_heightLimit = $_POST['newHeightLimit'];

    executePlainSQL("UPDATE Attractions SET waitingTime=" . $new_waitingTime . ", 
    kind='" . $new_kind . "' WHERE name='" . $name . "'");
    executePlainSQL("UPDATE Rides SET duration=" . $new_duration . ", 
    heightLimit=" . $new_heightLimit . " WHERE rideName='" . $name . "'");
    echo "Check the table for any changes!";

    OCICommit($db_conn);
}

function handleInsertRequest() {
    global $db_conn;
    $employee_id = 91234567; // lucky employee of the month!!

    //Getting the values from user and insert data into the table
    $rideName = $_POST['rideName'];
    $rideDuration = $_POST['rideDuration'] === "" ? "NULL" : $_POST['rideDuration'];
    $rideHeightLimit = $_POST['rideHeightLimit'] === "" ? "NULL" : $_POST['rideHeightLimit'];
    $rideWaitingTime = $_POST['rideWaitingTime'] === "" ? "NULL" : $_POST['rideWaitingTime'];
    $rideKind = $_POST['rideKind'] === "" ? "NULL" : $_POST['rideKind'];

    executePlainSQL("INSERT INTO Attractions VALUES ('$rideName', $rideWaitingTime, '$rideKind')");
    executePlainSQL("INSERT INTO Rides VALUES ('$rideName', $rideDuration, $rideHeightLimit)");
    executePlainSQL("INSERT INTO Operate VALUES ($employee_id, '$rideName')");
    echo "Check the table for any changes!";
    
    OCICommit($db_conn);
}

function handleDeleteRequest() {
    global $db_conn;
    $old_name = $_POST['oldName'];
    
    executePlainSQL("DELETE FROM Attractions WHERE name = '" . $old_name . "'");
    echo "Check the table for any changes!";

    OCICommit($db_conn);
}

function handleSelectRequest() {
    global $db_conn;
    $tableName = $_GET['tableName'];
    $attribute1 = $_GET['attribute1'];
    $attribute2 = $_GET['attribute2'];
    $operator1 = $_GET['operator1'];
    $operator2 = $_GET['operator2'];
    $conditionValue1 = $_GET['conditionValue1']; 
    $conditionValue2 = $_GET['conditionValue2'];
    $operator = $_GET['operator'];
    $result = NULL;
    if ($conditionValue1 === "" && $conditionValue2 === "") {
        $result = executePlainSQL("SELECT * FROM $tableName");
    } else if ($conditionValue1 === "") {
        $result = executePlainSQL("SELECT * FROM $tableName WHERE $attribute2 $operator2 $conditionValue2");
    } else if ($conditionValue2 == "") {
        $result = executePlainSQL("SELECT * FROM $tableName WHERE $attribute1 $operator1 $conditionValue1");
    } else {
        $result = executePlainSQL("SELECT * FROM $tableName WHERE 
        $attribute1 $operator1 $conditionValue1 $operator $attribute2 $operator2 $conditionValue2");
    }
    echo "<h3>Results: </h3>";
    printResult($result);
                
}

function handleJoinRequest() {
    global $db_conn;
    $kind = $_GET["attractionKind"];

    echo "<h3>Results: </h3>";
    printResult(executePlainSQL("SELECT DISTINCT a.kind, e.id, e.name FROM Employees e JOIN Operate o ON e.id = o.employeeId JOIN Attractions a ON a.name = o.attractionName WHERE kind = '" . $kind . "'"));
}

function handleVisitRequest() {
    global $db_conn;
    
    echo "<h3>Results: </h3>";
    printResult(executePlainSQL("SELECT c.id, c.name FROM Customers c WHERE NOT EXISTS ((SELECT name FROM Attractions) MINUS (SELECT v.attractionName FROM Visit v WHERE v.customerId = c.id))"));
}

function handleWinRateRequest() {
    global $db_conn;
    $query = "SELECT COUNT(*) FROM Play p1, Games g1 WHERE p1.gameName = g1.name AND g.difficulty = g1.difficulty AND g.kind = g1.kind";
    echo "<h3>Results: </h3>";
    printResult(executePlainSQL("SELECT g.difficulty, g.kind, SUM(p.frequency) AS total_Plays, SUM(p.wins) AS total_Wins, CONCAT(TO_CHAR(TRUNC((SUM(p.wins) * 10000) / SUM(p.frequency)) / 100), '%') AS win_Rate_Percentage FROM Play p, Games g WHERE p.gameName = g.name GROUP BY g.difficulty, g.kind HAVING 2 < (" . $query . ")"));
}

function handleProjectRequest() {
    global $db_conn;
    echo "<h3>Results: </h3>";
    if(empty($_POST["attributesCheckbox"])) {
        echo "NO VALUES.";
    } else {
        $attributes = implode(', ', $_POST["attributesCheckbox"]); 
        $query = "SELECT DISTINCT " . $attributes;
        if(in_array("waitingTime", $_POST["attributesCheckbox"])) {
        $query .= " AS waiting_Time";
        }
        $query .= " FROM Attractions";
        printResult(executePlainSQL($query));
    }
}

function handleExpensivePrizeRequest() {
    global $db_conn;
    echo "<h3>Results: </h3>";
    printResult(executePlainSQL("SELECT p.kind, MAX(p.cost) AS max_cost FROM PrizesCharacteristics p GROUP BY p.kind HAVING COUNT(*) >= 2"));
}

function handleBadFoodRequest() {
    echo "<h3>Results: </h3>";
    printResult(executePlainSQL("SELECT f.kind, MIN(f.rating) AS min_rating FROM FoodEstablishmentFrom f GROUP BY f.kind"));
}
?>