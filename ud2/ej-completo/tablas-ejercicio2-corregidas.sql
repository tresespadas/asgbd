-- =============================================
-- 1. Crear y seleccionar la base de datos
-- =============================================

DROP DATABASE IF EXISTS hoteleria;
CREATE DATABASE IF NOT EXISTS hoteleria
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE hoteleria;

-- =============================================
-- 2. Creación de las tablas
-- =============================================

DROP TABLE IF EXISTS reservas;
DROP TABLE IF EXISTS hotel;

CREATE TABLE hotel (
    id_hotel         INT PRIMARY KEY AUTO_INCREMENT,
    nombre           VARCHAR(100) NOT NULL,
    domicilio        VARCHAR(150) NOT NULL,
    telefono         VARCHAR(20)  NOT NULL,
    num_habitaciones INT NOT NULL CHECK (num_habitaciones > 0),
    ocupado          BOOLEAN NOT NULL DEFAULT FALSE   -- 0 = libre, 1 = ocupado
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE reservas (
    id_reserva       INT PRIMARY KEY AUTO_INCREMENT,
    id_hotel         INT NOT NULL,
    DNI_cliente      VARCHAR(12) NOT NULL,
    fecha_reserva    DATE NOT NULL,
    CONSTRAINT fk_reservas_hotel
        FOREIGN KEY (id_hotel) REFERENCES hotel(id_hotel)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- 3. Tabla para probar triggers y eventos
-- =============================================

DROP TABLE IF EXISTS hoteles_ocupados;

CREATE TABLE hoteles_ocupados (
    id_hotel         INT PRIMARY KEY,
    nombre           VARCHAR(100) NOT NULL,
    domicilio        VARCHAR(150) NOT NULL,
    telefono         VARCHAR(20)  NOT NULL,
    num_habitaciones INT NOT NULL CHECK (num_habitaciones > 0),
    ocupado          BOOLEAN NOT NULL DEFAULT TRUE,   -- siempre TRUE aquí
    fecha_ocupacion  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_fecha (fecha_ocupacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- 4. Inserción de datos ficticios
-- =============================================

-- Hoteles
INSERT INTO hotel (nombre, domicilio, telefono, num_habitaciones, ocupado) VALUES
('Hotel Sol y Luna',          'Av. del Mar 123, Málaga',          '951234567', 45, TRUE),
('Parador del Castillo',      'Calle Mayor 5, Toledo',            '925112233', 30, FALSE),
('Gran Hotel Central',        'Paseo de Gracia 88, Barcelona',    '933445566',120, TRUE),
('Hostal La Estrella',        'C/ del Sol 12, Sevilla',           '954778899', 15, FALSE),
('Hotel Boutique Ámbar',      'Plaza del Ayuntamiento 7, Valencia','963223344', 22, TRUE),
('Motel Ruta 66',             'Carretera Nacional 340 km 12, Cádiz','956889900', 60, FALSE),
('Hotel Playa Dorada',        'Paseo Marítimo s/n, Alicante',     '965112233', 80, TRUE),
('Albergue Montaña Verde',    'Ctra. Sierra Nevada km 5, Granada','958334455', 25, FALSE),
('Hotel Palacio Real',        'Calle Real 45, Madrid',            '911223344',150, TRUE),
('Posada del Río',            'Av. del Río 78, Bilbao',           '944556677', 35, FALSE);

-- Reservas
INSERT INTO reservas (id_hotel, DNI_cliente, fecha_reserva) VALUES
(1, '12345678A', '2025-12-01'),
(1, '87654321B', '2025-12-03'),
(2, '11223344C', '2025-11-15'),
(3, '55667788D', '2025-11-20'),
(3, '99887766E', '2025-12-10'),
(4, '44556677F', '2025-11-25'),
(5, '33445566G', '2025-12-05'),
(5, '22334455H', '2025-12-06'),
(6, '66778899I', '2025-11-30'),
(7, '88990011J', '2025-12-12'),
(7, '11223344K', '2025-12-13'),
(8, '55667788L', '2025-11-18'),
(9, '33445566M', '2025-12-20'),
(9, '99887766N', '2025-12-21'),
(10,'22334455O', '2025-11-22');
