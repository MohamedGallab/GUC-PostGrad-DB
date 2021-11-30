CREATE DATABASE PostGradDB;

GO

USE PostGradDB;

-- Yousef
-- Entities
CREATE TABLE Student(
	id INT identity, 
	firstname VARCHAR(20),
	lastname VARCHAR(20),
	email VARCHAR(50),
	type VARCHAR(20), 
	faculty VARCHAR(20),
	address VARCHAR(20),
	gpa DECIMAL(4,2),
	PRIMARY KEY(id)
);

CREATE TABLE GucianStudent(
	id INT identity, 
	firstname VARCHAR(20),
	lastname VARCHAR(20),
	email VARCHAR(50),
	type VARCHAR(20), 
	faculty VARCHAR(20),
	address VARCHAR(20),
	gpa DECIMAL(4,2),
	underGradId INT,
	PRIMARY KEY(id)
);

CREATE TABLE NonGucianStudent(
	id INT identity, 
	firstname VARCHAR(20),
	lastname VARCHAR(20),
	email VARCHAR(50),
	type VARCHAR(20), 
	faculty VARCHAR(20),
	address VARCHAR(20),
	gpa DECIMAL(4,2),
	underGradId INT,
	PRIMARY KEY(id)
);

CREATE TABLE GUCStudentPhoneNumber(
	id INT,
	phone VARCHAR(20),
	FOREIGN KEY(id) REFERENCES GucianStudent ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE NonGUCStudentPhoneNumber(
	id INT,
	phone VARCHAR(20),
	FOREIGN KEY(id) REFERENCES NonGucianStudent ON DELETE CASCADE ON UPDATE CASCADE
);

-- Relations

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
	grade DECIMAL(4,2),
	PRIMARY KEY(sid, cid),
	FOREIGN KEY(sid) REFERENCES NonGucianStudent ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE
);

-- Wael
-- Entities
CREATE TABLE Course(
	id INT IDENTITY, 
	fees DECIMAL(8,2),
	creditHours INT,
	courseCode VARCHAR(10),
	PRIMARY KEY(id)
);


CREATE TABLE Supervisor(
	id INT IDENTITY, 
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	email VARCHAR(50),
	faculty VARCHAR(20),
	--address VARCHAR(10)
	PRIMARY KEY(id)
);

CREATE TABLE Thesis(
	serialNumber INT,
	field VARCHAR(20),
	type VARCHAR(10),
	title VARCHAR(50),
	startDate DATE,
	endDate DATE,
	defenseDate DATE,
	years INT,
	grade DECIMAL(4,2)
	PRIMARY KEY(serialNumber)
);

-- Relations

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

-- Wagdy
-- Entities

-- Relations

-- Mahmoud
-- Entities

-- Relations
