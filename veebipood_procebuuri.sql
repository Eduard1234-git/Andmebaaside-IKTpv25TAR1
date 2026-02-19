create database veebipood2;
use veebipood2;
Create table categories(
category_id int primary key identity(1,1),
category_name varchar(20)
);

Create table brands(
brand_id int primary key identity(1,1),
brand_name varchar(20)
);
CREATE TABLE products(
product_id int not null primary key identity(1,1),
product_name varchar(20),
brand_id int,
category_id int,
model_year int,
list_price decimal(7, 2),
FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
INSERT INTO categories(category_name)
VALUES ('riided');
INSERT INTO brands(brand_name)
VALUES ('Apollo');


INSERT INTO products
(product_name, brand_id, category_id,model_year,list_price) 
VALUES ('särk', 1, 1, 2020, 25.20);

select * from products;
SELECT * FROM categories;
SELECT * FROM brands;
Update categories SET category_name='kingad'
WHERE category_id=2;
-- procedure mis lisab INSERT andmeid tabelisse brands
CREATE PROCEDURE lisaBrand
@brand_nimi varchar(30)
as
BEGIN
	INSERT INTO brands(brand_name) VALUES (@brand_nimi);
	SELECT * from brands;
END;
--procedure kutse
EXEC lisaBrand 'Volvoo';

--procedure mis kustutab DELETE tabelist id järgi
CREATE PROCEDURE kustutaBrand
@id int
AS
BEGIN
SELECT * FROM brands;
DELETE FROM brands WHERE brand_id=@id;
SELECT * FROM brands;
END;
--kutse
EXEC kustutaBrand 5;
EXEC kustutaBrand @id=5;

--procedure mis otsib brandinimed 1 tähte järgi 
CREATE PROCEDURE otsing1tahte
@taht char(1)
AS
BEGIN
SELECT * FROM brands WHERE brand_name LIKE @taht+'%';
END;
--kutse
EXEC otsing1tahte 'A';

--procedure mis uuendab UPDATE brandinimi id järgi
CREATE PROCEDURE uuendaBrand
@id int,
@uus_brandNimi varchar(30)
AS
BEGIN
select * from brands;
UPDATE brands SET brand_name=@uus_brandNimi
WHERE brand_id=@id;
select * from brands;
END;
--kutse
EXEC uuendaBrand 2, 'uusApollo';
