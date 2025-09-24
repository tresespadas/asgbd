DELIMITER $$
USE motorblog $$
DROP PROCEDURE IF EXITSTS doble_bucle $$
CREATE PROCEDURE doble_bucle()
BEGIN
   DECLARE v_id_autor, v_contador INT;
   DECLARE lrf BOOL;
      
   DECLARE cursor_principal CURSOR FOR
   SELECT id_autor
   FROM autores;

   DECLARE cursor_secundario CURSOR FOR
   SELECT autor_id
   FROM noticias WHERE autor_id=v_id_autor;

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf=1;

   SET lrf=0, v_contador=0;
   OPEN cursor_principal
   bucle1: LOOP
     FETCH cursor_principal INTO v_id_autor;
      IF lrf=1 THEN
         LEAVE bucle1;
      END IF;
      OPEN cursor_secundario
      bucle2: LOOP
         FETCH cursor_secundario INTO v_id_autor;
         IF lrf=1 THEN
            LEAVE bucle2;
         END IF;
         SET v_contador = v_contador + 1;
         END IF;
      END LOOP bucle2;
      CLOSE cursor_secundario;
      SELECT CONCAT("El autor con id ",v_id_autor," tiene ",v_contador," noticias.");
      SET lrf=0, v_contador=0;
   END LOOP bucle1;
   CLOSE cursor_principal;
END;$$
DELIMITER ;



