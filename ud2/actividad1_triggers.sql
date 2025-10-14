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
