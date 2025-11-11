DELIMITER $$
-- Evento
DROP EVENT IF EXITS evento_completado $$
CREATE EVENT evento_completo
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
   CALL cursor_eliminacion;;
END; $$

-- Trigger
DROP TRIGGER IF EXISTS trigger_volcado $$
CREATE TRIGGER trigger_volcado BEFORE DELETE on pedidos
FOR EACH ROW
   INSERT INTO pedidos_historicos(id_pedido,fecha_finalizacion,estado,cliente_dni,importe_total,fecha_inclusion) VALUES (old.id_pedido,old.fecha_finalizacion,old.estado,old.cliente_dni, --DUDA:importe_total (pertenece a otra tabla)
END; $$

-- Cursor
DROP PROCEDURE IF EXISTS cursor_eliminacion $$
CREATE PROCEDURE cursor_eliminacion()
BEGIN
   DECLARE v_id_pedido,v_cant_total INT;
   DECLARE lrf BOOL;

   DECLARE cursor_principal CURSOR FOR
   SELECT id_pedido
   FROM pedidos 
   WHERE estado="completado" AND fecha_finalizacion < DATE_SUB(NOW(), INTERVAL 12 MONTH);

   DECLARE cursor_secundario CURSOR FOR
   SELECT cantidad
   FROM detalles_pedidos
   WHERE id_pedido=v_id_pedido;
  
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf=1;
   
   SET lrf=0,v_cant_total=0;
   OPEN cursor_principal;
   bucle1: LOOP
      FETCH cursor_principal INTO 
