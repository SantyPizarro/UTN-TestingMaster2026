-- Actividad 3 - SQLiteOnline
-- US-23 - Crear Cancha
-- Caso principal: TC-US23-01 - Creación exitosa de cancha
--
-- La última sentencia falla intencionalmente para demostrar
-- la validación de campos obligatorios.

PRAGMA foreign_keys = OFF;

DROP TABLE IF EXISTS audit_events;
DROP TABLE IF EXISTS courts;
DROP TABLE IF EXISTS venues;
DROP TABLE IF EXISTS sports;
DROP TABLE IF EXISTS users;

PRAGMA foreign_keys = ON;

-- ============================================================
-- 1. ESTRUCTURA DDL
-- ============================================================

CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  role TEXT NOT NULL CHECK (role IN ('ADMIN', 'USER')),
  status TEXT NOT NULL DEFAULT 'ACTIVE'
    CHECK (status IN ('ACTIVE', 'BLOCKED', 'DELETED')),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sports (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  status TEXT NOT NULL DEFAULT 'ACTIVE'
    CHECK (status IN ('ACTIVE', 'INACTIVE'))
);

CREATE TABLE venues (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  city TEXT NOT NULL,
  address TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'ACTIVE'
    CHECK (status IN ('ACTIVE', 'INACTIVE')),
  UNIQUE (name, city)
);

CREATE TABLE courts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  venue_id INTEGER NOT NULL,
  sport_id INTEGER NOT NULL,
  created_by_user_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  price_per_hour REAL NOT NULL CHECK (price_per_hour > 0),
  status TEXT NOT NULL DEFAULT 'ACTIVE'
    CHECK (status IN ('ACTIVE', 'MAINTENANCE', 'INACTIVE')),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (venue_id) REFERENCES venues(id),
  FOREIGN KEY (sport_id) REFERENCES sports(id),
  FOREIGN KEY (created_by_user_id) REFERENCES users(id),
  UNIQUE (venue_id, name)
);

CREATE TABLE audit_events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id INTEGER NOT NULL,
  event_type TEXT NOT NULL,
  description TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

SELECT
  name AS created_table
FROM sqlite_master
WHERE type = 'table'
  AND name NOT LIKE 'sqlite_%'
ORDER BY name;

-- ============================================================
-- 2. PREPARACIÓN DML
-- ============================================================

INSERT INTO users (full_name, email, role) VALUES
  ('Administrador ATC', 'admin@atcsports.test', 'ADMIN'),
  ('Santiago Pizarro', 'santiago.pizarro@example.com', 'USER');

INSERT INTO sports (name) VALUES
  ('Futbol'),
  ('Padel');

INSERT INTO venues (name, city, address) VALUES
  ('Grun FC', 'Buenos Aires', 'Av. Demo 123'),
  ('Babolat Padel Center', 'Buenos Aires', 'Calle Demo 456');

SELECT id, full_name, email, role, status
FROM users
ORDER BY id;

SELECT id, name, status
FROM sports
ORDER BY id;

SELECT id, name, city, address, status
FROM venues
ORDER BY id;

-- ============================================================
-- 3. TC-US23-01 - CREACIÓN EXITOSA DE CANCHA
-- ============================================================

INSERT INTO courts (
  venue_id,
  sport_id,
  created_by_user_id,
  name,
  price_per_hour,
  status
) VALUES (
  1,
  1,
  1,
  'Cancha Central 1',
  25000,
  'ACTIVE'
);

INSERT INTO audit_events (
  user_id,
  entity_type,
  entity_id,
  event_type,
  description
) VALUES (
  1,
  'COURT',
  1,
  'COURT_CREATED',
  'El administrador registró la cancha Cancha Central 1.'
);

SELECT
  c.id AS court_id,
  c.name AS court_name,
  s.name AS sport,
  v.name AS venue,
  v.city,
  v.address,
  c.price_per_hour,
  c.status,
  u.full_name AS created_by,
  c.created_at
FROM courts c
JOIN sports s ON s.id = c.sport_id
JOIN venues v ON v.id = c.venue_id
JOIN users u ON u.id = c.created_by_user_id
WHERE c.id = 1;

SELECT
  event_type,
  entity_type,
  entity_id,
  description,
  created_at
FROM audit_events
WHERE entity_type = 'COURT'
  AND entity_id = 1;

-- ============================================================
-- 4. PRUEBA FALLIDA DE INTEGRIDAD
-- ============================================================

-- Este INSERT debe fallar porque el nombre es obligatorio.
INSERT INTO courts (
  venue_id,
  sport_id,
  created_by_user_id,
  name,
  price_per_hour,
  status
) VALUES (
  1,
  2,
  1,
  NULL,
  18000,
  'ACTIVE'
);

-- Resultado esperado:
-- NOT NULL constraint failed: courts.name

