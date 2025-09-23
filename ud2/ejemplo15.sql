DELIMITER $$
USE bbdd $$
DROP PROCEDURE IF EXISTS ejemplo15 $$
CREATE PROCEDURE ejemplo15()
BEGIN
   DECLARE tmp VARCHAR(20);
   DECLARE lrf BOOL;
   DECLARE nn INT;

   DECLARE cursor1 CURSOR FOR
   SELECT titulo
   FROM noticias;

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf=1;

   SET lrf=0,nn=0;
   OPEN cursor1;
   REPEAT LOOP
      FETCH cursor1 INTO tmp;
      END IF;
      SET nn=nn+1;
   UNTIL lrf=1;
   END LOOP;
   CLOSE cursor1;

   SELECT nn;
END; $$
DELIMITER ;
