SET GLOBAL event_scheduler = ON;
USE GIMNASIO;
DELIMITER $$

DROP TRIGGER IF EXISTS tr_alerta $$
CREATE TRIGGER tr_alerta AFTER UPDATE on INSCRIPCIONES
FOR EACH ROW
BEGIN
  INSERT INTO ALERTAS
  SELECT id_socio, nombre, @fecha_ins, telefono, email, CURRENT_DATE()
  FROM SOCIOS
  WHERE id_socio = NEW.id_socio;
END; $$

DROP PROCEDURE IF EXISTS proc_cursores $$
CREATE PROCEDURE proc_cursores()
BEGIN
  DECLARE v_id_socio, v_cont INT;
  DECLARE v_fecha_ins DATE;
  DECLARE lrf BOOL;

  DECLARE cursor_principal CURSOR FOR
  SELECT id_socio, fecha_inscripcion
  FROM INSCRIPCIONES
  WHERE asistencia_pendiente = false; -- Quiero los que no la tienen puesta para ponerla yo

  DECLARE cursor_secundario CURSOR FOR
  SELECT id_socio
  FROM ACTIVIDADES
  WHERE id_socio = v_id_socio
  AND fecha_asistencia = MONTH(NOW()) - INTERVAL 1 MONTH;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf = 1;

  SET lrf=0;
  OPEN cursor_principal;
  bucle1: LOOP
    FETCH cursor_principal INTO v_id_socio, v_fecha_ins;
    IF lrf=1 THEN
    LEAVE bucle1;
    END IF;
    SET v_cont = 0;
    OPEN cursor_secundario;
    bucle2: LOOP
      FETCH cursor_secundario INTO v_id_socio;
      IF lrf=1 THEN
      LEAVE bucle2;
      END IF;
      SET v_cont = v_cont + 1;
      SET @fecha_ins = v_fecha_ins;
    END LOOP bucle2;
    CLOSE cursor_secundario;
  SET lrf = 0;
  IF v_cont = 0 THEN
  UPDATE INSCRIPCIONES SET asistencia_pendiente = true WHERE id_socio =
  v_id_socio;
  END IF;
  END LOOP bucle1;
  CLOSE cursor_principal;
END; $$

DROP EVENT IF EXISTS evento_mensual $$
CREATE EVENT evento_mensual
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
  CALL proc_cursores();
END; $$

DELIMITER ;
