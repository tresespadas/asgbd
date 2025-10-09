DELIMITER $$

DROP PROCEDURE IF EXISTS clientes_cuenta_negativa $$
CREATE PROCEDURE clientes_cuenta_negativa()
BEGIN
  DECLARE v_codigo_cliente, v_dni, v_saldo, v_cod_cuenta INT;
  DECLARE v_nombre, v_apellido1, v_apellido2, v_direccion CHAR(50);
  DECLARE v_region VARCHAR(45);

  DECLARE c_clientes CURSOR FOR
  SELECT *
  FROM clientes;

  DECLARE c_cuentas CURSOR FOR
  SELECT saldo, cod_cuenta
  FROM cuentas
  WHERE cod_cliente=codigo_cliente AND saldo < 0;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf=1;

  SET lrf=0;
  OPEN c_clientes;
  l_clientes: LOOP
    FETCH c_clientes INTO v_codigo_cliente, v_dni, v_nombre, v_apellido1, v_apellido2, v_direccion, v_region;
    IF lrf=1 THEN
      LEAVE l_clientes;
    END IF;
    OPEN c_cuentas;
    l_cuentas: LOOP
      FETCH c_cuentas INTO v_saldo, v_cod_cuenta;
      IF lrf=1 THEN
        LEAVE l_cuentas;
      END IF;
      SELECT CONCAT("El cliente ",v_nombre," ",v_apellido1," ",v_apellido2," con dirección ",v_direccion,v_region," posee un cuenta con ID ",v_cod_cuenta," con saldo de ",v_saldo,".");
      END LOOP l_cuentas;
    SET lrf=0;
    CLOSE c_cuentas;
    END LOOP l_clientes;
    CLOSE c_clientes;
END;$$
DELIMITER ;
