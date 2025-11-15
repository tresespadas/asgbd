SET  GLOBAL event_scheduler = ON;

DELIMITER $$

-- Trigger
DROP TRIGGER IF EXISTS trigger_volcado $$
CREATE TRIGGER trigger_volcado BEFORE DELETE on pedidos
FOR EACH ROW
BEGIN
  INSERT INTO pedidos_historicos(id_pedido,fecha_finalizacion,estado,cliente_dni,importe_total,fecha_inclusion) VALUES (OLD.id_pedido,OLD.fecha_finalizacion,OLD.estado,OLD.cliente_dni,@v_importe_calculado,NOW());
END; $$

-- Cursor
DROP PROCEDURE IF EXISTS cursor_eliminacion $$
CREATE PROCEDURE cursor_eliminacion()
BEGIN
  DECLARE v_id_pedido, v_cant_pedido INT;
  DECLARE v_precio_pedido, v_cant_total DECIMAL(10,2);
  DECLARE lrf BOOL;

  DECLARE cursor_principal CURSOR FOR
  SELECT id_pedido
  FROM pedidos
  WHERE estado="Completado" AND fecha_finalizacion < DATE_SUB(NOW(), INTERVAL 12 MONTH);

  DECLARE cursor_secundario CURSOR FOR
  SELECT cantidad, precio_unitario
  FROM detalles_pedido
  WHERE id_pedido=v_id_pedido;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf=1;

  SET lrf=0;
  OPEN cursor_principal;
  bucle1: LOOP
  FETCH cursor_principal INTO v_id_pedido;
  IF lrf=1 THEN
    LEAVE bucle1;
  END IF;
  OPEN cursor_secundario;
  bucle2: LOOP
    FETCH cursor_secundario INTO v_cant_pedido, v_precio_pedido;
    IF lrf=1 THEN
      LEAVE bucle2;
    END IF;
    SET v_cant_total = v_cant_pedido * v_precio_pedido;
    SET @v_importe_calculado = v_cant_total;
    DELETE FROM detalles_pedido WHERE id_pedido=v_id_pedido;
    DELETE FROM pedidos WHERE id_pedido=v_id_pedido;
  END LOOP bucle2;
  SET lrf=0;
  CLOSE cursor_secundario;
  END LOOP bucle1;
  CLOSE cursor_principal;
END; $$

-- Evento
DROP EVENT IF EXISTS evento_completado $$
CREATE EVENT evento_completado
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
  CALL cursor_eliminacion;
END; $$

DELIMITER ;
