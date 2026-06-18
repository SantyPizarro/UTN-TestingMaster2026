-- ============================================================
-- US-02 - Inicio de sesion
-- Script completo para presentacion en SQLiteOnline
-- ============================================================

-- 1. ESTRUCTURA DDL

PRAGMA foreign_keys = OFF;

DROP TRIGGER IF EXISTS validate_login_credentials;
DROP TABLE IF EXISTS audit_events;
DROP TABLE IF EXISTS auth_sessions;
DROP TABLE IF EXISTS login_attempts;
DROP TABLE IF EXISTS users;

PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'ACTIVE'
    CHECK (status IN ('ACTIVE', 'BLOCKED', 'DELETED')),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE login_attempts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  submitted_email TEXT NOT NULL,
  submitted_password_hash TEXT NOT NULL,
  result TEXT NOT NULL CHECK (result IN ('SUCCESS', 'FAILED')),
  message TEXT NOT NULL,
  attempted_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE auth_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  session_token TEXT NOT NULL UNIQUE,
  status TEXT NOT NULL DEFAULT 'ACTIVE'
    CHECK (status IN ('ACTIVE', 'EXPIRED', 'REVOKED')),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE audit_events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  event_type TEXT NOT NULL,
  description TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TRIGGER validate_login_credentials
BEFORE INSERT ON login_attempts
WHEN NEW.result = 'SUCCESS'
  AND NOT EXISTS (
    SELECT 1
    FROM users
    WHERE email = NEW.submitted_email
      AND password_hash = NEW.submitted_password_hash
      AND status = 'ACTIVE'
  )
BEGIN
  SELECT RAISE(ABORT, 'Credenciales incorrectas');
END;

SELECT type, name
FROM sqlite_master
WHERE type IN ('table', 'trigger')
  AND name NOT LIKE 'sqlite_%'
ORDER BY type, name;

-- 2. PREPARACION DML

INSERT INTO users (
  full_name,
  email,
  password_hash,
  status
) VALUES
  (
    'Santiago Pizarro',
    'santiago.pizarro@example.com',
    'hash_clave_segura_123',
    'ACTIVE'
  ),
  (
    'Usuario Bloqueado',
    'bloqueado@example.com',
    'hash_clave_bloqueada_456',
    'BLOCKED'
  );

SELECT id, full_name, email, status, created_at
FROM users
ORDER BY id;

-- 3. TC-US2-01 - INICIO DE SESION EXITOSO

INSERT INTO login_attempts (
  submitted_email,
  submitted_password_hash,
  result,
  message
) VALUES (
  'santiago.pizarro@example.com',
  'hash_clave_segura_123',
  'SUCCESS',
  'Inicio de sesion exitoso'
);

INSERT INTO auth_sessions (
  user_id,
  session_token,
  status,
  expires_at
)
SELECT
  id,
  'session_us2_0001',
  'ACTIVE',
  datetime('now', '+8 hours')
FROM users
WHERE email = 'santiago.pizarro@example.com'
  AND password_hash = 'hash_clave_segura_123'
  AND status = 'ACTIVE';

INSERT INTO audit_events (
  user_id,
  event_type,
  description
) VALUES (
  1,
  'LOGIN_SUCCESS',
  'El usuario inicio sesion correctamente.'
);

SELECT
  u.id AS user_id,
  u.full_name,
  u.email,
  s.id AS session_id,
  s.session_token,
  s.status AS session_status,
  s.created_at,
  s.expires_at
FROM auth_sessions s
JOIN users u ON u.id = s.user_id
WHERE s.session_token = 'session_us2_0001';

SELECT event_type, description, created_at
FROM audit_events
WHERE user_id = 1
  AND event_type = 'LOGIN_SUCCESS';

-- 4. TC-US2-02 - CREDENCIALES INCORRECTAS
-- IMPORTANTE: la siguiente sentencia debe fallar.

INSERT INTO login_attempts (
  submitted_email,
  submitted_password_hash,
  result,
  message
) VALUES (
  'santiago.pizarro@example.com',
  'hash_contrasena_incorrecta',
  'SUCCESS',
  'Inicio de sesion exitoso'
);

-- Resultado esperado:
-- Credenciales incorrectas
