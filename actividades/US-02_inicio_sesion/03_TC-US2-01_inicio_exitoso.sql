-- US-02 - Inicio de sesion
-- Caso: TC-US2-01 - Inicio de sesion exitoso.

PRAGMA foreign_keys = ON;

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

-- Resultado esperado:
-- El usuario accede y se crea una sesion activa.
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

SELECT
  event_type,
  description,
  created_at
FROM audit_events
WHERE user_id = 1
  AND event_type = 'LOGIN_SUCCESS';
