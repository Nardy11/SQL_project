--- Database Control Functions ---
CREATE DATABASE SportsDB;
use SportsDB;

--- Create DB ---
EXEC createAllTables

--- Drop DB ---
EXEC dropAllTables
EXEC dropAllProceduresFunctionsViews


--2.1 BASic Structure of the DatabASe
--Part a

GO
CREATE PROCEDURE createAllTables AS

CREATE TABLE SystemUser (
username VARCHAR(20) PRIMARY KEY,
password VARCHAR(20),
);

CREATE TABLE Stadium (
id INT IDENTITY PRIMARY KEY,
name VARCHAR(20),
location  VARCHAR(20),
status BIT default 1 ,-- 0 unavailable , 1 available
capacity INT,
);

CREATE TABLE StadiumManager (
id INT IDENTITY PRIMARY KEY,
name VARCHAR(20),
username VARCHAR(20),
stadium_id INT,
FOREIGN KEY (username) REFERENCES SystemUser(username),
FOREIGN KEY (stadium_id) REFERENCES Stadium(ID), --relatiON 1 to 1 between stadium & stadium manager
);

CREATE TABLE Club (
id INT IDENTITY PRIMARY KEY,
name VARCHAR(20),
location VARCHAR(20),
);

CREATE TABLE ClubRepresentative (
id INT IDENTITY PRIMARY KEY,
name VARCHAR(20),
username VARCHAR(20),
club_id INT,
FOREIGN KEY (username) REFERENCES SystemUser(username),
FOREIGN KEY (club_id) REFERENCES Club(id),--relatiON 1 to 1 between club & ClubRepresentative
);

CREATE TABLE Fan (
national_id INT PRIMARY KEY,
username VARCHAR(20),
name VARCHAR(20),
phone_number INT,
birthdate DATETIME,
address VARCHAR(20),
status BIT default 1,			-- 1 for unblocked , 0 for blocked
FOREIGN KEY (username) REFERENCES SystemUser(username),
);

CREATE TABLE SportAssociationManager (
id INT IDENTITY PRIMARY KEY,
name VARCHAR(20),
username VARCHAR(20),
FOREIGN KEY (username) REFERENCES SystemUser(username),
);

CREATE TABLE SystemAdmin (
id INT IDENTITY PRIMARY KEY,
name VARCHAR(20),
username VARCHAR(20),
FOREIGN KEY (username) REFERENCES SystemUser(username),
);


CREATE TABLE Match (
id INT IDENTITY PRIMARY KEY,
start_time DATETIME,
end_time DATETIME,
host_id INT,
guest_id INT,
stadium_id INT,
FOREIGN KEY (stadium_id) REFERENCES Stadium(id),--relatiON 1 to many between Stadium & Match
FOREIGN KEY (host_id) REFERENCES Club(id),--relatiON 1 to many between Club & Match
FOREIGN KEY (guest_id) REFERENCES Club(id),--relatiON 1 to many between Club & Match
);


CREATE TABLE HostRequest (
id INT IDENTITY PRIMARY KEY,
status VARCHAR(20), --unhandled, accepted or rejected
match_id INT,
stadium_manager_id INT,
club_representative_id INT,
FOREIGN KEY (match_id) REFERENCES Match(id),--added nardy
FOREIGN KEY (stadium_manager_id) REFERENCES StadiumManager(id),
FOREIGN KEY (club_representative_id) REFERENCES ClubRepresentative(id),
);

CREATE TABLE Ticket (
id INT IDENTITY PRIMARY KEY,
match_id INT,
FOREIGN KEY (match_id) REFERENCES Match(id),
);

CREATE TABLE TicketBuyingTransactions (
ticket_ INT,
fan_id INT,
FOREIGN KEY (fan_id) REFERENCES Fan (national_id),
FOREIGN KEY (ticket_id) REFERENCES Ticket(id),
);


--------------------------------------------------
--Part b

