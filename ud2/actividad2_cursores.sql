DELIMITER $$
USE base_de_datos $$
DROP PROCEDURE IF EXISTS tienda_menos_venta $$
CREATE PROCEDURE tienda_menos_venta()
BEGIN
   DECLARE v_id_tienda, v_contador, v_contador_min INT;
   DECLARE lrf BOOL;

   DECLARE cursor_principal CURSOR FOR
   SELECT id_tienda
   FROM Tiendas;

   DECLARE cursor_secundario CURSOR FOR
   SELECT id_venta
   FROM Ventas WHERE id_tienda=id_tienda AND fecha_venta BETWEEN DATE_SUB(now(),INTERVAL 1 month) AND NOW();

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf=1;

   SET lrf=0, v_contador=0, v_contador_min=0;
   OPEN cursor_principal;
   bucle1: LOOP
      FETCH cursor_principal INTO v_id_tienda;
      IF lrf=1 THEN
         LEAVE bucle1;
      END IF;
      OPEN cursor_secundario
      bucle2: LOOP
         FETCH cursor_secundario INTO v_id_venta;
            IF lrf=1 THEN
               LEAVE bucle2;
            END IF;
            
