USE PostGradDB

DELETE FROM PostGradUser;

-- insert Admin
DBCC CHECKIDENT (PostGradUser, RESEED, 0); -- reseeds the entity starting from 1
INSERT INTO PostGradUser VALUES ('Admin email', 'Admin Password');
INSERT INTO Admin VALUES (SCOPE_IDENTITY());

-- insert Students
EXEC StudentRegister 'gucian first_name 1', 'gucian last_name 1', 'gucian password 1', 'gucian faculty 1', 1, 'gucian email 1', 'gucian adrs 1';
EXEC StudentRegister 'NONguc first_name 1', 'NONguc last_name 1', 'NONguc password 1', 'NONguc faculty 1', 0, 'NONguc email 1', 'NONguc adrs 1';
EXEC StudentRegister 'NONguc first_name 2', 'NONguc last_name 2', 'NONguc password 2', 'NONguc faculty 2', 0, 'NONguc email 2', 'NONguc adrs 2';
EXEC StudentRegister 'NONguc first_name 3', 'NONguc last_name 3', 'NONguc password 3', 'NONguc faculty 3', 0, 'NONguc email 3', 'NONguc adrs 3';

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