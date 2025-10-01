DELIMITER $$
USE base_de_datos $$
DROP PROCEDURE IF EXISTS tienda_menos_venta $$
CREATE PROCEDURE tienda_menos_venta()
BEGIN
   DECLARE v_id_tienda INT;
   DECLARE lrf BOOL;

   DECLARE cursor_principal CURSOR FOR
   SELECT id_tienda
   FROM Tiendas;

   DECLARE cursor_secundario CURSOR FOR
   SELECT id_venta
   FROM Ventas WHERE id_tienda=id_tienda AND fecha_venta BETWEEN now() AND DATE_SUB(now(),INTERVAL 1 month);

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf=1;
