-- US-23 - Crear Cancha
-- Sección 2: datos de preparación.

PRAGMA foreign_keys = ON;

INSERT INTO users (full_name, email, role) VALUES
  ('Administrador ATC', 'admin@atcsports.test', 'ADMIN'),
  ('Santiago Pizarro', 'santiago.pizarro@example.com', 'USER');

INSERT INTO sports (name) VALUES
  ('Futbol'),
  ('Padel');

INSERT INTO venues (name, city, address) VALUES
  ('Grun FC', 'Buenos Aires', 'Av. Demo 123'),
  ('Babolat Padel Center', 'Buenos Aires', 'Calle Demo 456');

-- Se cargaron 6 registros iniciales:
-- 2 usuarios, 2 deportes y 2 complejos deportivos.

SELECT id, full_name, email, role, status
FROM users
ORDER BY id;

SELECT id, name, status
FROM sports
ORDER BY id;

SELECT id, name, city, address, status
FROM venues
ORDER BY id;