GO
CREATE PROCEDURE dropAllTables AS
DROP TABLE SystemAdmin
DROP TABLE Ticket_Buying_Transactions
DROP TABLE SportAssociationManager
DROP TABLE HostRequest
DROP TABLE Ticket
DROP TABLE Match
DROP TABLE Fan
DROP TABLE ClubRepresentative
DROP TABLE Club
DROP TABLE StadiumManager
DROP TABLE Stadium
DROP TABLE SystemUser
--------------------------------------------------
--Part c
GO
CREATE PROCEDURE dropAllProceduresFunctionsViews AS
DROP PROCEDURE createAllTables
DROP PROCEDURE dropAllTables
DROP PROCEDURE clearAllTables
DROP PROCEDURE addAssociationManager
DROP PROCEDURE addNewMatch
DROP PROCEDURE deleteMatch
DROP PROCEDURE deleteMatchesOnStadium
DROP PROCEDURE addClub
DROP PROCEDURE AddTicket
DROP PROCEDURE deleteClub
DROP PROCEDURE addStadium
DROP PROCEDURE deleteStadium
DROP PROCEDURE blockFan
DROP PROCEDURE unblockFan;
DROP PROCEDURE addRepresentative
DROP PROCEDURE addHostRequest
DROP PROCEDURE addStadiumManager
DROP PROCEDURE acceptRequest
DROP PROCEDURE RejectRequest
DROP PROCEDURE addFan
DROP PROCEDURE purchaseTicket
DROP PROCEDURE updateMatchHost
DROP VIEW allAssocManagers
DROP VIEW allClubRepresentatives
DROP VIEW allStadiumManagers
DROP VIEW allFans
DROP VIEW allMatches
DROP VIEW allTickets
DROP VIEW allCLubs
DROP VIEW allStadiums
DROP VIEW allRequests
DROP VIEW clubsWithNoMatches
DROP VIEW matchesPerTeam
DROP VIEW clubsNeverMatched
DROP FUNCTION viewAvailableStadiumsOn
DROP FUNCTION allUnassignedMatches
DROP FUNCTION allPendingRequests
DROP FUNCTION upcomingMatchesOfClub
DROP FUNCTION availableMatchesToAttend
DROP FUNCTION clubsNeverPlayed
DROP FUNCTION matchWithHighestAttendance
DROP FUNCTION matchesRankedByAttendance
DROP FUNCTION requestsFromClub
--------------------------------------------------
--Part d
GO
CREATE PROCEDURE clearAllTables AS

