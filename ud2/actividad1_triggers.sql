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
   SET @saldo = @saldo + NEW.saldo;
END; $$
DELIMITER ;

SET @saldo=0;

INSERT INTO cuentas VALUES(1,150.39);
SELECT @saldo;

DELIMITER $$
CREATE TRIGGER trigger_resta BEFORE DELETE ON cuentas FOR EACH ROW
BEGIN
   SET @saldo = @saldo - OLD.saldo;
END; $$
DELIMITER ;

DELETE FROM cuentas WHERE num_cuenta=1;
SELECT @saldo;


-- Ejercicio 2
DELIMITER $$
CREATE PROCEDURE pr_calculo_comision(importe DECIMAL)
BEGIN
   SET @var_global_comision = importe / 5;
END;
$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trigger_comision AFTER INSERT on ventas FOR EACH ROW
BEGIN
   CALL pr_calculo_comision(NEW.importe);
   SET NEW.importecomision = @var_global_comision;
END; $$
DELIMITER ;
