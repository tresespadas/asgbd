SET GLOBAL event_scheduler = ON;

DELIMITER $$

-- Trigger
DROP TRIGGER IF EXISTS trigger_saturado $$
CREATE TRIGGER trigger_saturado AFTER UPDATE on repartidores
FOR EACH ROW
BEGIN
  INSERT INTO repartidores_saturados(id_repartidor, nombre, telefono, fecha_saturacion)
  VALUES (NEW.id_repartidor, NEW.nombre, NEW.telefono, NOW());
END; $$

-- Cursor
DROP PROCEDURE IF EXISTS cursor_saturado $$
CREATE PROCEDURE cursor_saturado()
BEGIN
  DECLARE v_id_repartidor, v_id_pedido, v_pedidos_total, v_max_pedido INT;
  DECLARE v_estado VARCHAR(15);
  DECLARE lrf BOOL;

  DECLARE cursor_principal CURSOR FOR
  SELECT id_repartidor, max_pedido
  FROM repartidores
  WHERE saturado=false;

  DECLARE cursor_secundario CURSOR FOR
  SELECT id_pedido, estado
  FROM pedidos
  WHERE id_repartidor=v_id_repartidor;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf=1;

  SET lrf = 0;

  OPEN cursor_principal;
  bucle1: LOOP
    FETCH cursor_principal INTO v_id_repartidor, v_max_pedido;
    IF lrf=1 THEN
      LEAVE bucle1;
    END IF;
    SET v_pedidos_total = 0;
    OPEN cursor_secundario;
    bucle2: LOOP
      FETCH cursor_secundario INTO v_id_pedido, v_estado;
      IF lrf=1 THEN
        LEAVE bucle2;
      END IF;
      IF v_estado = "pendiente" THEN
        SET v_pedidos_total = v_pedidos_total + 1;
      END IF;
    END LOOP bucle2;
    SET lrf=0;
    CLOSE cursor_secundario;
    IF v_pedidos_total > v_max_pedido THEN
      UPDATE repartidores SET saturado=true WHERE id_repartidor=v_id_repartidor;
    END IF;
  END LOOP bucle1;
  CLOSE cursor_principal;
END; $$

-- Evento
DROP EVENT IF EXISTS evento_saturado $$
CREATE EVENT evento_saturado
ON SCHEDULE EVERY 5 MINUTE DO
BEGIN
  CALL cursor_saturado;
END; $$

DELIMITER ;