TRUNCATE TABLE SystemAdmin;
TRUNCATE TABLE Ticket_Buying_Transactions;
TRUNCATE TABLE SportAssociationManager;
TRUNCATE TABLE HostRequest;
TRUNCATE TABLE Ticket;
-- Cannot truncate : ( 
TRUNCATE TABLE Match;
TRUNCATE TABLE Fan;
TRUNCATE TABLE ClubRepresentative;
TRUNCATE TABLE Club;
TRUNCATE TABLE StadiumManager;
TRUNCATE TABLE Stadium;
TRUNCATE TABLE SystemUser;
--------------------------------------------------
--2.2 Basic Data Retrieval
--Part a
GO
CREATE VIEW allAssocManagers AS
SELECT sam.username,su.password,sam.name
FROM SportAssociationManager sam INNER JOIN SystemUser su
ON sam.username =su.username

--Part b

GO
CREATE VIEW allClubRepresentatives AS
SELECT CR.username,su.password,CR.name,C.name AS Club 
FROM Club C INNER JOIN SystemUser su  ON C.username =su.username
INNER JOIN ClubRepresentative CR ON C.id = CR.club_id;

--Part c

GO
CREATE VIEW allStadiumManagers AS
SELECT SM.Username, su.password ,SM.name,S.name AS Stadium
FROM Stadium S INNER JOIN SystemUser su  ON S.username =su.username INNER JOIN StadiumManager SM ON S.id = SM.stadium_id;

--Part d

GO
CREATE VIEW allFans AS
SELECT F.username,su.password,F.name, F.national_id, F.birthdate, F.status
FROM Fan F INNER JOIN SystemUser su  ON F.username =su.username

--Part e

GO
CREATE VIEW allMatches AS
SELECT H.name AS Club_1, G.name AS Club_2, H.name AS Host, M.start_time
FROM Club H 
INNER JOIN Match M
ON H.id = M.host_id
INNER JOIN Club G
ON M.guest_id = G.ID

--Part f

GO
CREATE VIEW allTickets AS
SELECT H.name AS Club_1, G.name AS Club_2, S.name AS Staduim, M.start_time
FROM Ticket T 
INNER JOIN Match M
ON T.match_id = M.ID
INNER JOIN Club H
ON H.id = M.host_id
INNER JOIN Club G
ON G.id = M.guest_id
INNER JOIN Stadium S
ON S.id = M.stadium_id

--Part g

GO
CREATE VIEW allClubs AS
SELECT name,location
FROM Club

--Part h

GO
CREATE VIEW allStadiums AS
SELECT name,location,capacity,status
FROM Stadium

--part i
GO
CREATE VIEW allRequests AS
SELECT cr.username AS ClubRepresentative_username,s.name AS StadiumManager,s.username AS StadiumManager_username, h.status
FROM HostRequest h
INNER JOIN StadiumManager s
ON h.stadium_manager_id = s.ID
INNER JOIN
ClubRepresentative cr
ON h.club_representative_id = cr.ID


-- 2.3 part (iii)
GO
CREATE VIEW clubsWithNoMatches AS
SELECT name 
FROM Club 
EXCEPT (
		SELECT * 
		FROM Club 
		INNER JOIN Match
		ON Club.id = Match.host_id
		
		UNION

		SELECT *
		FROM Club
		INNER JOIN Match
		ON Club.id = Match.guest_id
		)



-------------------------------------------------
--2.3  All Other Requirements 

------------------------------ START OF OMAR'S PART ----------------------------------------

--- Stored Procedures (Parts (i) - (xiii)) ---

-- (i)
GO
CREATE PROCEDURE addAssociationManager (@name VARCHAR(20), @username VARCHAR(20), @password VARCHAR(20)) AS
	INSERT INTO SportAssociationManager (name, username, password) VALUES (@name, @username, @password)


-- (ii)
GO
CREATE PROCEDURE addNewMatch (@hostClubName VARCHAR(20), @guestClubName VARCHAR(20), @startTime DATETIME, @endTime DATETIME) AS
	DECLARE @hostID INT, @guestID INT

	SELECT @hostID = id
	FROM Club 
	WHERE name = @hostClubName
	

	SELECT @guestID = id
	FROM Club
	WHERE name = @guestClubName
	

	INSERT INTO Match (host_id, guest_id, start_time, end_time) VALUES (@hostID, @guestID, @startTime, @endTime) 


-- (iv) [Part (iii) is a view. You can find it with the views above
GO
CREATE PROCEDURE deleteMatch (@hostClubName VARCHAR(20), @guestClubName VARCHAR(20)) AS
	DECLARE @hostID INT, @guestID INT, @matchID INT

	SELECT @hostID = id
	FROM Club
	WHERE name = @hostClubName
	

	SELECT @guestID = id
	FROM Club
	WHERE name = @guestClubName
	

	DELETE FROM Match 
	WHERE host_id = @hostID AND guest_id = @guestID


	-- Delete the match's tickets
	SELECT @matchID = id
	FROM Match 
	WHERE host_id = @hostID AND guest_id = @guestID 


	DELETE FROM Ticket 
	WHERE match_id = @matchID 

-- (v)
GO
CREATE PROCEDURE deleteMatchesOnStadium (@stadiumName VARCHAR(20)) AS
	DECLARE @stadiumID INT, @matchID INT, @currentDate DATETIME
	SET @currentDate = GETDATE();

	SELECT @stadiumID = id
	FROM Stadium
	WHERE id = @stadiumID


	DELETE FROM Match 
	WHERE stadium_id = @stadiumID AND start_time < @currentDate

	-- Delete the match's tickets
	SELECT @matchID = id
	FROM Match 
	WHERE stadium_id = @stadiumID AND start_time < @currentDate


	DELETE FROM Ticket 
	WHERE match_id = @matchID 

-- (vi)
GO
CREATE PROCEDURE addClub (@clubName VARCHAR(20), @clubLocation VARCHAR(20)) AS
	INSERT INTO Club (name, location) VALUES (@clubName, @clubLocation)


-- (vii)
GO
CREATE PROCEDURE addTicket (@hostClubName VARCHAR(20), @guestClubName VARCHAR(20), @startTime DATETIME) AS
	DECLARE @hostClubID INT, @guestClubID INT, @matchID INT

	SELECT @hostClubID = id
	FROM Club
	WHERE name = @hostClubName

	SELECT @guestClubID = id
	FROM Club
	WHERE name = @guestClubName

	SELECT @matchID = id
	FROM Match
	WHERE host_id = @hostClubID AND guest_id = @competingClubID AND start_time = @startTime


	INSERT INTO Ticket VALUES (1, @matchID)



-- (viii)
GO
CREATE PROCEDURE deleteClub (@clubName VARCHAR(20)) AS
	DELETE FROM Club 
	WHERE name = @clubName
	

-- (ix)
GO
CREATE PROCEDURE addStadium (@stadiumName VARCHAR(20), @stadiumLocation VARCHAR(20), @stadiumCapacity VARCHAR(20)) AS
	INSERT INTO Stadium VALUES (@stadiumName, @stadiumLocation, 1, @stadiumCapacity)


-- (x)
GO
CREATE PROCEDURE deleteStadium (@stadiumName VARCHAR(20)) AS
	DELETE FROM Stadium WHERE name = @stadiumName

------------------------------- END OF OMAR'S PART ------------------------------------------------

-------------------------------malek part
-- (XXi)	
go
create procedure addFan (@name VARCHAR(20),@username VARCHAR(20),@password VARCHAR(20),@national_id VARCHAR(20),@birth_date datetime,@address VARCHAR(20),@phone_number int) as	
	--insert into SystemUser values
	insert into SystemUser values(@username,@password)
	insert into Fan  values(@national_id,@username,@name,@phone_number,@birth_date,@address,1);
go	
--exec addFan 'mlek','Luka','pass123','13','1-10-2002','here','1012'


-- (XXII) 
go
CREATE FUNCTION upcomingMatchesOfClub (@club_name varchar(20))
	returns @table table(club_name varchar(20),
						 competing_club_name varchar(20),
						 starting_time datetime,
						  stadium varchar(20))
	as
		begin
			insert into @table
			select  C1.name club_name, C2.name competing_club_name, Match.start_time starting_time, stadium.name stadium from  match,club C1,club C2,Stadium
			where match.host_id=C1.id and match.guest_id=C2.id and Match.stadium_id=Stadium.id and (@club_name like C1.name or @club_name like C2.name ) and Match.start_time>CURRENT_TIMESTAMP
		return
	end;


--select * from  upcomingMatchesOfClub('malek')

-- (XXIII)
go
CREATE FUNCTION availableMatchesToAttend (@date datetime)
	returns @table table(
		host_club_name	varchar(20),
		 competing_club_name varchar(20),
		  starting_time datetime,
		   stadium varchar(20)
	)
	as
		begin
			insert into @table
			select  C1.name club_name, C2.name competing_club_name, Match.start_time starting_time, stadium.name stadium from  match,club C1,club C2,Stadium
			where match.host_id=C1.id and match.guest_id=C2.id and Match.stadium_id=Stadium.id and  Match.start_time>=@date
					and exists(select T.id from Ticket T
								where T.match_id=match.id and T.status=1)
		return
	end;
go

--select * from  availableMatchesToAttend('1-10-2022')

-- (xxiv)
go

create procedure purchaseTicket (@national_id int,@hosting_club varchar(20),@competing_club varchar(20),@date datetime) as
	declare @hosting_club_id varchar(20);
	declare @competing_club_id varchar(20);
	declare @match_id int;
	declare @ticket_id int;
	declare @state bit;
	select @hosting_club_id = id from Club where name like @hosting_club;
	select @competing_club_id = id from Club where name like @competing_club;
	select @match_id=id from match where @date = start_time and @hosting_club_id = host_id and @competing_club_id = guest_id;
	select @state = status from fan where national_id = @national_id;
	select top 1 @ticket_id = id from Ticket
	where match_id = @match_id and status = 1;
	if @state=1
	begin
	update Ticket
	set status = 0
	where id = @ticket_id;
	insert into Ticket_Buying_Transactions values (@national_id,@ticket_id);
	end
go
--exec purchaseTicket 13,'mohamed','malek','2002-01-10 00:00:00.000'


-- (xxv)
go
create procedure updateMatchHost (@hosting_club VARCHAR(20),@competing_club VARCHAR(20),@date datetime) as
	declare @tmp_host_id int;
	declare @tmp_guest_id int;
	declare @match_id int;
	select  @tmp_host_id = id from club
	where name like @hosting_club;
	select  @tmp_guest_id = id from club
	where name like @competing_club;
	select @match_id=id from Match
	where host_id=@tmp_host_id and guest_id =@tmp_guest_id and start_time = @date;
	update match
	set host_id=@tmp_guest_id,guest_id=@tmp_host_id
	where id = @match_id

--exec updateMatchHost 'mohamed','malek','1-11-2023'

go

-- (XXVi)
create view matchesPerTeam as
 select C3.name , COUNT(C3.id) number_of_matches from (select Match.host_id,Match.guest_id,Match.end_time from club C1,club C2,Match
	where Match.host_id=C1.id and Match.guest_id = C2.id) table1 , Club C3
	where (C3.id = table1.host_id or C3.id = table1.guest_id) and CURRENT_TIMESTAMP>table1.end_time
	group by C3.name
--select * from matchesPerTeam
go
-- (XXVII)
create view clubsNeverMatched as
	select C1.name First_club ,C2.name Second_club 
	from Club C1,Club C2
	where C1.id != C2.id and C1.id>C2.id and 
	C1.name not in 
	(
		select C4.name from Club C3,Club C4,Match
		where Match.host_id=C3.id and Match.guest_id=C4.id and C3.id = C2.id
	)
	and
	C2.name not in
	(
		select C4.name from Club C3,Club C4,Match
		where Match.host_id=C3.id and Match.guest_id=C4.id and C3.id = C1.id
	)
go
select * from clubsNeverMatched

-- (xxviii)							
go
CREATE FUNCTION clubsNeverPlayed (@representing varchar(20))    ---------> NOT TESTED 
	returns @table table(
						club_name varchar(20)
	)
	as
		begin
			insert into @table 
				select name from club cl
				where cl.id not in
				(
				select Match.host_id 
				from (select Club.id from Club, ClubRepresentative
				where Club.id=ClubRepresentative.club_id and @representing like ClubRepresentative.name) t1 , Match
				where Match.host_id != t1.id and Match.guest_id = t1.id and CURRENT_TIMESTAMP>=Match.end_time
			union
				select Match.guest_id 
				from (select Club.id from Club, ClubRepresentative
				where Club.id=ClubRepresentative.club_id and @representing like ClubRepresentative.name) t1 , Match
				where Match.guest_id != t1.id and Match.host_id = t1.id and CURRENT_TIMESTAMP>=Match.end_time				
				) 
				and cl.id not in (select Club.id from Club, ClubRepresentative
				where Club.id=ClubRepresentative.club_id and @representing = ClubRepresentative.name)
		return
	end;
go

-- (xxix)
go

CREATE FUNCTION matchWithHighestAttendance ()
	returns @table table(
						host_club varchar(20),
						guest_club varchar(20)
	)
	as
		begin
			insert into @table 
			select top 1 club_name, competing_club_name
			from(
			select  C1.name club_name, C2.name competing_club_name ,count(tick.match_id) cou from  match,club C1,club C2 , Ticket tick
			where match.host_id=C1.id and match.guest_id=C2.id and CURRENT_TIMESTAMP>=Match.end_time and tick.match_id=match.id and tick.status = 0 
			group by C1.name,C2.name
			) t1
			order by cou 
		return
	end;
go
--select * from matchWithHighestAttendance()
-- (xxx) 
go
CREATE FUNCTION matchesRankedByAttendance ()
	returns @table table(host_club varchar(20),
						guest_club varchar(20)
	)
	as
		begin
			insert into @table 
			select club_name, competing_club_name
			from(
			select  C1.name club_name, C2.name competing_club_name ,count(tick.match_id) cou from  match,club C1,club C2 , Ticket tick
			where match.host_id=C1.id and match.guest_id=C2.id and CURRENT_TIMESTAMP>=Match.end_time and tick.match_id=match.id and tick.status = 0 
			group by C1.name,C2.name
			) t1
			order by cou desc
		return
	end;


go
--select * from  matchesRankedByAttendance()

--(XXXi)


CREATE FUNCTION requestsFromClub (@stadium_name varchar(20),@club_name varchar(20))			-- Not Tested
	returns @table table(
		host_club varchar(20),
		guest_club varchar(20)
	)
	as
		begin
			insert into @table 
			select matches.host_club,matches.guest_club from (select Match.id match_id, ClubRepresentative.id ClubRepresentative_id ,C1.name host_club , C2.name guest_club, Stadium.name Stadium_name from match,Club C1 , Club C2, ClubRepresentative , Stadium
							where Match.host_id=C1.id and Match.guest_id = C2.id and ClubRepresentative.club_id = C1.id and Match.stadium_id = Stadium.id) matches inner join HostRequest on HostRequest.match_id=matches.match_id and HostRequest.club_representative_id = matches.ClubRepresentative_id
							where @club_name=matches.host_club and @stadium_name=matches.Stadium_name
		return
	end;


