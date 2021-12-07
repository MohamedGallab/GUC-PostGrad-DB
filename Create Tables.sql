CREATE DATABASE PostGradDB;

GO

USE PostGradDB;

-- Yousef Entities

CREATE TABLE Student(
	id INT identity, 
	firstname VARCHAR(20),
	lastname VARCHAR(20),
	email VARCHAR(50),
	password VARCHAR(30),
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
	password VARCHAR(30),
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
	password VARCHAR(30),
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
	PRIMARY KEY(ID, PHONE),
	FOREIGN KEY(id) REFERENCES GucianStudent ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE NonGUCStudentPhoneNumber(
	id INT,
	phone VARCHAR(20),
	PRIMARY KEY(ID, PHONE),
	FOREIGN KEY(id) REFERENCES NonGucianStudent ON DELETE CASCADE ON UPDATE CASCADE
);

-- Wael Entities

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
	password VARCHAR(20),
	email VARCHAR(50),
	faculty VARCHAR(20),
	address VARCHAR(10),
	PRIMARY KEY(id)
);

CREATE TABLE Payment(
	id INT IDENTITY,
	amount DECIMAL,
	no_installments INT,
	fundPercentage DECIMAL,
	PRIMARY KEY(id)
);

CREATE TABLE Thesis(
	serialNumber INT IDENTITY,
	field VARCHAR(20),
	type VARCHAR(10),
	title VARCHAR(50),
	startDate DATE,
	endDate DATE,
	defenseDate DATE,
	years INT,
	grade DECIMAL(4,2),
	payment_id INT,
	noExtension INT,
	PRIMARY KEY(serialNumber),
	FOREIGN KEY(payment_id) REFERENCES Payment
);

-- Wagdy Entities

CREATE TABLE Publication(
	id INT IDENTITY,
	title VARCHAR(50),
	pubDate DATE,
	place VARCHAR(50),
	accepted BIT,
	host VARCHAR(50),
	PRIMARY KEY(id)
);


CREATE TABLE Examiner(
	id INT IDENTITY,
	name VARCHAR(20),
	email VARCHAR(50),
	password VARCHAR(20),
	fieldOfWork VARCHAR(20),
	isNational BIT,
	PRIMARY KEY(id)
);

CREATE TABLE Defense(
	serialNumber INT,
	date DATETIME,
	location VARCHAR(15),
	grade DECIMAL,
	PRIMARY KEY(serialNumber,date),
	FOREIGN KEY(serialNumber) REFERENCES Thesis ON DELETE CASCADE ON UPDATE CASCADE
);

-- Mahmoud Entities

CREATE TABLE GUCianProgressReport(
	sid INT,
	no INT IDENTITY,
	date DATE,
	eval VARCHAR(50), --evaluation type is unclear idk if it's numeric or a comment or wtf i
	state DECIMAL(5,2),
	thesisSerialNumber INT,
	supid INT,

	PRIMARY KEY(sid,no),

	FOREIGN KEY(supid) REFERENCES Supervisor,
	FOREIGN KEY(thesisSerialNumber) REFERENCES Thesis,
	FOREIGN KEY(sid) REFERENCES GucianStudent
);

CREATE TABLE NonGUCianProgressReport(
	sid INT,
	no INT IDENTITY,
	date DATE,
	eval VARCHAR(50), --evaluation type is unclear idk if it's numeric or a comment or wtf i
	state DECIMAL(5,2),
	thesisSerialNumber INT,
	supid INT,

	PRIMARY KEY(sid,no),

	FOREIGN KEY(supid) REFERENCES Supervisor,
	FOREIGN KEY(thesisSerialNumber) REFERENCES Thesis,
	FOREIGN KEY(sid) REFERENCES NonGucianStudent
);

CREATE TABLE Installment(
	date DATETIME,
	paymentId INT,
	amount DECIMAL(7,2),
	done BIT,

	PRIMARY KEY(date,paymentId),

	FOREIGN KEY(paymentId) REFERENCES Payment
);

-- Moataz Relations

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
	date DATE,
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