DELIMITER $$
USE motorblog $$
DROP PROCEDURE IF EXISTS mayor_autor_noviembre $$
CREATE PROCEDURE mayor_autor_noviembre()
BEGIN
   DECLARE v_id_autor, v_contador, v_contador_max, v_id_autor_max INT;
   DECLARE lrf BOOL;

   DECLARE cursor_principal CURSOR FOR
   SELECT id_autor -- Se puede añador login para luego sacar el nombre
   FROM autores;

   DECLARE cursor_secundario CURSOR FOR
   SELECT autor_id
   FROM noticias WHERE MONTH(fecha_pub)=11 AND autor_id=id_autor;

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf=1;

   SET lrf=0, v_contador=0, v_contador_max=0;
   OPEN cursor_principal;
   bucle1: LOOP
      FETCH cursor_principal INTO v_id_autor; -- Se puede añadir vlogin para luego sacar el nombre
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
      END LOOP bucle2;
      CLOSE cursor_secundario;
      IF v_contador_max < v_contador THEN
         SET v_contador_max = v_contador;
         SET v_id_autor_max = v_id_autor;
      END IF;
      SET lrf=0, v_contador=0;
   END LOOP bucle1;
   CLOSE cursor_principal;
   SELECT CONCAT("El autor con id ",v_id_autor_max," es el que más noticias tiene en noviembre.");
END;$$
DELIMITER ;

