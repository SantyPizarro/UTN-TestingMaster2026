-- US-23 - Crear Cancha
-- Caso: TC-US23-01 - Creación exitosa de cancha.

PRAGMA foreign_keys = ON;

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

-- Resultado esperado:
-- La cancha se crea y aparece correctamente en el listado.
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

