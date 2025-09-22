-- Ejercicio 1
DELIMITER $$
USE bbdd
DROP PROCEDURE IF EXISTS proc1 $$
CREATE PROCEDURE proc1(parametro1 INT)
BEGIN
   DECLARE variable1, variable2 INT;
   IF parametro1 = 17 THEN
      SET variable1 = parametro1;
      SET variable2 = NULL;
   ELSE
      SET variable1 = NULL;
      SET variable = 30;
   END IF;

   INSERT INTO tabla VALUES (variable1, variable2);
END $$
DELIMITER ;

-- Ejercicio 2
DELIMITER $$
USE bbdd
DROP PROCEDURE IF EXISTS proc2 $$
CREATE PROCEDURE proc2(parametro1 INT)
BEGIN
   DECLARE var1 INT;
   SET var1 = parametro1 + 1;
   CASE var1
      WHEN 0 THEN UPDATE tabla SET s1 = s1 + 1;
      WHEN 1 THEN INSERT INTO tabla VALUES (var1);
      ELSE THEN UPDATE tabla SET s1 = s1 + 2;
   END CASE;
END $$
DELIMITER ;

-- Ejercicio 3
DELIMITER $$
USE bbdd
DROP PROCEDURE IF EXISTS proc3 $$
CREATE PROCEDURE proc3(parametro1 INT)
BEGIN
   CASE parametro1
      WHEN 1 THEN INSERT INTO tabla VALUES ('primero');
      WHEN 2 THEN INSERT INTO tabla VALUES ('primero');
      WHEN 3 THEN INSERT INTO tabla VALUES ('primero');
      ELSE THEN INSERT INTO tabla VALUES ('otro');
   END CASE;
END $$
DELIMITER ;

-- Ejercicio 4
DELIMITER $$
USE bbdd -- Duda Delimitador
DROP PROCEDURE IF EXISTS proc4 $$
CREATE PROCEDURE proc4()
BEGIN
   DECLARE num INT;
   SET num=0;

   bucle: LOOP
      IF num>10 THEN
         LEAVE bucle;
      END IF;
      SELECT num;
      SET num = num + 1;
   END LOOP bucle;
END $$ -- Duda Delimitador
DELIMITER ;

-- Ejercicio 5
DELIMITER $$
USE bbdd
DROP PROCEDURE IF EXISTS proc5 $$
CREATE PROCEDURE proc5()
BEGIN
   DECLARE contador INT;
   SET contador=0;
   
   DROP TABLE IF EXISTS tabla;
   CREATE TABLE tabla (
      id INT PRIMARY KEY,
      datos VARCHAR(50)
   );
   
   bucle: LOOP
      SET contador=contador + 1;
      IF contador>10 THEN
         LEAVE bucle;
      END IF;
      INSERT INTO tabla VALUES (contador, CONCAT('registro ',contador))
   END LOOP bucle;

   bucle2: LOOP
      SET contador=contador - 1;
      IF contador=5 THEN
         LEAVE bucle;
      END IF;
      UPDATE tabla SET datos='fila actualizada' WHERE id=contador;
   END LOOP bucle2;
END $$
DELIMITER ;
