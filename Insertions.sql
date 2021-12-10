USE PostGradDB

DELETE FROM PostGradUser;

-- insert Admin
DBCC CHECKIDENT (PostGradUser, RESEED, 0); -- reseeds the entity starting from 1
INSERT INTO PostGradUser VALUES ('Admin email', 'Admin Password');
INSERT INTO Admin VALUES (SCOPE_IDENTITY());

-- insert Students 4 gucian, 3 nongucian, 2 supervisors, 2 examiners, 2 admin
EXEC StudentRegister 'Harry', 'Potter', 'HarryPotterPass', 'Gryffindor', 1, 'HarryPotterPassEmail ', '4 Privet Drive';
EXEC StudentRegister 'Ronald', 'Weasley', 'RonaldWeasleyPass', 'Gryffindor', 1, 'RonaldWeasleyPassEmail', 'The Burrow';
EXEC StudentRegister 'Hermione', 'Granger', 'HermioneGrangerPass', 'Gryffindor', 1, 'HermioneGrangerEmail', 'Hampstead Garden Suburb';
EXEC StudentRegister 'Neville ', 'Longbottom ', 'NevilleLongbottomPass', 'Gryffindor', 1, 'NevilleLongbottomEmail', 'The Leaky Cauldron';

EXEC StudentRegister 'Draco', 'Malfoy', 'DracoMalfoyPass', 'Slytherin', 0, 'DracoMalfoyEmail', ' The Malfoy Mansion';
EXEC StudentRegister 'Cedric', 'Diggory', 'CedricDiggoryPass', 'Hufflepuff', 0, 'CedricDiggoryEmail', 'Ottery St Catchpole';
EXEC StudentRegister 'Luna', 'Lovegood ', 'LunaLovegoodPass', 'Ravenclaw', 0, 'LunaLovegoodEmail	', 'The Lovegood House';

EXEC StudentRegister 'stu first_name 1', 'gucian last_name 1', 'gucian password 1', 'gucian faculty 1', 1, 'gucian email 1', 'gucian adrs 1';
EXEC StudentRegister 'stu first_name 1', 'gucian last_name 1', 'gucian password 1', 'gucian faculty 1', 1, 'gucian email 1', 'gucian adrs 1';
EXEC StudentRegister 'stu first_name 1', 'gucian last_name 1', 'gucian password 1', 'gucian faculty 1', 1, 'gucian email 1', 'gucian adrs 1';

EXEC StudentRegister 'stu first_name 1', 'gucian last_name 1', 'gucian password 1', 'gucian faculty 1', 1, 'gucian email 1', 'gucian adrs 1';
EXEC StudentRegister 'stu first_name 1', 'gucian last_name 1', 'gucian password 1', 'gucian faculty 1', 1, 'gucian email 1', 'gucian adrs 1';
EXEC StudentRegister 'stu first_name 1', 'gucian last_name 1', 'gucian password 1', 'gucian faculty 1', 1, 'gucian email 1', 'gucian adrs 1';

-- insert Supervisors
EXEC SupervisorRegister 'Super firstname 1', 'Super lastname 1', 'Super password 1', 'Super faculty 1', 'Super email 1';

-- insert Thesis
INSERT INTO Thesis(	field, type, title, startDate, endDate, grade, noExtension) 	
VALUES ('thesis field 1', 'type 1', 'title 1', '2020-01-01', '2021-01-01', 4.0, 1);
INSERT INTO Thesis(	field, type, title, startDate, endDate, grade, noExtension) 	
VALUES ('thesis field 2', 'type 2', 'title 2', '2020-01-01', '2021-01-01', 4.0, 1);

-- insert Thesis payment
DECLARE @SuccessOut BIT
EXEC AdminIssueThesisPayment @ThesisSerialNo = 1, @amount = 1000, @noOfInstallments = 4, @fundPercentage = 10, @Success = @SuccessOut OUTPUT
PRINT @SuccessOut

-- link thesis studnet and supervisor
INSERT INTO GUCianStudentRegisterThesis VALUES (1,2,1)

-- inset publication and link to thesis
INSERT INTO Publication VALUES('PUB title 1', '2020-02-02', 'PUB place 1', 1, 'PUB host 1')
INSERT INTO ThesisHasPublication VALUES (1,1);
INSERT INTO Publication VALUES('PUB title 2', '2020-02-02', 'PUB place 2', 0, 'PUB host 2')
INSERT INTO ThesisHasPublication VALUES (1,2);
INSERT INTO Publication VALUES('PUB title 3', '2020-02-02', 'PUB place 3', 1, 'PUB host 3')
INSERT INTO ThesisHasPublication VALUES (2,3);
INSERT INTO Publication VALUES('PUB title 4', '2020-02-02', 'PUB place 4', 1, 'PUB host 4')
INSERT INTO ThesisHasPublication VALUES (2,4);

-- COURSES
EXEC AddCourse 'CSEN 1', 8, 1000;
EXEC linkCourseStudent 1,3;
EXEC addStudentCourseGrade 1,3,10;
EXEC linkCourseStudent 1,4;
EXEC addStudentCourseGrade 1,4,50;
EXEC linkCourseStudent 1,5;
EXEC addStudentCourseGrade 1,5,100;

EXEC AddCourse 'MATH 1', 6, 2000;
EXEC linkCourseStudent 2,3;
EXEC addStudentCourseGrade 2,3,15;
EXEC linkCourseStudent 2,4;
EXEC addStudentCourseGrade 2,4,55;