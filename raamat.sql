CREATE DATABASE raamatKotkas;
use raamatKotkas;
CREATE TABLE zanr(
zanrID int PRIMARY KEY identity(1,1),
zanrNimetus varchar (50) not null,
kirjeldus TEXT);
Select * from zanr;
--tabeli täitmine
INSERT INTO zanr (zanrNimetus, kirjeldus)
VALUES ('rommantika', 'see on romaantika zanr');
INSERT INTO zanr(zanrNimetus, kirjeldus)
VALUES('detektiiv', 'detektiiv zanr keskendub kangelastele'),
('komöödia', 'lõbus meelelahutys'),
('tragöödia', 'kurb zanr'),
('röövel', 'ekshen zanr');

--tabel autor

CREATE TABLE autor(
autorID int PRIMARY KEY identity(1,1),
eesenimi varchar(50),
pernimi varchar (50) not null,
synniaasta int check(synniaasta > 1900),
elukoht varchar (30)
);
select * from autor;
INSERT INTO autor(eesenimi, pernimi, synniaasta)
VALUES('Leelo', 'Kivirähk', 1956),
('Stiven', 'King', 1971);

--tabeli uuendamine
UPDATE autor SET elukoht ='Tallinn';

--kustutamine tebelist
DELETE FROM zanr Where zanrID=5;

--tebale raamat
CREATE TABLE raamat(
raamtID int PRIMARY KEY identity(1,1),
raamatNimetus varchar(100) UNIQUE,
lk int,
autorID int
FOREIGN KEY (autorID) REFERENCES autor(autorID),
zanrID int, 
FOREIGN KEY (zanrID) REFERENCES zanr(zanrID),
);
-- drop tabel raamat;
select *from raamat;
select * from zanr;
select * from autor;

INSERT INTO raamat (raamatNImetus, lk, autorID, zanrID)
VALUES ('Oskarja asjad', 200, 1, 4),
('IT', 400, 3, 2);

CREATE TABLE trykikoda(
trykikodaID int PRIMARY KEY identity(1,1),
trykikodaNimetus varchar(100) UNIQUE,
trykikodaAadres varchar (50) not null,
FOREIGN KEY (trykikodaID) REFERENCES autor(autorID)
);
