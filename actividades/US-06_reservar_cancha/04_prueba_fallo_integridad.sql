PRAGMA foreign_keys = ON;

INSERT INTO reservations (user_id, court_id, slot_id, status, total_amount)
VALUES (999, 1, 2, 'CONFIRMED', 28000);

-- Resultado esperado:
-- SQLite debe rechazar la operacion con un error de integridad:
-- FOREIGN KEY constraint failed
-- Motivo: no existe un usuario con id = 999 en la tabla users.

