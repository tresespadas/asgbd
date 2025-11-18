SET GLOBAL event_scheduler = ON;

DELIMITER $$

-- Trigger
DROP TRIGGER IF EXISTS trigger_eliminador $$
CREATE TRIGGER trigger_eliminador BEFORE DELETE on usuarios
FOR EACH ROW
BEGIN
  -- Creación de la tabla de historicos
  CREATE TABLE IF NOT EXISTS usuarios_historicos (
    id_usuario INT PRIMARY KEY, -- Antiguo DNI
    nombre VARCHAR(20),
    apellidos VARCHAR(30),
    fecha_eliminacion DATE -- Para CURRENT_DATE y no NOW
  );

  INSERT INTO usuarios_historicos
  VALUES (OLD.id_usuario, OLD.nombre, OLD.apellidos, CURRENT_DATE());
END; $$

-- Cursor
DROP PROCEDURE IF EXISTS cursor_eliminador $$
CREATE PROCEDURE cursor_eliminador()
BEGIN
  DECLARE v_id_usuario, v_cont INT; -- He cambiado DNI por id_usuario
  DECLARE lrf BOOL;

  DECLARE cursor_principal CURSOR FOR
  SELECT id_usuario -- Cambiado por el DNI
  FROM usuarios;

  DECLARE cursor_secundario CURSOR FOR
  SELECT id_usuario
  FROM publicaciones
  WHERE id_usuario=v_id_usuario
  AND fecha BETWEEN DATE_SUB(NOW(), INTERVAL 3 MONTH) AND NOW();

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf = 1;

  SET lrf = 0;
  OPEN cursor_principal;
  bucle1: LOOP
    FETCH cursor_principal INTO v_id_usuario;
    IF lrf=1 THEN
      LEAVE bucle1;
    END IF;
    SET v_cont = 0;
    OPEN cursor_secundario;
    bucle2: LOOP
      FETCH cursor_secundario INTO v_id_usuario;
      IF lrf=1 THEN
        LEAVE bucle2;
      END IF;
      SET v_cont = v_cont + 1;
    END LOOP bucle2;
    CLOSE cursor_secundario;
    IF v_cont = 0 THEN
      DELETE FROM usuarios WHERE id_usuario=v_id_usuario;
    END IF;
    SET lrf = 0;
  END LOOP bucle1;
  CLOSE cursor_principal;
END; $$

-- Evento
DROP EVENT IF EXISTS evento_eliminador $$
CREATE EVENT evento_eliminador
ON SCHEDULE EVERY 1 QUARTER
DO
BEGIN
  CALL cursor_eliminador();
END; $$
