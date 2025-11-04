DELIMITER $$
DROP PROCEDURE IF EXISTS cursores $$
CREATE PROCEDURE cursores()
BEGIN
   DECLARE v_id_hotel, v_id_reserva, v_num_habitaciones, v_contador_reserva INT;
   DECLARE lrf BOOL;

   DECLARE cursor_principal CURSOR FOR
   SELECT id_hotel, num_habitaciones
   FROM hotel WHERE ocupado=false;

   DECLARE cursor_secundario CURSOR FOR
   SELECT id_reserva
   FROM reservas WHERE id_hotel=v_id_hotel;

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf=1;

   SET lrf=0, v_contador_reserva=0;
   OPEN cursor_principal;
   bucle1: LOOP
      FETCH cursor_principal INTO v_id_hotel, v_num_habitaciones;
      IF lrf=1 THEN
         LEAVE bucle1;
      END IF;
      OPEN cursor_secundario;
      SET v_contador_reserva=0, v_num_habitaciones=0;
      bucle2: LOOP
         FETCH cursor_secundario INTO v_id_reserva;
            IF lrf=1 THEN
               LEAVE bucle2;
            END IF;
            SET v_contador_reserva = v_contador_reserva + 1;
      END LOOP bucle2;
      IF v_contador_reserva > v_num_habitaciones THEN
         UPDATE hotel SET ocupado = true WHERE id_hotel=v_id_hotel;
      END IF;
      CLOSE cursor_secundario;
      SET lrf=0;
   END LOOP bucle1;
   CLOSE cursor_principal;
END;$$

DROP EVENT IF EXISTS evento1 $$
CREATE EVENT evento1
ON SCHEDULE EVERY 1 MINUTE
DO
BEGIN
   CALL cursores;
END; $$

DROP TRIGGER IF EXISTS trigger1 $$
CREATE TRIGGER trigger1 AFTER UPDATE ON hotel
FOR EACH ROW
BEGIN
   INSERT INTO hoteles_ocupados(id_hotel,nombre,domicilio,telefono,num_habitaciones,ocupado,fecha_ocupacion) VALUES (NEW.id_hotel,NEW.nombre,NEW.domicilio,NEW.telefono,NEW.num_habitaciones,NEW.ocupado,CURRENT_DATE());
END; $$

DELIMITER ;
