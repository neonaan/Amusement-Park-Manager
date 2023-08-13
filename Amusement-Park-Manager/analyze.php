<html>
    <head>
        <title>Amusement Park Manager: Analyze</title>
        <link rel="stylesheet" href="index.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@600&display=swap" rel="stylesheet">
    </head>
  
    <body>
    <div class="navigation">
		<div class="title">
        <h1>Amusement Park Manager: Manage</h1>
        </div>

        <button class="button" type="button" onclick="window.location.href = 'home.php'">Go Home</button>
    </div>

        <hr />

        <div id="select" class="tab-content">
        <h2>Amusement Park Info</h2>
        <p>Get information about games, prizes, customers, and employees.</p>

        <p> Pick a table: </p>
        <form method="GET" action="analyze.php" id="selectTable">
            <input type="hidden" id="selectTableRequest" name="selectTableRequest">
            <input type="radio" id="selectGames" name="selectTable" value="Games" required>
            <label for="selectGames">Games</label>
            <input type="radio" id="selectPrizes" name="selectTable" value="Prizes">
            <label for="selectPrizes">Prizes</label>
            <input type="radio" id="selectCustomers" name="selectTable" value="Customers">
            <label for="selectCustomers">Customers</label>
            <input type="radio" id="selectEmployees" name="selectTable" value="Employees">
            <label for="selectEmployees">Employees</label>

            <p><input type="submit" value="Confirm" name="confirmTable"></p>
        </form>

        <form method="GET" action="analyze.php">
            <input type="hidden" id="selectAttributesRequest" name="selectAttributesRequest">
            <?php
            $tableName = NULL;
            require __DIR__ . '/requests.php';
            require __DIR__ . '/connection.php';
            if (isset($_GET['selectTableRequest'])) {
                if (connectToDB()) {
                    global $db_conn;
                    $tableName = $_GET['selectTable'];
                    echo "<input type='hidden' name='tableName' value='$tableName'>";
                    $result = executePlainSQL("SELECT * FROM $tableName");
                    echo "Define up to two conditions on the $tableName attributes. <br>";
                    echo "If the condition value is a string, please add single quotation marks around it. <br>";
                    echo "<select name='attribute1' id='attribute1'>";
                    $columns = executePlainSQL("SELECT COLUMN_NAME FROM USER_TAB_COLS WHERE TABLE_NAME = UPPER('$tableName')");
                    while ($row = OCI_Fetch_Array($columns, OCI_BOTH)) {
                        $col = strtolower($row[0]);
                        echo "<option id='$col' name='$col' value='$col'> $col </option>";
                        echo "</tr>";
                    }
                    echo "</select>";
                    echo "<select name='operator1' id='operator1'>";
                    echo "<option id='equalsTo1' name='operator1' value='='> = </option>";
                    echo "</tr>";
                    echo "<option id='notEqualsTo1' name='operator1' value='<>'> ≠ </option>";
                    echo "</tr>";
                    echo "<option id='lessThan1' name='operator1' value='<'> < </option>";
                    echo "</tr>";
                    echo "<option id='greaterThan1' name='operator1' value='>'> > </option>";
                    echo "</tr>";
                    echo "<option id='lessThanOrEqualsTo1' name='operator1' value='<='> ≤ </option>";
                    echo "</tr>";
                    echo "<option id='greaterThanOrEqualsTo1' name='operator1' value='>='> ≥ </option>";
                    echo "</tr>";
                    echo "</select>";
                    echo "<input type='text' name='conditionValue1' id='conditionValue1'>";
                    echo "&nbsp";
                    echo "<select name='operator' id='operator'>";
                    echo "<option name='operator' id='operatorAND' value='AND'> AND </option>";
                    echo "<option name='operator' id='operatorOR' value='OR'> OR </option>";
                    echo "</select>";
                    echo "&nbsp";
                    echo "<select name='attribute2' id='attribute2'>";
                    $columns = executePlainSQL("SELECT COLUMN_NAME FROM USER_TAB_COLS WHERE TABLE_NAME = UPPER('$tableName')");
                    while ($row = OCI_Fetch_Array($columns, OCI_BOTH)) {
                        $col = strtolower($row[0]);
                        echo "<option id='$col' name='$col' value='$col'> $col </option>";
                        echo "</tr>";
                    }
                    echo "</select>";
                    echo "</select>";
                    echo "<select name='operator2' id='operator2'>";
                    echo "<option id='equalsTo2' name='operator2' value='='> = </option>";
                    echo "</tr>";
                    echo "<option id='notEqualsTo2' name='operator2' value='<>'> ≠ </option>";
                    echo "</tr>";
                    echo "<option id='lessThan2' name='operator2' value='<'> < </option>";
                    echo "</tr>";
                    echo "<option id='greaterThan2' name='operator2' value='>'> > </option>";
                    echo "</tr>";
                    echo "<option id='lessThanOrEqualsTo2' name='operator2' value='<='> ≤ </option>";
                    echo "</tr>";
                    echo "<option id='greaterThanOrEqualsTo2' name='operator2' value='>='> ≥ </option>";
                    echo "</tr>";
                    echo "</select>";
                    echo "<input type='text' name='conditionValue2' id='conditionValue2'>";
                    echo "<p><input type='submit' value='Submit' name='submitAttributes'></p>";
                    disconnectFromDB();
                }
            }
            ?>
        </form>

        <?php
        if (isset($_GET['selectAttributesRequest'])) {
            if (connectToDB()) {
                handleSelectRequest();
                disconnectFromDB();
            }
        }
        ?>
        </div>

        <br>

        <div id="join" class="tab-content">
        <h2>Amusement Park Employees</h2>
        <p>Adding a new attraction and looking to see who may have experience? No problem!
            <br> Want to see who can show the ropes for new employees? No problem!
            <br> Have information to relay about a certain kind of attraction and don't know who to inform? No problem!
            <br>
            <br> Pick the kind of attraction you are interested in and a list of employees that operate these kinds of attractions will be shown below.
        </p>

        <form method="GET" action="analyze.php">
            <input type="hidden" id="employeeAttractionKindRequest" name="employeeAttractionKindRequest">
            Choose Attraction Kind:
            <select name="attractionKind" id="attractionKind">
                <?php
                if(connectToDB()) {
                    global $db_conn;
                    $result = executePlainSQL("SELECT DISTINCT kind FROM Attractions");
                    while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                        echo "<option value=\"" . $row[0] . "\">" . ucwords($row[0]) . "</option>";
                        echo "</tr>";
                    }
                    disconnectFromDB();
                } else {
                    echo "<option value=\"na\">Not Available</option>";
                }
                ?>
            </select>

            <p><input type="submit" value="Submit" name="attractionKindSubmit"></p>
        </form>
        <?php
        if(isset($_GET['employeeAttractionKindRequest']) && connectToDB()) {
            handleJoinRequest();
            disconnectFromDB();
        }
        ?>
        </div>
        <br>

        <div id="division" class="tab-content">
        <h2>Amusement Park Visits</h2>
        <p>Here we can list the ids and names of customers that have visited every ride and attraction. Perhaps it may be time we reward these thrill seekers with a discount?</p>

        <form method="GET" action="analyze.php">
            <input type="hidden" id="visitRequest" name="visitRequest">
            <p><input type="submit" value="Submit" name="visitSubmit"></p>
        </form>
        <?php
        if(isset($_GET['visitRequest']) && connectToDB()) {
            handleVisitRequest();
            disconnectFromDB();
        }
        ?>
        </div>
        <br>

        <div id="nested-aggregation" class="tab-content">
        <h2>Amusement Park Game WinRate</h2>
        <p>Want to make changes to the selection of games but unsure which ones? Here we can list the difficulty and kind of games along with their total plays and wins.</p>

        <form method="GET" action="analyze.php">
            <input type="hidden" id="winRateRequest" name="winRateRequest">
            
            <p><input type="submit" value="Submit" name="winRateSubmit"></p>
        </form>
        <?php
        if(isset($_GET['winRateRequest']) && connectToDB()) {
            handleWinRateRequest();
            disconnectFromDB();
        }
        ?>
        </div>

        <br>

        <div id="project" class="tab-content">
        <h2>Amusement Park Attractions</h2>
        <p>List the specified attributes of every attraction in the amusement park.</p>

        <form method="POST" action="analyze.php">
            <input type="hidden" id="attractionAttributesProjectionRequest" name="attractionAttributesProjectionRequest">
                <input type="checkbox" name="attributesCheckbox[]" value="name"> Name
                <input type="checkbox" name="attributesCheckbox[]" value="kind"> Kind
                <input type="checkbox" name="attributesCheckbox[]" value="waitingTime"> Waiting Time

            <p><input type="submit" value="Submit" name="projectAttributes"></p>
        </form>
        <?php
        if(isset($_POST['attractionAttributesProjectionRequest']) && connectToDB()) {
            handleProjectRequest();
            disconnectFromDB();
        }
        ?>
        </div>

        <br>

        <div id="aggregation-having" class="tab-content">
        <h2>Carnival Game Prizes</h2>
        <p>List the cost of the most expensive prize for each kind, where there are at least 2 prizes of that kind.</p>

        <form method="GET" action="analyze.php">
            <input type="hidden" id="expensivePrizeRequest" name="expensivePrizeRequest">
            
            <p><input type="submit" value="Submit" name="expensivePrizeSubmit"></p>
        </form>
        <?php
        if(isset($_GET['expensivePrizeSubmit']) && connectToDB()) {
            handleExpensivePrizeRequest();
            disconnectFromDB();
        }
        ?>
        </div>

        <br>

        <div id="aggregation-group-by" class="tab-content">
        <h2>Lowest rated Food Establishments (by Kind)</h2>
        <p>List the lowest rated food establishment for each kind.</p>

        <form method="GET" action="analyze.php">
            <input type="hidden" id="badFoodRequest" name="badFoodRequest">
            
            <p><input type="submit" value="Submit" name="badFoodSubmit"></p>
        </form>
        <?php
        if(isset($_GET['badFoodRequest']) && connectToDB()) {
            handleBadFoodRequest();
            disconnectFromDB();
        }
        ?>
        </div>
    </body>
</html>