CREATE DATABASE GIMNASIO;
USE GIMNASIO;
CREATE TABLE SOCIOS (
 id_socio INT AUTO_INCREMENT PRIMARY KEY,
 nombre VARCHAR(100) NOT NULL,
 direccion VARCHAR(200),
 telefono VARCHAR(20),
 email VARCHAR(120)
);

CREATE TABLE ACTIVIDADES (
 codigo_actividad INT AUTO_INCREMENT PRIMARY KEY,
 nombre_actividad VARCHAR(120) NOT NULL,
 tipo VARCHAR(50),
 aforo_maximo INT NOT NULL,
 fecha_asistencia DATE,
 id_socio INT,
 FOREIGN KEY (id_socio) REFERENCES SOCIOS(id_socio)
);

CREATE TABLE INSCRIPCIONES (
 id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
 id_socio INT NOT NULL,
 fecha_inscripcion DATE NOT NULL,
 asistencia_pendiente BOOLEAN,
 FOREIGN KEY (id_socio) REFERENCES SOCIOS(id_socio)
);

CREATE TABLE ALERTAS (
 id_alerta INT AUTO_INCREMENT PRIMARY KEY,
 id_socio INT NOT NULL,
 nombre_socio VARCHAR(100) NOT NULL,
 fecha_inscripcion DATE NOT NULL,
 telefono VARCHAR(20),
 email VARCHAR(120),
 fecha_alerta DATETIME NOT NULL
);
