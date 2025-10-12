-- PROBADO EN MÁQUINA
DELIMITER $$
USE ebanca $$
DROP PROCEDURE IF EXISTS cuenta_saldo_negativo $$
CREATE PROCEDURE cuenta_saldo_negativo()
BEGIN
   DECLARE v_nombre CHAR(20);
   DECLARE v_cod_cliente, v_cod_cuenta, v_saldo INT;
   DECLARE lrf BOOLEAN;

   DECLARE c_clientes CURSOR FOR
   SELECT nombre, codigo_cliente
   FROM clientes;

   DECLARE c_cuentas CURSOR FOR
   SELECT saldo, cod_cuenta
   FROM cuentas
   WHERE cod_cliente=v_cod_cliente AND saldo<0;

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf=1;

   SET lrf=0; 
   OPEN c_clientes;

   l_clientes: LOOP
      FETCH c_clientes INTO v_nombre, v_cod_cliente;
      IF lrf=1 THEN
         LEAVE l_clientes;
      END IF;

      SET lrf=0; 
      OPEN c_cuentas;

      l_cuentas: LOOP
         FETCH c_cuentas INTO v_saldo, v_cod_cuenta;
         IF lrf=1 THEN
            LEAVE l_cuentas;
         END IF;
         SELECT CONCAT("El cliente ",v_nombre," y con cuenta ",v_cod_cuenta," tiene un saldo de ",v_saldo,".") AS Mensaje;
      END LOOP l_cuentas;

      SET lrf=0;
      CLOSE c_cuentas;
   END LOOP l_clientes;
   CLOSE c_clientes;
END;$$
DELIMITER ;
