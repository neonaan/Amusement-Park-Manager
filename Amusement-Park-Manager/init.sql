CREATE TABLE Customers
(
    id     int PRIMARY KEY,
    height int NOT NULL,
    name   char(30),
    age    int
);

CREATE TABLE Events
(
    name      char(30),
    startTime timestamp,
    endTime   timestamp NOT NULL,
    PRIMARY KEY (name, startTime),
    UNIQUE (name, endtime)
);

CREATE TABLE PurchasePasses
(
    id         int PRIMARY KEY,
    price      decimal  NOT NULL,
    kind       char(20) NOT NULL,
    startTime  date     NOT NULL,
    endTime    date     NOT NULL,
    customerId int,
    FOREIGN KEY (customerId) REFERENCES Customers (id)
);

CREATE TABLE CorporationLocation
(
    hqAddress    char(30),
    hqPostalCode char(20),
    hqCity       char(20),
    PRIMARY KEY (hqAddress, hqPostalCode)
);

CREATE TABLE Corporation
(
    name         char(30) PRIMARY KEY,
    hqAddress    char(30),
    hqPostalCode char(20),
    UNIQUE (hqAddress, hqPostalCode),
    FOREIGN KEY (hqAddress, hqPostalCode) REFERENCES CorporationLocation (hqAddress, hqPostalCode) ON DELETE CASCADE
);

CREATE TABLE FoodEstablishmentFrom
(
    corporationName char(30),
    kind            char(20),
    rating          int,
    bestSeller      char(30),
    PRIMARY KEY (corporationName, kind),
    FOREIGN KEY (corporationName) REFERENCES Corporation (name)
        ON DELETE CASCADE
);

CREATE TABLE GamesCharacteristics
(
    difficulty char(10),
    kind       char(20),
    price      decimal NOT NULL,
    PRIMARY KEY (difficulty, kind)
);

CREATE TABLE Games
(
    name       char(30) PRIMARY KEY,
    difficulty char(10) NOT NULL,
    kind       char(20) NOT NULL,
    FOREIGN KEY (difficulty, kind) REFERENCES GamesCharacteristics (difficulty, kind) ON DELETE CASCADE
);

CREATE TABLE Employees
(
    id     int PRIMARY KEY,
    name   char(30) NOT NULL,
    salary int      NOT NULL
);

CREATE TABLE Attractions
(
    name        char(30) PRIMARY KEY,
    waitingTime int      NOT NULL,
    kind        char(20) NOT NULL
);

CREATE TABLE PrizesCharacteristics
(
    name char(30),
    kind char(20),
    cost decimal NOT NULL,
    PRIMARY KEY (name, kind)
);

CREATE TABLE Prizes
(
    id   int PRIMARY KEY,
    name char(30),
    kind char(20),
    FOREIGN KEY (name, kind) REFERENCES PrizesCharacteristics (name, kind) ON DELETE CASCADE
);

CREATE TABLE Rides
(
    rideName    char(30) PRIMARY KEY,
    duration    int NOT NULL,
    heightLimit int,
    FOREIGN KEY (rideName) REFERENCES Attractions (name)
        ON DELETE CASCADE
);

CREATE TABLE Activities
(
    activityName char(30) PRIMARY KEY,
    avgDuration  int NOT NULL,
    FOREIGN KEY (activityName) REFERENCES Attractions (name)
        ON DELETE CASCADE
);

CREATE TABLE Attend
(
    customerId     int,
    eventName      char(30),
    eventStartTime timestamp,
    PRIMARY KEY (customerId, eventName, eventStartTime),
    FOREIGN KEY (customerId) REFERENCES Customers (id),
    FOREIGN KEY (eventName, eventStartTime) REFERENCES Events (name, startTime)
        ON DELETE CASCADE
);

