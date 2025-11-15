CREATE TABLE pedidos_historicos (
  id_historico INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT,
  fecha_finalizacion DATE,
  estado VARCHAR(50),
  cliente_dni VARCHAR(15),
  importe_total DECIMAL(10,2),
  fecha_inclusion DATETIME
);

