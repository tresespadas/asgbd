SET GLOBAL event_scheduler = ON;

DELIMITER $$

-- Trigger
DROP TRIGGER IF EXISTS trigger_reservas $$
CREATE TRIGGER trigger_reservas BEFORE UPDATE on hotel
FOR EACH ROW
  -- Creacion de la tabla si no existe
  CREATE TABLE IF NOT EXISTS hoteles_ocupados (
    id_hotel INT PRIMARY KEY,
    nombre VARCHAR(30),
    domicilio VARCHAR(30),
    telefono VARCHAR(9),
    num_habitaciones INT,
    fecha_ocupacion DATE
  );

  INSERT INTO hoteles_ocupados
  VALUES (OLD.id_hotel, OLD.nombre, OLD.domicilio, OLD.telefono, OLD.num_habitaciones, CURRENT_DATE());
END; $$

-- Cursor
DROP PROCEDURE IF EXISTS cursor_reservas $$
CREATE PROCEDURE cursor_reservas()
BEGIN
  DECLARE v_id_hotel, v_num_habitaciones, v_cont INT;
  DECLARE lrf BOOL;

  DECLARE cursor_principal CURSOR FOR
  SELECT id_hotel, num_habitaciones
  FROM hotel
  WHERE ocupado=false;

  DECLARE cursor_secundario CURSOR FOR
  SELECT id_hotel
  FROM reservas
  WHERE id_hotel = v_id_hotel;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf = 1;

  SET lrf = 0;
  OPEN cursor_principal;
  bucle1: LOOP
    FETCH cursor_principal INTO v_id_hotel,v_num_habitaciones;
    IF lrf=1 THEN
      LEAVE bucle1;
    END IF;
    SET v_cont = 0;
    OPEN cursor_secundario;
    bucle2: LOOP
      FETCH cursor_secundario INTO v_id_hotel;
      IF lrf=1 THEN
        LEAVE bucle2;
      END IF;
      SET v_cont = v_cont + 1;
    END LOOP bucle2;
    CLOSE cursor_secundario;
    SET lrf = 0;
    IF v_cont > v_num_habitaciones THEN
      UPDATE hotel SET ocupado=true WHERE id_hotel=v_id_hotel;
    END IF;
  END LOOP bucle1;
  CLOSE cursor_principal;
END; $$

-- Evento
DROP EVENT IF EXISTS evento_reservas $$
CREATE EVENT evento_reservas
ON SCHEDULE EVERY 1 MINUTE
DO
BEGIN
  CALL cursor_reservas();
END; $$
