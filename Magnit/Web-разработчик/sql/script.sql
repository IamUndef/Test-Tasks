CREATE DATABASE comments;

USE comments;

CREATE TABLE
  Region (
  id INT(11) NOT NULL AUTO_INCREMENT,
  name VARCHAR(30) NOT NULL COMMENT 'Наименование',
  PRIMARY KEY (id)  
) ENGINE = InnoDB CHARACTER SET utf8 COMMENT = 'Регионы'; 

CREATE TABLE
  City (
  id INT(11) NOT NULL AUTO_INCREMENT,
  region_id INT(11) NOT NULL COMMENT 'Регион',
  name VARCHAR(30) NOT NULL COMMENT 'Наименование',
  PRIMARY KEY (id),
  CONSTRAINT City_region_id FOREIGN KEY (region_id)
  REFERENCES Region (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET utf8 COMMENT = 'Города'; 

CREATE TABLE
  Comment (
  id INT(11) NOT NULL AUTO_INCREMENT,
  lastName VARCHAR(30) NOT NULL COMMENT 'Фамилия',
  firstName VARCHAR(30) NOT NULL COMMENT 'Имя',
  patrName VARCHAR(30) DEFAULT NULL COMMENT 'Отчетсво',
  city_id INT(11) DEFAULT NULL COMMENT 'Город',
  phone VARCHAR(20) DEFAULT NULL COMMENT 'Телефон',
  email VARCHAR(40) DEFAULT NULL COMMENT 'Электронная почта',
  comment TINYTEXT NOT NULL COMMENT 'Комментарий',
  PRIMARY KEY (id),
  CONSTRAINT Comment_city_id FOREIGN KEY (city_id)
  REFERENCES City (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET utf8 COMMENT = 'Комментарии';

INSERT INTO Region (name) VALUES ('Краснодарский край');
INSERT INTO Region (name) VALUES ('Ростовская область');
INSERT INTO Region (name) VALUES ('Ставропольский край');

INSERT INTO City (region_id, name) VALUES ((SELECT id FROM Region WHERE name = 'Краснодарский край' LIMIT 1), 'Краснодар');
INSERT INTO City (region_id, name) VALUES ((SELECT id FROM Region WHERE name = 'Краснодарский край' LIMIT 1), 'Кропоткин');
INSERT INTO City (region_id, name) VALUES ((SELECT id FROM Region WHERE name = 'Краснодарский край' LIMIT 1), 'Славянск');
INSERT INTO City (region_id, name) VALUES ((SELECT id FROM Region WHERE name = 'Ростовская область' LIMIT 1), 'Ростов');
INSERT INTO City (region_id, name) VALUES ((SELECT id FROM Region WHERE name = 'Ростовская область' LIMIT 1), 'Шахты');
INSERT INTO City (region_id, name) VALUES ((SELECT id FROM Region WHERE name = 'Ростовская область' LIMIT 1), 'Батайск');
INSERT INTO City (region_id, name) VALUES ((SELECT id FROM Region WHERE name = 'Ставропольский край' LIMIT 1), 'Ставрополь');
INSERT INTO City (region_id, name) VALUES ((SELECT id FROM Region WHERE name = 'Ставропольский край' LIMIT 1), 'Пятигорск');
INSERT INTO City (region_id, name) VALUES ((SELECT id FROM Region WHERE name = 'Ставропольский край' LIMIT 1), 'Кисловодск');

INSERT INTO Comment (lastName, firstName, patrName, city_id, comment) 
  VALUES ('Фамилия1', 'Имя1', 'Отчество1', (SELECT id FROM City c WHERE name = 'Краснодар' LIMIT 1), 'Комментарий1');
INSERT INTO Comment (lastName, firstName, patrName, city_id, comment) 
  VALUES ('Фамилия2', 'Имя2', 'Отчество2', (SELECT id FROM City c WHERE name = 'Краснодар' LIMIT 1), 'Комментарий2');
INSERT INTO Comment (lastName, firstName, patrName, city_id, comment) 
  VALUES ('Фамилия3', 'Имя3', 'Отчество3', (SELECT id FROM City c WHERE name = 'Краснодар' LIMIT 1), 'Комментарий3');
INSERT INTO Comment (lastName, firstName, patrName, city_id, comment) 
  VALUES ('Фамилия4', 'Имя4', 'Отчество4', (SELECT id FROM City c WHERE name = 'Славянск' LIMIT 1), 'Комментарий4');
INSERT INTO Comment (lastName, firstName, patrName, city_id, comment) 
  VALUES ('Фамилия5', 'Имя5', 'Отчество5', (SELECT id FROM City c WHERE name = 'Славянск' LIMIT 1), 'Комментарий5');
INSERT INTO Comment (lastName, firstName, patrName, city_id, comment) 
  VALUES ('Фамилия6', 'Имя6', 'Отчество6', (SELECT id FROM City c WHERE name = 'Славянск' LIMIT 1), 'Комментарий6');
INSERT INTO Comment (lastName, firstName, patrName, city_id, comment) 
  VALUES ('Фамилия7', 'Имя7', 'Отчество7', (SELECT id FROM City c WHERE name = 'Ростов' LIMIT 1), 'Комментарий7');
INSERT INTO Comment (lastName, firstName, patrName, city_id, comment) 
  VALUES ('Фамилия8', 'Имя8', 'Отчество8', (SELECT id FROM City c WHERE name = 'Ростов' LIMIT 1), 'Комментарий8');
INSERT INTO Comment (lastName, firstName, patrName, city_id, comment) 
  VALUES ('Фамилия9', 'Имя9', 'Отчество9', (SELECT id FROM City c WHERE name = 'Ростов' LIMIT 1), 'Комментарий9');
INSERT INTO Comment (lastName, firstName, patrName, city_id, comment) 
  VALUES ('Фамилия10', 'Имя10', 'Отчество10', (SELECT id FROM City c WHERE name = 'Ростов' LIMIT 1), 'Комментарий10');
INSERT INTO Comment (lastName, firstName, patrName, city_id, comment) 
  VALUES ('Фамилия11', 'Имя11', 'Отчество11', (SELECT id FROM City c WHERE name = 'Ростов' LIMIT 1), 'Комментарий11');
INSERT INTO Comment (lastName, firstName, patrName, email, phone, comment) 
  VALUES ('Фамилия12', 'Имя12', 'Отчество12', 'mail1@mail.com', '(888) 1234567', 'Комментарий12');
INSERT INTO Comment (lastName, firstName, patrName, email, phone, comment)
  VALUES ('Фамилия13', 'Имя13', 'Отчество13', 'mail2@mail.com', '(888) 1234567', 'Комментарий13');