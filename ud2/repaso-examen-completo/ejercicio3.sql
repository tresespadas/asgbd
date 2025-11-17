-- Creacion de la tabla si no existe
CREATE TABLE IF NOT EXISTS clientes_deudores (
  id_deudor INT PRIMARY KEY,
  nom_deudor VARCHAR(20),
  deuda INT
);

DELIMITER $$

-- Trigger 1
DROP TRIGGER IF EXISTS tr_insertar_deudores $$
CREATE TRIGGER tr_insertar_deudores AFTER UPDATE on cuentas
FOR EACH ROW
BEGIN
  IF NEW.saldo < 0 THEN
    INSERT INTO clientes_deudores
    SELECT codigo_cliente, nombre, NEW.saldo
    FROM clientes
    WHERE codigo_cliente = NEW.cod_cliente;
  END IF;
END; $$

-- Trigger 2
DROP TRIGGER IF EXISTS tr_actualizar_saldo $$
CREATE TRIGGER tr_actualizar_saldo AFTER INSERT on movimientos
FOR EACH ROW
BEGIN
  -- Actualizacion del saldo
  UPDATE cuentas
  SET saldo = NEW.cantidad + saldo
  WHERE cod_cuenta = cod_cuenta;
END; $$

DELIMITER ;
