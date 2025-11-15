-- 1. Crear base de datos
CREATE DATABASE IF NOT EXISTS reparto_pedidos;
USE reparto_pedidos;

-- 2. Crear tabla repartidores
CREATE TABLE repartidores (
    id_repartidor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(20),
    telefono VARCHAR(9),
    max_pedido INT,
    saturado BOOL
);

-- 3. Crear tabla pedidos
CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_repartidor INT,
    fecha DATE,
    estado VARCHAR(15),
    FOREIGN KEY (id_repartidor) REFERENCES repartidores(id_repartidor)
);

-- 4. Crear tabla repartidores_saturados
CREATE TABLE repartidores_saturados (
  id_saturacion INT AUTO_INCREMENT PRIMARY KEY,
  id_repartidor INT,
  nombre VARCHAR(20),
  telefono VARCHAR(9),
  fecha_saturacion DATETIME
);

INSERT INTO repartidores (nombre, telefono, max_pedido, saturado) VALUES
('Carlos Pérez', '612345678', 5, FALSE),
('Ana López', '623456789', 4, FALSE),
('Luis García', '634567890', 6, TRUE),
('María Torres', '645678901', 3, FALSE),
('Jorge Ruiz', '656789012', 7, TRUE),
('Sofía Martín', '667890123', 5, FALSE),
('Pablo Sánchez', '678901234', 4, FALSE),
('Elena Fernández', '689012345', 5, TRUE),
('Raúl Ortega', '690123456', 6, FALSE),
('Laura Gómez', '601234567', 3, FALSE),
('Hugo Domínguez', '622345678', 4, FALSE),
('Natalia Herrera', '633456789', 6, TRUE),
('Iván Molina', '644567890', 5, FALSE),
('Paula Benítez', '655678901', 4, FALSE),
('Rubén Ramos', '666789012', 7, TRUE),
('Clara Morales', '677890123', 3, FALSE),
('Adrián Vega', '688901234', 5, FALSE),
('Irene Solís', '699012345', 4, TRUE),
('Óscar Navarro', '600123456', 6, FALSE),
('Sara Castro', '611234567', 5, FALSE);

INSERT INTO pedidos (id_repartidor, fecha, estado) VALUES
(1, '2025-01-02', 'pendiente'),
(1, '2025-01-03', 'entregado'),
(1, '2025-01-05', 'en reparto'),
(2, '2025-01-01', 'entregado'),
(2, '2025-01-04', 'pendiente'),
(3, '2025-01-02', 'cancelado'),
(3, '2025-01-06', 'entregado'),
(4, '2025-01-03', 'en reparto'),
(4, '2025-01-08', 'entregado'),
(5, '2025-01-02', 'pendiente'),
(5, '2025-01-04', 'pendiente'),
(5, '2025-01-07', 'entregado'),
(6, '2025-01-05', 'en reparto'),
(6, '2025-01-06', 'entregado'),
(7, '2025-01-01', 'pendiente'),
(7, '2025-01-02', 'pendiente'),
(7, '2025-01-05', 'entregado'),
(8, '2025-01-02', 'cancelado'),
(8, '2025-01-06', 'pendiente'),
(9, '2025-01-03', 'entregado'),
(9, '2025-01-07', 'entregado'),
(10, '2025-01-04', 'pendiente'),
(10, '2025-01-08', 'devuelto'),
(10, '2025-01-09', 'en reparto'),
(11, '2025-01-02', 'entregado'),
(11, '2025-01-04', 'pendiente'),
(12, '2025-01-03', 'cancelado'),
(12, '2025-01-06', 'pendiente'),
(13, '2025-01-04', 'en reparto'),
(13, '2025-01-09', 'entregado'),
(14, '2025-01-02', 'pendiente'),
(14, '2025-01-05', 'entregado'),
(15, '2025-01-03', 'pendiente'),
(15, '2025-01-06', 'en reparto'),
(15, '2025-01-07', 'entregado'),
(16, '2025-01-01', 'cancelado'),
(16, '2025-01-03', 'pendiente'),
(16, '2025-01-06', 'entregado'),
(17, '2025-01-02', 'en reparto'),
(17, '2025-01-03', 'entregado'),
(17, '2025-01-05', 'entregado'),
(18, '2025-01-04', 'pendiente'),
(18, '2025-01-06', 'devuelto'),
(19, '2025-01-03', 'entregado'),
(19, '2025-01-07', 'pendiente'),
(19, '2025-01-08', 'entregado'),
(20, '2025-01-02', 'pendiente'),
(20, '2025-01-03', 'pendiente'),
(20, '2025-01-06', 'en reparto'),
(1, '2025-01-10', 'entregado'),
(2, '2025-01-09', 'devuelto'),
(3, '2025-01-11', 'pendiente'),
(4, '2025-01-12', 'entregado'),
(5, '2025-01-10', 'pendiente'),
(6, '2025-01-09', 'en reparto'),
(7, '2025-01-11', 'entregado'),
(8, '2025-01-12', 'pendiente'),
(9, '2025-01-10', 'entregado'),
(10, '2025-01-13', 'entregado'),
(11, '2025-01-12', 'pendiente'),
(12, '2025-01-11', 'cancelado'),
(13, '2025-01-12', 'pendiente'),
(14, '2025-01-13', 'entregado'),
(15, '2025-01-11', 'devuelto'),
(16, '2025-01-12', 'pendiente'),
(17, '2025-01-13', 'entregado'),
(18, '2025-01-11', 'en reparto'),
(19, '2025-01-12', 'entregado'),
(20, '2025-01-10', 'pendiente');
