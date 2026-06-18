-- US-02 - Inicio de sesion
-- Seccion 2: datos de preparacion.

PRAGMA foreign_keys = ON;

-- Los hashes son valores simulados para esta actividad.
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

SELECT
  id,
  full_name,
  email,
  status,
  created_at
FROM users
ORDER BY id;
