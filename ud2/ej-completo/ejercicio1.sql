DELIMITER $$
CREATE PROCEDURE IF EXISTS cursores()
DROP PROCEDURE IF EXISTS cursores $$
BEGIN
   DECLARE v_dni, v_contador INT;
   DECLARE lrf BOOL;

   DECLARE cursor_principal CURSOR FOR
   SELECT dni
   FROM usuarios;

   DECLARE cursor_secundario CURSOR FOR
   SELECT id_usuario
   FROM publicaciones WHERE id_usuario=v_dni fecha BETWEEN DATE_SUB(now(),INTERVAL 3 month) AND NOW();

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf=1;

   SET lrf=0, v_contador=0;
   OPEN cursor_principal;
   bucle1: LOOP
      FETCH cursor_principal INTO v_dni
      IF lrf=1 THEN
         LEAVE bucle1;
      END IF;
      OPEN cursor_secundario
      SET v_contador=0;
      bucle2: LOOP
         FETCH cursor_secundario INTO v_fecha;
            IF lrf=1 THEN
               LEAVE bucle2;
            END IF;
            SET v_contador = v_contador + 1;
      END LOOP bucle2;
      IF v_contador=0 THEN
         DELETE FROM usuarios WHERE dni=v_dni;
      END IF;
      CLOSE cursor_secundario;
      SET lrf=0;
   END LOOP bucle1;
   CLOSE cursor_principal;
END;$$

CREATE EVENT evento
ON SCHEDULE EVERY 3 MONTH
STARTS YEAR(NOW())
DO
   BEGIN
      CALL cursores;
   END; $$

CREATE TRIGGER trigger BEFORE DELETE ON usuarios
FOR EACH ROW
BEGIN
   INSERT INTO usuarios_historico(dni,nombre,apellidos,fecha) VALUES (OLD.dni, OLD.nombre, OLD.apellidos,CURRENT_DATE());
END; $$

DELIMITER ;
