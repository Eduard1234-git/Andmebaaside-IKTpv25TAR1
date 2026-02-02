CREATE DATABASE kotkasSQL; 
use kotkasSQL;
--Ttabeli loomine
CREATE TABLE opilane(
opilaneID int PRIMARY KEY identity(1,1),
eesnimi varchar(25),
perenimi varchar(30) NOT null,
synniaeg date,
aadress TEXT, 
kas_opib bit );
--kuva tabeli, *-kõik väljad
SELECT * FROM opilane;

--tabeli kustutamine
DROP TABLE opilane;

--andmete lisamine tableisse opilane
INSERT INTO opilane(eesnimi, perenimi, synniaeg, kas_opib)
VALUES ('Nikita', 'Petrov', '2023-12-12', 0),
('Nikita', 'Alekseev', '2019-11-12', 0),
('Nikita', 'NIlitiov', '2021-12-13', 10);
Select * from opilane;

--muudame tabeli ja lisame piirangu UNIQUE
ALTER TABLE oplinae Alter column perenimi varchar (30) UNIQUE;
