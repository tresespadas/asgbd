SET GLOBAL event_scheduler = ON;

DELIMITER $$

-- Crecion de la tabla pedidos_historicos
CREATE TABLE IF NOT EXISTS pedidos_historicos (
  id_pedido INT PRIMARY KEY,
  fecha_finalizacion DATE,
  estado VARCHAR(15),
  cliente_DNI VARCHAR(10),
  importe_total INT,
  fecha_inclusion DATE
);

-- Trigger
DROP TRIGGER IF EXISTS tr_pedidos_historicos $$
CREATE TRIGGER tr_pedidos_historicos AFTER DELETE on pedidos
BEGIN
  INSERT INTO pedidos_historicos
  VALUES (NEW.id_pedido, NEW.fecha_finalizacion, NEW.estado, NEW.cliente_DNI, @v_importe_total, CURRENT_DATE());
END; $$

-- Cursor
DROP PROCEDURE IF EXISTS cursor_eliminar_completados $$
CREATE PROCEDURE cursor_eliminar_completados()
BEGIN
  DECLARE lrf BOOL;
  DECLARE v_id_pedido, v_cant INT;
  DECLARE v_precio_unit DECIMAL(10,2);

  DECLARE cursor_principal CURSOR FOR
  SELECT id_pedido
  FROM pedidos
  WHERE estado = "Completado"
  AND fecha_finalizacion < DATE_SUB(NOW(), INTERVAL 12 MONTH);

  DECLARE cursor_secundario CURSOR FOR
  SELECT cantidad, precio_unitario
  FROM detalles_pedido
  WHERE id_pedido = v_id_pedido;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf = 1;

  SET lrf = 0;
  OPEN cursor_pricipal;
  bucle1: LOOP
    FETCH cursor_principal INTO v_id_pedido;
    IF lrf=1 THEN
      LEAVE bucle1;
    END IF;
    SET @v_importe_total = 0;
    OPEN cursor_secundario;
    bucle2: LOOP
      FETCH cursor_secundario INTO v_cant, v_precio_unit;
      IF lrf=1 THEN
        LEAVE bucle2;
      END IF;
      SET @v_importe_total = v_importe_total + (v_cant * v_precio_unit);
    END bucle2;
    CLOSE cursor_secundario;
    SET lrf = 0;
    DELETE FROM detalles_pedido WHERE id_pedido=v_id_pedido;
    DELETE FROM pedidos WHERE id_pedido = v_id_pedido;
  END LOOP bucle1;
  CLOSE cursor_principal;
END; $$

-- Evento
DROP EVENT IF EXISTS evento_pedidos_completado_anual $$
CREATE EVENT evento_pedidos_completado_anual
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
  CALL cursor_eliminar_completados();
END; $$

DELIMITER ;
