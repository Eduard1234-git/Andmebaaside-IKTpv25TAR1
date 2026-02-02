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
SELECT * FROM opilane;
