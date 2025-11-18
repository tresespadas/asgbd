INSERT INTO SOCIOS (nombre, direccion, telefono, email) VALUES
('Alejandro Martín', 'C/ Mayor, 15', '600111222', 'alejandro.m@email.com'),
('Beatriz López', 'Av. Central, 45', '600333444', 'beatriz.l@email.com'),
('Carlos Ruiz', 'Pza. España, 1', '600555666', 'carlos.r@email.com'),
('Diana García', 'Ronda Exterior, 8', '600777888', 'diana.g@email.com'),
('Elena Torres', 'C/ Sol, 3', '600999000', 'elena.t@email.com');
INSERT INTO INSCRIPCIONES (id_socio, fecha_inscripcion, asistencia_pendiente) VALUES
(1, '2024-01-10', FALSE),
(2, '2024-02-15', FALSE),
(3, '2024-03-01', TRUE),
(4, '2024-04-20', FALSE),
(5, '2024-05-25', FALSE);
INSERT INTO ACTIVIDADES (nombre_actividad, tipo, aforo_maximo, fecha_asistencia,
id_socio) VALUES
('Yoga Matutino', 'Relajación', 20, '2025-10-15', 1),
('Clase de Spinning', 'Cardio', 15, '2025-11-10', 2),
('Entrenamiento Funcional', 'Fuerza', 10, '2025-11-14', 4),
('Zumba Dance', 'Baile', 30, '2025-11-16', 5),
('Natación Libre', 'Agua', 50, '2025-10-28', 1); 
