-- US-23 - Crear Cancha
-- Prueba negativa: validación de un campo obligatorio.

PRAGMA foreign_keys = ON;

-- El nombre es obligatorio según los criterios de aceptación.
-- Este INSERT debe fallar porque name recibe NULL.
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
-- La cancha no debe registrarse.

