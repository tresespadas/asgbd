-- Ejercicio 1
DELIMITER $$
CREATE TABLE cuentas (
   num_cuenta INT PRIMARY KEY
   saldo DECIMAL(12,2)
)
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trigger_acumulativo AFTER INSERT ON cuentas FOR EACH ROW
BEGIN
   SET @total = @total + NEW.saldo;
END; $$
DELIMITER ;

INSERT INTO cuentas VALUES(1,150.39);
SELECT @total;

DELIMITER $$
CREATE TRIGGER trigger_resta BEFORE DELETE ON cuentas FOR EACH ROW
BEGIN
   SET @total = @total - OLD.saldo;
END; $$
DELIMITER ;

DELETE FROM cuentas WHERE num_cuenta=1;
SELECT @total;


-- Ejercicio 2
DELIMITER $$
CREATE TRIGGER trigger_comision AFTER INSERT on ventas FOR EACH ROW
BEGIN
   SET @importecomision = NEW.importeventa * 1.2;
END; $$
DELIMITER ;
