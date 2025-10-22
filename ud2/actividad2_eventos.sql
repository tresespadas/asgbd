-- Ejercicio 4-2 Eventos
DELIMITER $$
CREATE EVENT evento
ON SCHEDULE EVERY 1 MONTH -- Final de mes?
STARTS LAST_DAY(NOW())
DO
   BEGIN
         INSERT INTO transacciones (id_cuenta, fecha, ajuste)
         SELECT id_cuenta, NOW(), 50
         FROM cuentas
         WHERE saldo < 100
   END; $$
DELIMITER ;

         
