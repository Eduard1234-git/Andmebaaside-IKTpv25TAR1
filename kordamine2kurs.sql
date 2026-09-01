--connect to DB - (localdb)\MSSQLLocalDB

use kordamineIKT25;

Create TABLE opilane (
opilaneId int Primary Key identity (1,1),
nimi varchar(50),
isikukood char(11) not null,
ryhmId int);

Create TABLE ryhm(
ryhm int Primary Key identity(1,1),
ryhmNimi char(10) Unique,
opilasteArv int);

--tabeli kusutamine
DROP TABLE ...;

--välisvõti --FK
ALTER TABLE opilane ADD FOREIGN KEY (ryhmId) REFERENCES ryhm(ryhmId);

--õiguste määramine varem tehtud kasutajale

GRANT SELECT TO opilaneEduard; --saab vaadata kõik tabeleid
GRANT INSERT ON opilane TO opilaneEduard; --saab ainult tabelisse opilane

DENY DELETE TO opilaneEduard;

--esimine fail
SELECT * FROM opilane, ryhm 
WHERE opilane.ryhmId=ryhm.ryhmId;

DELETE FROM opilane;

INSERT INTO opilane VALUES ('Nikita', '12425435', 1);
