DELIMITER $$
USE base_de_datos $$
DROP PROCEDURE IF EXISTS tienda_menos_venta $$
CREATE PROCEDURE tienda_menos_venta()
BEGIN
   DECLARE v_id_tienda, v_id_tienda_min, v_ventas, v_ventas_totales, v_ventas_min INT;
   DECLARE lrf BOOL;
   DECLARE v_tienda_nombre, v_min_tienda_nombre VARCHAR(100);

   DECLARE cursor_principal CURSOR FOR
   SELECT id_tienda, nombre_tienda
   FROM Tiendas;

   DECLARE cursor_secundario CURSOR FOR
   SELECT cantidad
   FROM Ventas WHERE id_tienda=id_tienda AND fecha_venta BETWEEN DATE_SUB(now(),INTERVAL 1 month) AND NOW();

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf=1;

   SET lrf=0, v_ventas=0, v_ventas_totales=0, v_ventas_min=999999999;
   OPEN cursor_principal;
   bucle1: LOOP
      FETCH cursor_principal INTO v_id_tienda,v_tienda_nombre;
      IF lrf=1 THEN
         LEAVE bucle1;
      END IF;
      OPEN cursor_secundario
      bucle2: LOOP
         FETCH cursor_secundario INTO v_ventas;
            IF lrf=1 THEN
               LEAVE bucle2;
            END IF;
         SET v_ventas_totales = v_ventas_totales + v_ventas;
      END LOOP bucle2;
      IF v_ventas_min > v_ventas THEN
         SET v_ventas_min = v_ventas;
         SET v_id_tienda_min = v_id_tienda;
         SET v_min_tienda_nombre = v_tienda_nombre;
      END IF;
      SET lrf=0, v_ventas=0;
      CLOSE cursor_secundario;
   END LOOP bucle1;
   CLOSE cursor_principal;
   SELECT CONCACT("La tienda con el menor número de ventas del último mes es ",v_min_tienda_nombre," con ",v_ventas_min,"ventas.");
END;$$
DELIMITER ;