CREATE TABLE EatAt
(
    customerId            int,
    corporationName       char(30),
    foodEstablishmentKind char(20),
    spendings             decimal,
    PRIMARY KEY (customerId, corporationName, foodEstablishmentKind),
    FOREIGN KEY (customerId) REFERENCES Customers (id),
    FOREIGN KEY (corporationName, foodEstablishmentKind) REFERENCES foodEstablishmentFrom (corporationName, kind)
        ON DELETE CASCADE
);

CREATE TABLE PlayOutcomes
(
    frequency int,
    wins      int,
    losses    int,
    PRIMARY KEY (frequency, wins)
);

CREATE TABLE Play
(
    customerId int,
    gameName   char(30),
    frequency  int DEFAULT 1 NOT NULL,
    wins       int,
    PRIMARY KEY (customerId, gameName),
    FOREIGN KEY (customerId) REFERENCES Customers (id),
    FOREIGN KEY (gameName) REFERENCES Games (name)
        ON DELETE CASCADE,
    FOREIGN KEY (frequency, wins) REFERENCES PlayOutcomes (frequency, wins) ON DELETE CASCADE
);

CREATE TABLE Supervise
(
    employeeId int,
    gameName   char(30),
    PRIMARY KEY (employeeId, gameName),
    FOREIGN KEY (employeeId) REFERENCES Employees (id)
        ON DELETE CASCADE,
    FOREIGN KEY (gameName) REFERENCES Games (name)
        ON DELETE CASCADE
);

CREATE TABLE Operate
(
    employeeId     int,
    attractionName char(30),
    PRIMARY KEY (employeeId, attractionName),
    FOREIGN KEY (employeeId) REFERENCES Employees (id)
        ON DELETE CASCADE,
    FOREIGN KEY (attractionName) REFERENCES Attractions (name)
        ON DELETE CASCADE
);

CREATE TABLE Visit
(
    customerId     int,
    attractionName char(30),
    frequency      int DEFAULT 1 NOT NULL,
    PRIMARY KEY (customerId, attractionName),
    FOREIGN KEY (customerId) REFERENCES Customers (id),
    FOREIGN KEY (attractionName) REFERENCES Attractions (name)
        ON DELETE CASCADE
);

CREATE TABLE Offer
(
    prizeId  int,
    gameName char(30),
    PRIMARY KEY (prizeId, gameName),
    FOREIGN KEY (prizeId) REFERENCES Prizes (id)
        ON DELETE CASCADE,
    FOREIGN KEY (gameName) REFERENCES Games (name)
        ON DELETE CASCADE
);

INSERT INTO Customers
VALUES (88888888, 112, 'Chloe Li', 7);
INSERT INTO Customers
VALUES (12345678, 183, 'Richard Anderson', 47);
INSERT INTO Customers
VALUES (87654321, 159, 'Jenny Kim', 62);
INSERT INTO Customers
VALUES (56785678, 137, 'Karina Brooks', 12);
INSERT INTO Customers
VALUES (12341234, 192, 'Janine Chen', 25);

