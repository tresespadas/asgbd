-- Cursor deudores
DELIMITER $$
DROP PROCEDURE IF EXISTS cursor1 $$
CREATE PROCEDURE cursor1 
BEGIN
   DECLARE lrf BOOL;
   DECLARE v_cod_cliente, v_saldo, v_saldo_total INT;
   DECLARE v_nombre_cliente VARCHAR(20);

   DECLARE cursor_principal CURSOR FOR
   SELECT codigo_cliente, nombre
   FROM clientes;
   
   DECLARE cursor_secundario CURSOR FOR
   SELECT saldo
   FROM cuentas
   WHERE cod_cliente=v_cod_cliente AND saldo < 0;

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET lrf=1;

   SET lrf=0;
   OPEN cursor_principal;
   bucle1: LOOP
      FETCH cursor_principal INTO v_cod_cliente, v_nombre_cliente;
      IF lrf=1 THEN
         LEAVE bucle1;
      END IF;
      SET v_saldo_total=0;
      OPEN cursor_secundario;
      bucle2: LOOP
         FETCH cursor_secundario INTO v_cod_cuenta, v_saldo
         IF lrf=1 THEN
            LEAVE bucle2;
         END IF;
         SET v_saldo_total = v_saldo_total + v_saldo;
      END LOOP bucle2;
      INSERT INTO deudores(id_deudor,nom_deudor,deuda) VALUES (v_cod_cliente,v_nombre_cliente,v_saldo_total);
      CLOSE cursor_secundario;
      SET lrf=0;
   END LOOP bucle1;
   CLOSE cursor_principal;
END; $$

-- Trigger para actualizar la tabla cuentas
DROP TRIGGER IF EXISTS trigger1 $$
CREATE TRIGGER trigger1 BEFORE INSERT on movimiento
FOR EACH ROW
BEGIN
   UPDATE cuentas SET saldo = saldo + NEW.cantidad WHERE cod_cuenta=NEW.cod_cuenta
END; $$

-- Trigger para cambios en cuentas
DROP TRIGGER IF EXISTS trigger2 $$
CREATE TRIGGER trigger2 AFTER UPDATE on cuentas
FOR EACH ROW
BEGIN
   CALL cursor1;
END; $$
