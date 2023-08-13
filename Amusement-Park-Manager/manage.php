<html>
    <head>
        <title>Amusement Park Manager: Manage</title>
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
    <div class="flex-container">

        <div id="insert" class="flex-child">
            <h2>Insert New Rides</h2>
            <p>Bored of our current selection? Rude.</p>

            <form method="POST" action="manage.php">
                <input type="hidden" id="insertQueryRequest" name="insertQueryRequest">
                <label for="rideName">Name:</label>
                <input type="text" id="rideName" name="rideName" required><br><br>
                <label for="rideWaitingTime">Waiting Time (mins):</label>
                <input type="text" id="rideWaitingTime" name="rideWaitingTime"><br><br>
                <label for="rideKind">Kind:</label>
                <input type="text" id="rideKind" name="rideKind"><br><br>
                <label for="rideDuration">Duration (mins):</label>
                <input type="text" id="rideDuration" name="rideDuration"><br><br>
                <label for="rideHeightLimit">Height Limit (cm):</label>
                <input type="text" id="rideHeightLimit" name="rideHeightLimit"><br><br>
                <input type="submit" value="Insert" name="insertSubmit">
            </form>

        </div>

        

        <div id="update" class="flex-child">
        <h2>Update Rides</h2>
        <p>The values are case sensitive and if you enter in the wrong case, the update statement will not do anything.</p>

        <form method="POST" action="manage.php">
            <input type="hidden" id="updateQueryRequest" name="updateQueryRequest">

            Name: <input type="text" name="name" required> <br /><br />
            
            New  waitingTime: <input type="text" name="newWaitingTime" required> <br /><br />
            
            New  kind: <input type="text" name="newKind" required> <br /><br />
            
            New  duration: <input type="text" name="newDuration" required> <br /><br />
            
            New  heightLimit: <input type="text" name="newHeightLimit" required> <br /><br />

            <p><input type="submit" value="Update" name="updateSubmit" required></p>
        </form>

        </div>
     

        <div id="delete" class="flex-child">
		<h2>Delete Attractions</h2>
        <p>Sometimes, attractions shut down due to a lack of popularity or unsafe conditions. Here, you can delete these attractions.</p>

        <form method="POST" action="manage.php">
            <input type="hidden" id="deleteQueryRequest" name="deleteQueryRequest">
            Enter Attraction Name: <input type="text" name="oldName" required> <br /><br />

            <p><input class="submit" type="submit" value="Delete" name="deleteSubmit"></p>
        </form>

        </div>
    </div>
		

        <div id="result" class="tab-content">
            <h2>Results</h2>
            <?php
            require __DIR__ . '/requests.php';
            require __DIR__ . '/connection.php';

            if (connectToDB()) {
                if (isset($_POST['updateSubmit'])) {
                    handleUpdateRidesRequest();
                } else if (isset($_POST['insertSubmit'])) {
                    handleInsertRequest();
                } else if (isset($_POST['deleteSubmit'])) {
                    handleDeleteRequest();
                }
                echo "<h3>Rides: </h3>";
                printResult(executePlainSQL("SELECT name, kind, waitingTime AS waiting_Time, duration, heightLimit AS height_Limit FROM Attractions a JOIN Rides r ON a.name = r.rideName"));
                echo "<h3> Activities: </h3>";
                printResult(executePlainSQL("SELECT name, kind, waitingTime AS waiting_Time, avgDuration AS avg_Duration FROM Attractions a JOIN Activities c ON a.name = c.activityName"));
                
                disconnectFromDB();
            }
            ?>
        </div>
        
        
	</body>
</html>