INSERT INTO Events
VALUES ('Halloween in July', to_timestamp('2023-07-30 09:00:00', 'yyyy-mm-dd hh24:mi:ss'),
        to_timestamp('2023-07-30 23:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO Events
VALUES ('Mermaid Day', to_timestamp('2023-07-27 09:00:00', 'yyyy-mm-dd hh24:mi:ss'),
        to_timestamp('2023-07-27 23:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO Events
VALUES ('Fright Night', to_timestamp('2023-10-07 09:00:00', 'yyyy-mm-dd hh24:mi:ss'),
        to_timestamp('2023-10-15 23:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO Events
VALUES ('Park Fair', to_timestamp('2023-08-20 09:00:00', 'yyyy-mm-dd hh24:mi:ss'),
        to_timestamp('2023-09-05 23:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO Events
VALUES ('Happyland', to_timestamp('2023-08-06 09:00:00', 'yyyy-mm-dd hh24:mi:ss'),
        to_timestamp('2023-08-06 23:00:00', 'yyyy-mm-dd hh24:mi:ss'));

INSERT INTO PurchasePasses
VALUES (11111111, 75.00, 'kid', to_date('2023-10-07', 'yyyy-mm-dd'), to_date('2023-10-08', 'yyyy-mm-dd'), 88888888);
INSERT INTO PurchasePasses
VALUES (22222222, 360.00, 'adult', to_date('2023-07-27', 'yyyy-mm-dd'), to_date('2023-07-30', 'yyyy-mm-dd'), 12345678);
INSERT INTO PurchasePasses
VALUES (33333333, 75.00, 'senior', to_date('2023-10-07', 'yyyy-mm-dd'), to_date('2023-10-08', 'yyyy-mm-dd'), 87654321);
INSERT INTO PurchasePasses
VALUES (44444444, 340.00, 'kid', to_date('2023-07-27', 'yyyy-mm-dd'), to_date('2023-07-30', 'yyyy-mm-dd'), 56785678);
INSERT INTO PurchasePasses
VALUES (55555555, 83.00, 'adult', to_date('2023-05-25', 'yyyy-mm-dd'), to_date('2023-05-25', 'yyyy-mm-dd'), 12341234);

INSERT INTO CorporationLocation
VALUES ('500 Kipling Ave', 'M8Z 5E5', 'Toronto');
INSERT INTO CorporationLocation
VALUES ('8223 Sherbrooke St #200', 'V5X 4E6', 'Vancouver');
INSERT INTO CorporationLocation
VALUES ('130 Royall St', '02021', 'Canton');
INSERT INTO CorporationLocation
VALUES ('874 Sinclair Road', 'L6K 2Y1', 'Oakville');
INSERT INTO CorporationLocation
VALUES ('5505 Blue Lagoon Dr', '33126', 'Miami');

INSERT INTO Corporation
VALUES ('Pizza Pizza', '500 Kipling Ave', 'M8Z 5E5');
INSERT INTO Corporation
VALUES ('White Spot', '8223 Sherbrooke St #200', 'V5X 4E6');
INSERT INTO Corporation
VALUES ('Dunkin Donuts', '130 Royall St', '02021');
INSERT INTO Corporation
VALUES ('Tim Hortons', '874 Sinclair Road', 'L6K 2Y1');
INSERT INTO Corporation
VALUES ('Burger King', '5505 Blue Lagoon Dr', '33126');

INSERT INTO FoodEstablishmentFrom
VALUES ('Pizza Pizza', 'restaurant', 5, 'pepperoni pizza');
INSERT INTO FoodEstablishmentFrom
VALUES ('White Spot', 'restaurant', 4, 'toasted shrimp sandwich');
INSERT INTO FoodEstablishmentFrom
VALUES ('Dunkin Donuts', 'stand', 2, 'glazed donut');
INSERT INTO FoodEstablishmentFrom
VALUES ('Tim Hortons', 'restaurant', 4, 'timbits');
INSERT INTO FoodEstablishmentFrom
VALUES ('Burger King', 'restaurant', 3, 'big king jr');
INSERT INTO FoodEstablishmentFrom
VALUES ('Burger King', 'stand', 1, 'little queen sr');
INSERT INTO FoodEstablishmentFrom
VALUES ('Pizza Pizza', 'stand', 5, 'little princess');
INSERT INTO FoodEstablishmentFrom
VALUES ('White Spot', 'stand', 5, 'little prince');
INSERT INTO FoodEstablishmentFrom
VALUES ('Tim Hortons', 'cafe', 1, 'double double');
INSERT INTO FoodEstablishmentFrom
VALUES ('Pizza Pizza', 'cafe', 2, 'triple triple');
INSERT INTO FoodEstablishmentFrom
VALUES ('Dunkin Donuts', 'cafe', 4, 'quadruple quadruple');

INSERT INTO GamesCharacteristics
VALUES ('easy', 'shooting', 5.00);
INSERT INTO GamesCharacteristics
VALUES ('medium', 'shooting', 4.00);
INSERT INTO GamesCharacteristics
VALUES ('hard', 'strategy', 1.00);
INSERT INTO GamesCharacteristics
VALUES ('easy', 'hitting', 5.00);
INSERT INTO GamesCharacteristics
VALUES ('hard', 'strength', 2.00);
INSERT INTO GamesCharacteristics
VALUES ('hard', 'shooting', 3.00);
INSERT INTO GamesCharacteristics
VALUES ('medium', 'strategy', 2.00);

INSERT INTO Games
VALUES ('Mini Basketball', 'easy', 'shooting');
INSERT INTO Games
VALUES ('Bean Bag Toss', 'medium', 'shooting');
INSERT INTO Games
VALUES ('Park Quiz', 'hard', 'strategy');
INSERT INTO Games
VALUES ('Pinata Smash', 'easy', 'hitting');
INSERT INTO Games
VALUES ('Ladder Climb', 'hard', 'strength');
INSERT INTO Games
VALUES ('Balloon Pop', 'easy', 'shooting');
INSERT INTO Games
VALUES ('Darts', 'medium', 'shooting');
INSERT INTO Games
VALUES ('Claw Machine', 'hard', 'strategy');
INSERT INTO Games
VALUES ('Whack-A-Mole', 'easy', 'hitting');
INSERT INTO Games
VALUES ('Greasy Grip', 'hard', 'strength');
INSERT INTO Games
VALUES ('Shotgun', 'easy', 'shooting');
INSERT INTO Games
VALUES ('Hit the Target', 'medium', 'shooting');
INSERT INTO Games
VALUES ('Ultimate Tic-Tac-Toe', 'hard', 'strategy');
INSERT INTO Games
VALUES ('High Striker', 'easy', 'hitting');
INSERT INTO Games
VALUES ('Wobbly Bridge', 'hard', 'strength');
INSERT INTO Games
VALUES ('Water Gun Game', 'easy', 'shooting');
INSERT INTO Games
VALUES ('Miniature Rifle Game', 'hard', 'shooting');
INSERT INTO Games
VALUES ('Cover the Spot', 'medium', 'strategy');

INSERT INTO Employees
VALUES (24682468, 'Sam Nagaya', 27788);
INSERT INTO Employees
VALUES (91234567, 'Ella Porte', 29250);
INSERT INTO Employees
VALUES (76543210, 'Lukey Chapman', 29985);
INSERT INTO Employees
VALUES (66688666, 'Mia Zhang', 29300);
INSERT INTO Employees
VALUES (77777777, 'Lexia Hadis', 29900);
INSERT INTO Employees
VALUES (11001100, 'Daeya Min', 27788);
INSERT INTO Employees
VALUES (99110011, 'Rhia Young', 29250);
INSERT INTO Employees
VALUES (99991111, 'Rue Parker', 29985);
INSERT INTO Employees
VALUES (11110000, 'Bella Huang', 29300);
INSERT INTO Employees
VALUES (44442222, 'Ei Baal', 29900);
INSERT INTO Employees
VALUES (22224444, 'Bola Davis', 27788);
INSERT INTO Employees
VALUES (22442244, 'Sonia Im', 29250);
INSERT INTO Employees
VALUES (44224422, 'Tia Demen', 29985);
INSERT INTO Employees
VALUES (10101010, 'Cole Smith', 29300);
INSERT INTO Employees
VALUES (91010101, 'Laura Johnson', 29900);

INSERT INTO Attractions
VALUES ('Wooden Roller Coaster', 45, 'roller coaster');
INSERT INTO Attractions
VALUES ('Atmosfear', 60, 'height');
INSERT INTO Attractions
VALUES ('Splash Mountain', 150, 'water ride');
INSERT INTO Attractions
VALUES ('Musical Express', 15, 'spinning');
INSERT INTO Attractions
VALUES ('Mad Tea Cups', 20, 'spinning');
INSERT INTO Attractions
VALUES ('Haunted House', 20, 'horror');
INSERT INTO Attractions
VALUES ('Garden Maze', 5, 'strategy');
INSERT INTO Attractions
VALUES ('Escape Room', 120, 'strategy');
INSERT INTO Attractions
VALUES ('Rock Climbing', 15, 'sport');
INSERT INTO Attractions
VALUES ('Mini Golf', 5, 'sport');

INSERT INTO PrizesCharacteristics
VALUES ('Furby', 'plush', 5.00);
INSERT INTO PrizesCharacteristics
VALUES ('Pokemon', 'plush', 10.00);
INSERT INTO PrizesCharacteristics
VALUES ('Barbie', 'doll', 15.00);
INSERT INTO PrizesCharacteristics
VALUES ('Ken', 'doll', 12.00);
INSERT INTO PrizesCharacteristics
VALUES ('Ghibli', 'keychain', 2.00);
INSERT INTO PrizesCharacteristics
VALUES ('Kirby', 'keychain', 4.00);
INSERT INTO PrizesCharacteristics
VALUES ('Marvel', 'action figure', 5.00);

INSERT INTO Prizes
VALUES (12345432, 'Furby', 'plush');
INSERT INTO Prizes
VALUES (54321234, 'Pokemon', 'plush');
INSERT INTO Prizes
VALUES (98765678, 'Barbie', 'doll');
INSERT INTO Prizes
VALUES (54310483, 'Ken', 'doll');
INSERT INTO Prizes
VALUES (56789876, 'Ghibli', 'keychain');
INSERT INTO Prizes
VALUES (47392812, 'Kirby', 'keychain');
INSERT INTO Prizes
VALUES (99999999, 'Marvel', 'action figure');

INSERT INTO Rides
VALUES ('Wooden Roller Coaster', 5, 122);
INSERT INTO Rides
VALUES ('Atmosfear', 7, 112);
INSERT INTO Rides
VALUES ('Splash Mountain', 10, 102);
INSERT INTO Rides
VALUES ('Musical Express', 5, null);
INSERT INTO Rides
VALUES ('Mad Tea Cups', 10, null);

INSERT INTO Activities
VALUES ('Haunted House', 20);
INSERT INTO Activities
VALUES ('Garden Maze', 25);
INSERT INTO Activities
VALUES ('Escape Room', 45);
INSERT INTO Activities
VALUES ('Rock Climbing', 3);
INSERT INTO Activities
VALUES ('Mini Golf', 60);

INSERT INTO Attend
VALUES (12345678, 'Halloween in July', to_timestamp('2023-07-30 09:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO Attend
VALUES (12345678, 'Mermaid Day', to_timestamp('2023-07-27 09:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO Attend
VALUES (56785678, 'Halloween in July', to_timestamp('2023-07-30 09:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO Attend
VALUES (56785678, 'Mermaid Day', to_timestamp('2023-07-27 09:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO Attend
VALUES (87654321, 'Fright Night', to_timestamp('2023-10-07 09:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO Attend
VALUES (88888888, 'Fright Night', to_timestamp('2023-10-07 09:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO Attend
VALUES (12341234, 'Park Fair', to_timestamp('2023-08-20 09:00:00', 'yyyy-mm-dd hh24:mi:ss'));
INSERT INTO Attend
VALUES (12341234, 'Happyland', to_timestamp('2023-08-06 09:00:00', 'yyyy-mm-dd hh24:mi:ss'));

INSERT INTO EatAt
VALUES (88888888, 'Pizza Pizza', 'restaurant', 10.00);
INSERT INTO EatAt
VALUES (12345678, 'White Spot', 'restaurant', 30.00);
INSERT INTO EatAt
VALUES (87654321, 'Dunkin Donuts', 'stand', 5.00);
INSERT INTO EatAt
VALUES (56785678, 'Tim Hortons', 'restaurant', 5.00);
INSERT INTO EatAt
VALUES (12341234, 'Burger King', 'restaurant', 20.75);

INSERT INTO PlayOutcomes
VALUES (10, 0, 10);
INSERT INTO PlayOutcomes
VALUES (5, 1, 4);
INSERT INTO PlayOutcomes
VALUES (1, 1, 0);
INSERT INTO PlayOutcomes
VALUES (15, 0, 15);
INSERT INTO PlayOutcomes
VALUES (8, 8, 0);
INSERT INTO PlayOutcomes
VALUES (7, 5, 2);
INSERT INTO PlayOutcomes
VALUES (5, 4, 1);
INSERT INTO PlayOutcomes
VALUES (5, 2, 3);
INSERT INTO PlayOutcomes
VALUES (8, 2, 6);
INSERT INTO PlayOutcomes
VALUES (7, 0, 7);
INSERT INTO PlayOutcomes
VALUES (8, 7, 1);
INSERT INTO PlayOutcomes
VALUES (10, 4, 6);
INSERT INTO PlayOutcomes
VALUES (5, 3, 2);
INSERT INTO PlayOutcomes
VALUES (10, 1, 9);
INSERT INTO PlayOutcomes
VALUES (15, 2, 13);
INSERT INTO PlayOutcomes
VALUES (8, 4, 4);

INSERT INTO Play
VALUES (88888888, 'Balloon Pop', 5, 1);
INSERT INTO Play
VALUES (12345678, 'Darts', 10, 0);
INSERT INTO Play
VALUES (87654321, 'Claw Machine', 15, 0);
INSERT INTO Play
VALUES (12341234, 'Whack-A-Mole', 8, 8);
INSERT INTO Play
VALUES (56785678, 'Greasy Grip', 1, 1);
INSERT INTO Play
VALUES (12341234, 'Mini Basketball', 5, 3);
INSERT INTO Play
VALUES (87654321, 'Park Quiz', 15, 2);
INSERT INTO Play
VALUES (88888888, 'Pinata Smash', 8, 4);
INSERT INTO Play
VALUES (56785678, 'Ladder Climb', 10, 1);
INSERT INTO Play
VALUES (87654321, 'Shotgun', 8, 7);
INSERT INTO Play
VALUES (88888888, 'Hit the Target', 10, 4);
INSERT INTO Play
VALUES (56785678, 'Ultimate Tic-Tac-Toe', 5, 1);
INSERT INTO Play
VALUES (12345678, 'High Striker', 1, 1);
INSERT INTO Play
VALUES (12341234, 'Wobbly Bridge', 7, 0);
INSERT INTO Play
VALUES (87654321, 'Water Gun Game', 5, 1); 
INSERT INTO Play
VALUES (87654321, 'Miniature Rifle Game', 8, 4); 
INSERT INTO Play
VALUES (87654321, 'Cover the Spot', 5, 2); 
INSERT INTO Play
VALUES (12345678, 'Water Gun Game', 8, 8); 
INSERT INTO Play
VALUES (12345678, 'Miniature Rifle Game', 8, 2); 
INSERT INTO Play
VALUES (12345678, 'Cover the Spot', 5, 3); 
INSERT INTO Play
VALUES (56785678, 'Miniature Rifle Game', 7, 5); 
INSERT INTO Play
VALUES (88888888, 'Cover the Spot', 10, 1); 

INSERT INTO Supervise
VALUES (66688666, 'Balloon Pop');
INSERT INTO Supervise
VALUES (77777777, 'Darts');
INSERT INTO Supervise
VALUES (76543210, 'Claw Machine');
INSERT INTO Supervise
VALUES (24682468, 'Whack-A-Mole');
INSERT INTO Supervise
VALUES (91234567, 'Greasy Grip');

INSERT INTO Operate
VALUES (11001100, 'Wooden Roller Coaster');
INSERT INTO Operate
VALUES (99110011, 'Atmosfear');
INSERT INTO Operate
VALUES (99991111, 'Splash Mountain');
INSERT INTO Operate
VALUES (11110000, 'Musical Express');
INSERT INTO Operate
VALUES (44442222, 'Mad Tea Cups');
INSERT INTO Operate
VALUES (22224444, 'Haunted House');
INSERT INTO Operate
VALUES (22442244, 'Garden Maze');
INSERT INTO Operate
VALUES (44224422, 'Escape Room');
INSERT INTO Operate
VALUES (10101010, 'Rock Climbing');
INSERT INTO Operate
VALUES (91010101, 'Mini Golf');

INSERT INTO Visit
VALUES (88888888, 'Mad Tea Cups', 15);
INSERT INTO Visit
VALUES (12345678, 'Haunted House', 5);
INSERT INTO Visit
VALUES (12345678, 'Atmosfear', 6);
INSERT INTO Visit
VALUES (12345678, 'Mad Tea Cups', 6);
INSERT INTO Visit
VALUES (12345678, 'Escape Room', 3);
INSERT INTO Visit
VALUES (12345678, 'Garden Maze', 3);
INSERT INTO Visit
VALUES (12345678, 'Splash Mountain', 5);
INSERT INTO Visit
VALUES (12345678, 'Wooden Roller Coaster', 5);
INSERT INTO Visit
VALUES (12345678, 'Musical Express', 5);
INSERT INTO Visit
VALUES (12345678, 'Rock Climbing', 4);
INSERT INTO Visit
VALUES (12345678, 'Mini Golf', 3);
INSERT INTO Visit
VALUES (87654321, 'Garden Maze', 1);
INSERT INTO Visit
VALUES (56785678, 'Haunted House', 1);
INSERT INTO Visit
VALUES (56785678, 'Atmosfear', 1);
INSERT INTO Visit
VALUES (56785678, 'Mad Tea Cups', 10);
INSERT INTO Visit
VALUES (56785678, 'Escape Room', 1);
INSERT INTO Visit
VALUES (56785678, 'Garden Maze', 1);
INSERT INTO Visit
VALUES (56785678, 'Splash Mountain', 21);
INSERT INTO Visit
VALUES (56785678, 'Wooden Roller Coaster', 12);
INSERT INTO Visit
VALUES (56785678, 'Musical Express', 42);
INSERT INTO Visit
VALUES (56785678, 'Rock Climbing', 4);
INSERT INTO Visit
VALUES (56785678, 'Mini Golf', 1);
INSERT INTO Visit
VALUES (12341234, 'Haunted House', 5);
INSERT INTO Visit
VALUES (12341234, 'Atmosfear', 7);
INSERT INTO Visit
VALUES (12341234, 'Mad Tea Cups', 8);
INSERT INTO Visit
VALUES (12341234, 'Escape Room', 11);
INSERT INTO Visit
VALUES (12341234, 'Garden Maze', 5);
INSERT INTO Visit
VALUES (12341234, 'Splash Mountain', 8);
INSERT INTO Visit
VALUES (12341234, 'Wooden Roller Coaster', 9);
INSERT INTO Visit
VALUES (12341234, 'Musical Express', 10);
INSERT INTO Visit
VALUES (12341234, 'Rock Climbing', 7);
INSERT INTO Visit
VALUES (12341234, 'Mini Golf', 5);

INSERT INTO Offer
VALUES (12345432, 'Whack-A-Mole');
INSERT INTO Offer
VALUES (54321234, 'Greasy Grip');
INSERT INTO Offer
VALUES (98765678, 'Claw Machine');
INSERT INTO Offer
VALUES (56789876, 'Balloon Pop');
INSERT INTO Offer
VALUES (99999999, 'Darts');