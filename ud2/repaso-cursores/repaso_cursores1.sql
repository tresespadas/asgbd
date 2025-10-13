-- Cursor para saber el número de cuentas de cada cliente
-- PROBADO Y TESTEADO EN MÁQUINA
DELIMITER $$
USE ebanca $$
DROP PROCEDURE IF EXISTS numero_cuentas_clientes $$
CREATE PROCEDURE numero_cuentas_clientes()
BEGIN
   DECLARE lrf BOOLEAN;
   DECLARE v_codigo_cliente, v_cod_cuenta, v_cont_cuentas INT;
   DECLARE v_nombre, v_apellido1 CHAR(20);
   

   DECLARE c_clientes CURSOR FOR
   SELECT codigo_cliente, nombre, apellido1
   FROM clientes;

   DECLARE c_cuentas CURSOR FOR
   SELECT cod_cuenta
   FROM cuentas
   WHERE cod_cliente=v_codigo_cliente;

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf=1; 

   SET lrf=0, v_cont_cuentas=0;
   OPEN c_clientes;
   l_clientes: LOOP
      FETCH c_clientes INTO v_codigo_cliente, v_nombre, v_apellido1;
      IF lrf=1 THEN
         LEAVE l_clientes;
      END IF;

      SET lrf=0;
      OPEN c_cuentas;

      l_cuentas: LOOP
         FETCH c_cuentas INTO v_cod_cuenta;
         IF lrf=1 THEN
            LEAVE l_cuentas;
         END IF;

         SET v_cont_cuentas=v_cont_cuentas + 1;
      END LOOP l_cuentas;
      SELECT CONCAT("El usuario ",v_nombre," ",v_apellido1," con codigo de cliente ",v_codigo_cliente," posee ",v_cont_cuentas," cuentas a su nombre.") AS Mensaje;

      SET lrf=0, v_cont_cuentas=0;
      CLOSE c_cuentas;

   END LOOP l_clientes;
   CLOSE c_clientes;
END;$$
DELIMITER ;

