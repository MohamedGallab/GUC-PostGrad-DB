CREATE DATABASE PostGradDB;

GO

USE PostGradDB;

CREATE TABLE PostGradUser(
	id INT IDENTITY,
	email VARCHAR(50),
	password VARCHAR(20),
	PRIMARY KEY(id)
);

CREATE TABLE Admin(
	id INT,
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES PostGradUser ON DELETE CASCADE ON UPDATE CASCADE
);

-- Yousef Entities

CREATE TABLE GucianStudent(
	id INT, 
	firstname VARCHAR(20),
	lastname VARCHAR(20),
	type VARCHAR(20), -- type ?
	faculty VARCHAR(20),
	address VARCHAR(50),
	GPA DECIMAL(4,2), -- type ?
	undergradID INT,
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES PostGradUser ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE NonGucianStudent(
	id INT, 
	firstname VARCHAR(20),
	lastname VARCHAR(20),
	type VARCHAR(20), -- type ?
	faculty VARCHAR(20),
	address VARCHAR(50),
	GPA DECIMAL(4,2), -- type ?
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES PostGradUser ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE GUCStudentPhoneNumber(
	id INT,
	phone VARCHAR(20),
	PRIMARY KEY(id, phone),
	FOREIGN KEY(id) REFERENCES GucianStudent ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE NonGUCStudentPhoneNumber(
	id INT,
	phone VARCHAR(20),
	PRIMARY KEY(id, phone),
	FOREIGN KEY(id) REFERENCES NonGucianStudent ON DELETE CASCADE ON UPDATE CASCADE
);

-- Wael Entities

CREATE TABLE Course(
	id INT IDENTITY, 
	fees DECIMAL(8,2), -- type ?
	creditHours INT,
	courseCode VARCHAR(10), -- code instead ?
	PRIMARY KEY(id)
);


CREATE TABLE Supervisor(
	id INT, 
	-- name instead of first + last ?
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	faculty VARCHAR(20),
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES PostGradUser ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Payment(
	id INT IDENTITY,
	amount DECIMAL(8,2), -- type ?
	no_installments INT,
	fundPercentage DECIMAL(5,2),
	PRIMARY KEY(id)
);

CREATE TABLE Thesis(
	serialNumber INT IDENTITY,
	field VARCHAR(20), -- type ?
	type VARCHAR(10), -- type ?
	title VARCHAR(50), -- type ?
	startDate DATE,
	endDate DATE,
	defenseDate DATETIME,
	years AS (YEAR(endDate) - YEAR(startDate)),
	grade DECIMAL(5,2),
	payment_id INT,
	noExtension INT,
	PRIMARY KEY(serialNumber),
	FOREIGN KEY(payment_id) REFERENCES Payment
);

-- Wagdy Entities

CREATE TABLE Publication(
	id INT IDENTITY,
	title VARCHAR(50),
	date DATETIME,
	place VARCHAR(50),
	accepted BIT,
	host VARCHAR(50),
	PRIMARY KEY(id)
);


CREATE TABLE Examiner(
	id INT IDENTITY,
	name VARCHAR(20),
	fieldOfWork VARCHAR(20),
	isNational BIT,
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES PostGradUser ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Defense(
	serialNumber INT,
	date DATETIME,
	location VARCHAR(15),
	grade DECIMAL(5,2), -- type ?
	PRIMARY KEY(serialNumber,date),
	FOREIGN KEY(serialNumber) REFERENCES Thesis ON DELETE CASCADE ON UPDATE CASCADE
);

-- Mahmoud Entities

CREATE TABLE GUCianProgressReport(
	sid INT,
	no INT IDENTITY,
	date DATE,
	eval INT,
	state INT,
	thesisSerialNumber INT,
	supid INT,

	PRIMARY KEY(sid,no),

	FOREIGN KEY(sid) REFERENCES GucianStudent,
	FOREIGN KEY(thesisSerialNumber) REFERENCES Thesis,
	FOREIGN KEY(supid) REFERENCES Supervisor
);

CREATE TABLE NonGUCianProgressReport(
	sid INT,
	no INT IDENTITY,
	date DATE,
	eval INT,
	state INT,
	thesisSerialNumber INT,
	supid INT,

	PRIMARY KEY(sid,no),

	FOREIGN KEY(sid) REFERENCES NonGucianStudent,
	FOREIGN KEY(thesisSerialNumber) REFERENCES Thesis,
	FOREIGN KEY(supid) REFERENCES Supervisor
);

CREATE TABLE Installment(
	date DATE,
	paymentId INT,
	amount DECIMAL(8,2), -- type ?
	done BIT,

	PRIMARY KEY(date,paymentId),

	FOREIGN KEY(paymentId) REFERENCES Payment
);

-- Yousef Relations

CREATE TABLE NonGucianStudentPayForCourse(
	sid INT, 
	paymentNo INT,
	cid INT,
	PRIMARY KEY(sid, paymentNo, cid),
	FOREIGN KEY(sid) REFERENCES NonGucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(paymentNo) REFERENCES Payment ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE NonGucianStudentTakeCourse(
	sid INT, 
	cid INT, 
	grade DECIMAL(5,2), -- type ?
	PRIMARY KEY(sid, cid),
	FOREIGN KEY(sid) REFERENCES NonGucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE
);

-- Wael Relations

CREATE TABLE GUCianStudentRegisterThesis(
	sid INT,
	supid INT,
	serial_no INT,
	PRIMARY KEY(sid, supid, serial_no),
	FOREIGN KEY(sid) REFERENCES GucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(supid) REFERENCES Supervisor ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(serial_no) REFERENCES Thesis ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE NonGUCianStudentRegisterThesis(
	sid INT,
	supid INT,
	serial_no INT,
	PRIMARY KEY(sid, supid, serial_no),
	FOREIGN KEY(sid) REFERENCES NonGucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(supid) REFERENCES Supervisor ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(serial_no) REFERENCES Thesis ON DELETE CASCADE ON UPDATE CASCADE
);

-- Wagdy Relations

CREATE TABLE ExaminerEvaluateDefense(
	date DATETIME,
	serialNo INT,
	examinerId INT,
	comment VARCHAR(300),
	PRIMARY KEY(date,serialNo,examinerId),
	FOREIGN KEY(serialNo,date) REFERENCES Defense ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(examinerId) REFERENCES Examiner ON DELETE CASCADE ON UPDATE CASCADE
);

-- Mahmoud Relations
CREATE TABLE ThesisHasPublication (
	serialNo INT,
	pubid INT,

	FOREIGN KEY(serialNo) REFERENCES Thesis,
	FOREIGN KEY(pubid) REFERENCES Publication,

	PRIMARY KEY(serialNo,pubid)
);