USE PostGradDB

GO

-- 1

-- 2

-- 3

-- a) List all supervisors in the system.
GO
CREATE PROC AdminListSup
AS
	SELECT *
	FROM Supervisor
RETURN
GO

-- b) view the profile of any supervisor that contains all his/her information.
GO
CREATE PROC AdminViewSupervisorProfile
@supId INT
AS
	SELECT *
	FROM Supervisor
	WHERE Supervisor.id = @supId
RETURN
GO

-- c) List all Theses in the system.
GO
CREATE PROC AdminViewAllTheses
AS
	SELECT *
	FROM Thesis
RETURN
GO

-- d) List the number of on going theses.
GO
CREATE PROC AdminViewOnGoingTheses
@thesesCount INT
AS
	SELECT @thesesCount = COUNT(*)
	FROM Thesis
	WHERE Thesis.endDate IS NULL
RETURN
GO

-- e) List all supervisors’ names currently supervising students, theses title, student name.
GO
CREATE PROC AdminViewStudentThesisBySupervisor
AS
	SELECT Supervisor.first_name, Thesis.title, allStudents.firstname
	FROM 
		(
		SELECT * 
		FROM GUCianStudentRegisterThesis 
		INNER JOIN GucianStudent ON GUCianStudentRegisterThesis.sid = GucianStudent.id
		UNION 
		SELECT * 
		FROM NonGUCianStudentRegisterThesis
		INNER JOIN NonGucianStudent ON NonGUCianStudentRegisterThesis.sid = NonGucianStudent.id
		)
		AS allStudents
		INNER JOIN Supervisor ON allStudents.supid = Supervisor.id
		INNER JOIN Thesis ON allStudents.serial_no = Thesis.serialNumber
	WHERE
		endDate IS NULL
RETURN
GO

-- c) List all Theses in the system.
GO
CREATE PROC AdminViewAllTheses
AS
	SELECT *
	FROM Thesis
RETURN
GO

-- c) List all Theses in the system.
GO
CREATE PROC AdminViewAllTheses
AS
	SELECT *
	FROM Thesis
RETURN
GO

-- c) List all Theses in the system.
GO
CREATE PROC AdminViewAllTheses
AS
	SELECT *
	FROM Thesis
RETURN
GO
-- 4

-- 5

-- 6