SET GLOBAL event_scheduler = ON;

DELIMITER $$

-- Creacion de la tabla si no existe
CREATE TABLE IF NOT EXISTS repartidores_saturados(
  id_repartidor INT PRIMARY KEY,
  nombre VARCHAR(20),
  telefono VARCHAR(9),
  max_pedido INT,
  saturado BOOL,
  fecha_saturacion DATE
);

-- Trigger
DROP TRIGGER IF EXISTS tr_saturado $$
CREATE TRIGGER tr_saturado AFTER UPDATE ON repartidores
FOR EACH ROW
BEGIN
  INSERT INTO repartidores_saturados
  VALUES (NEW.id_repartidor, NEW.nombre, NEW.telefono, NEW.max_pedido, NEW.saturado, CURRENT_DATE());
END; $$

-- Cursor
DROP PROCEDURE IF EXISTS proc_saturado $$
CREATE PROCEDURE proc_saturado()
BEGIN
  DECLARE v_id_pedido, v_id_repartidor, v_max_pedido, v_cont INT;
  DECLARE lrf BOOL;

  DECLARE cursor_principal CURSOR FOR
  SELECT id_repartidor, max_pedido
  FROM repartidores
  WHERE saturado=false;

  DECLARE cursor_secundario CURSOR FOR
  SELECT id_pedido -- Podría quitarme esta variable?
  FROM pedidos
  WHERE id_repartidor = v_id_repartidor
  AND estado="Pendiente";
  
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf = 1;

  SET lrf = 0;
  OPEN cursor_principal;
  bucle1: LOOP
    FETCH cursor_principal INTO v_id_repartidor, v_max_pedido;
    IF lrf=1 THEN
      LEAVE bucle1;
    END IF;
    SET v_cont = 0;
    OPEN cursor_secundario;
    bucle2: LOOP
      FETCH cursor_secundario INTO v_pedido;
      IF lrf=1 THEN
        LEAVE bucle2;
      END IF;
      SET v_cont = v_cont  1;
    END LOOP bucle2;
    CLOSE cursor_secundario;
    SET lrf = 0;
    IF v_cont > v_max_pedido THEN
      UPDATE repartidores SET saturado=true WHERE id_repartidor = v_id_repartidor;
    END IF;
  END LOOP bucle1;
  CLOSE cursor_principal;
END; $$

-- Evento
DROP EVENT IF EXISTS evento_pendientes_5min $$
CREATE EVENT evento_pendientes_5min
ON SCHEDULE EVERY 5 MINUTE
DO
BEGIN
  CALL proc_saturado();
END; $$

DELIMITER ;
