USE PostGradDB

DELETE FROM PostGradUser;

-- insert Admin
DBCC CHECKIDENT (PostGradUser, RESEED, 0); -- reseeds the entity starting from 1
INSERT INTO PostGradUser VALUES ('Admin email', 'Admin Password');
INSERT INTO Admin VALUES (SCOPE_IDENTITY());

-- insert Students
EXEC StudentRegister 'stu first_name 1', 'gucian last_name 1', 'gucian password 1', 'gucian faculty 1', 1, 'gucian email 1', 'gucian adrs 1';

-- insert Supervisors
EXEC SupervisorRegister 'Super firstname 1', 'Supervisor lastname 1', 'Supervisor password 1', 'Supervisor faculty 1', 'Supervisor email 1';