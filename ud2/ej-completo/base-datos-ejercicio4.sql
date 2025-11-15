-- 1. Crear base de datos
CREATE DATABASE IF NOT EXISTS tienda;
USE tienda;

-- 2. Crear tabla pedidos
CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    fecha_finalizacion DATE,
    estado VARCHAR(50),
    cliente_dni VARCHAR(15)
);

-- 3. Crear tabla detalles_pedido
CREATE TABLE detalles_pedido (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    id_pedido INT,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

-- 4. Insertar datos en pedidos
INSERT INTO pedidos (fecha_finalizacion, estado, cliente_dni) VALUES
('2025-01-15', 'Pendiente', '12345678A'),
('2025-01-20', 'Pendiente', '87654321B'),
('2025-01-25', 'Completado', '11223344C');

-- 5. Insertar datos en detalles_pedido
INSERT INTO detalles_pedido (cantidad, precio_unitario, id_pedido) VALUES
(3, 15.50, 1),
(1, 199.99, 1),
(2, 9.99, 2),
(5, 2.50, 2),
(1, 499.00, 3);

