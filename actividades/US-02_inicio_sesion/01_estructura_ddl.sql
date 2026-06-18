-- US-02 - Inicio de sesion
-- Seccion 1: estructura de la base de datos.

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

-- Simula la validacion del backend antes de aprobar el acceso.
-- El mensaje es generico para no revelar si fallo el correo o la contrasena.
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

SELECT
  type,
  name
FROM sqlite_master
WHERE type IN ('table', 'trigger')
  AND name NOT LIKE 'sqlite_%'
ORDER BY type, name;
