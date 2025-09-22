-- 1.
DELIMITER $$
USE bbdd $$
DROP FUNCTION IF EXISTS divisible $$
CREATE FUNCTION divisible(num1 INT, num2 INT)
RETURNS BOOLEAN
BEGIN
   DECLARE resultado BOOLEAN;
   IF (num1 % num2 = 0) THEN
      SET resultad = 1;
   ELSE 
      SET resultado = 0;
   END IF;
   RETURN resultado;
END $$

DELIMITER ;

-- 2.
DELIMITER $$
USE bd_repaso $$
DROP PROCEDURE IF EXISTS dia_semana $$
CREATE PROCEDURE dia_semana(num INT)
BEGIN
  CASE num
    WHEN 1 THEN SELECT 'domingo';
    WHEN 2 THEN SELECT 'lunes';
    WHEN 3 THEN SELECT 'martes';
    WHEN 4 THEN SELECT 'miércoles';
    WHEN 5 THEN SELECT 'jueves';
    WHEN 6 THEN SELECT 'viernes';
    WHEN 7 THEN SELECT 'sábado';
  END CASE;
END $$

DELIMITER ;

-- 3.
DELIMITER $$
USE bd_repaso $$
DROP FUNCTION IF EXISTS mayor_de_tres $$
CREATE FUNCTION mayor_de_tres(num1 INT, num2 INT, num3 INT) 
RETURNS INT
BEGIN
  DECLARE resultado INT;
  IF (num1 > num2 && num1 > num3) THEN
    SET resultado = num1;
  ELSEIF (num3 > num2 && num3 > num1) THEN
    SET resultado = num3;
  ELSE
    SET resultado = num2;
  END IF;
  RETURN resultado;
END $$

DELIMITER ;

-- 4.
DELIMITER $$
USE bd_repaso $$
DROP FUNCTION IF EXISTS cuadrado $$
CREATE FUNCTION cuadrado(num INT)
RETURNS INT
BEGIN
  DECLARE resultado INT;
  SET resultado = num * num;
  RETURN resultado;
END $$

DELIMITER ;

-- 5.
DELIMITER $$
USE bd_repaso $$
DROP PROCEDURE IF EXISTS insertar_persona $$
CREATE PROCEDURE insertar_persona(nombre VARCHAR(20), edad INT)
BEGIN
  IF edad > 18 THEN
    INSERT INTO adultos VALUES (id, nombre, edad);
  ELSEIF edad < 18 && edad > 0 THEN
    INSERT INTO peques VALUES (id, nombre, edad);
  ELSE
    SELECT CONCAT(edad,' no es un edad válida') AS 'Error';
  END IF;
END $$

DELIMITER ;
