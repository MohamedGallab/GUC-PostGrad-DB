create database PostGrad;
-- Yousef
create table Student(
	id int identity, 
	firstname varchar(20),
	lastname varchar(20),
	email varchar(50),
	type varchar(20), 
	faculty varchar(20),
	address varchar(20),
	gpa decimal(4,2),
	PRIMARY KEY(id)
);

create table GucianStudent(
	id int identity, 
	firstname varchar(20),
	lastname varchar(20),
	email varchar(50),
	type varchar(20), 
	faculty varchar(20),
	address varchar(20),
	gpa decimal(4,2),
	underGradId int,
	PRIMARY KEY(id)
);

create table NonGucianStudent(
	id int identity, 
	firstname varchar(20),
	lastname varchar(20),
	email varchar(50),
	type varchar(20), 
	faculty varchar(20),
	address varchar(20),
	gpa decimal(4,2),
	underGradId int,
	PRIMARY KEY(id)
);

create table GUCStudentPhoneNumber(
	id int,
	phone varchar(20),
	FOREIGN KEY(id) REFERENCES GucianStudent
);

create table NonGUCStudentPhoneNumber(
	id int,
	phone varchar(20),
	FOREIGN KEY(id) REFERENCES NonGucianStudent
);

create table NonGucianStudentPayForCourse(
	sid int, 
	paymentNo int,
	cid int,
	PRIMARY KEY(sid, paymentNo, cid),
	FOREIGN KEY(sid) REFERENCES NonGucianStudent,
	FOREIGN KEY(paymentNo) REFERENCES Payment,
	FOREIGN KEY(cid) REFERENCES Course
);

create table NonGucianStudentTakeCourse(
	sid int, 
	cid int, 
	grade decimal(4,2),
	PRIMARY KEY(sid, cid),
	FOREIGN KEY(sid) REFERENCES NonGucianStudent,
	FOREIGN KEY(cid) REFERENCES Course
);

-- Wael

-- Wagdy

-- Mahmoud